import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/remote/social_api.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'together_providers.dart';
import 'together_widgets.dart';

/// Arkadaşın / partnerin planı: bugün ve hafta, salt okunur. Görünürlük sunucuda uygulanır.
class FriendPlanScreen extends ConsumerStatefulWidget {
  const FriendPlanScreen({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<FriendPlanScreen> createState() => _FriendPlanScreenState();
}

class _FriendPlanScreenState extends ConsumerState<FriendPlanScreen> {
  var _week = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final name =
        ref
            .watch(friendsProvider)
            .value
            ?.friends
            .where((f) => f.userId == widget.userId)
            .firstOrNull
            ?.displayName ??
        '';
    final roots = {
      for (final r
          in ref.watch(rootCategoriesProvider).value ?? const <RootCategory>[])
        r.key: r,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l.tgPlanOf(name))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(l.navToday)),
                ButtonSegment(value: true, label: Text(l.tgWeek)),
              ],
              selected: {_week},
              onSelectionChanged: (s) => setState(() => _week = s.first),
            ),
          ),
          Expanded(
            child: SocialAsync<List<CalendarEntry>>(
              value: ref.watch(friendCalendarProvider(widget.userId)),
              onRetry: () =>
                  ref.invalidate(friendCalendarProvider(widget.userId)),
              data: (all) {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final end = today.add(Duration(days: _week ? 7 : 1));
                final items = [
                  for (final e in all)
                    if (e.end.isAfter(today) && e.start.isBefore(end)) e,
                ];
                if (items.isEmpty) {
                  return MessageState(
                    icon: Symbols.event_busy_rounded,
                    title: l.tgPlanEmptyTitle,
                    body: l.tgPlanEmptyBody(name),
                  );
                }
                final rows = <Widget>[];
                DateTime? day;
                for (final e in items) {
                  final d = DateTime(e.start.year, e.start.month, e.start.day);
                  if (_week && d != day) {
                    day = d;
                    rows.add(
                      SectionTitle(
                        DateFormat.MMMMEEEEd(context.localeName).format(d),
                      ),
                    );
                  }
                  final root = roots[e.rootCategoryKey];
                  rows.add(
                    MergeSemantics(
                      child: ListTile(
                        leading: root == null
                            ? const Icon(Symbols.schedule_rounded)
                            : RootBadge(
                                rootKey: root.key,
                                icon: root.icon,
                                color: root.color,
                              ),
                        title: Text(e.title ?? l.tgBusy),
                        subtitle: Text(
                          [
                            timeRangeText(context, e.start, e.end),
                            if (root != null) root.name(context),
                            if (e.notes != null) e.notes!,
                          ].join(' · '),
                        ),
                      ),
                    ),
                  );
                }
                return ListView(
                  children: [
                    ...rows,
                    Padding(
                      padding: const EdgeInsets.all(Gap.l),
                      child: Text(
                        l.tgPlanReadOnly,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Gizlilik: profil görünürlüğü ve kategori bazında plan görünürlüğü (kitle: partner / arkadaşlar).
class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  var _audience = 'partner';
  final _name = TextEditingController();
  var _nameLoaded = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(
    SocialProfile p, {
    String? name,
    bool? discoverable,
    bool? global,
    bool? brain,
  }) async {
    await socialAction(
      context,
      () => ref
          .read(socialApiProvider)!
          .saveProfile(
            displayName: name ?? p.displayName,
            username: p.username,
            discoverable: discoverable ?? p.discoverable,
            globalLeaderboard: global ?? p.globalLeaderboard,
            shareBrain: brain ?? p.shareBrain,
          ),
    );
    ref.invalidate(socialStatusProvider);
  }

  Future<void> _pickLevel(
    String? categoryId,
    String? rootKey,
    String? current,
  ) async {
    final l = context.l10n;
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: RadioGroup<String>(
          groupValue: current ?? 'default',
          onChanged: (v) => Navigator.pop(c, v),
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final level in [
                'default',
                'full',
                'title_time',
                'busy',
                'hidden',
              ])
                RadioListTile<String>(
                  value: level,
                  title: Text(
                    level == 'default'
                        ? '${l.tgLevelDefault} (${levelText(l, _audience == 'partner' ? 'title_time' : 'busy')})'
                        : levelText(l, level),
                  ),
                  subtitle: Text(switch (level) {
                    'full' => l.tgLevelFullBody,
                    'title_time' => l.tgLevelTitleTimeBody,
                    'busy' => l.tgLevelBusyBody,
                    'hidden' => l.tgLevelHiddenBody,
                    _ => l.tgLevelDefaultBody,
                  }),
                ),
            ],
          ),
        ),
      ),
    );
    if (choice == null || !mounted) return;
    await socialAction(
      context,
      () => ref
          .read(socialApiProvider)!
          .setVisibility(
            level: choice == 'default' ? null : choice,
            audience: _audience,
            categoryId: categoryId,
            rootKey: rootKey,
          ),
    );
    ref.invalidate(visibilityRulesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final status = ref.watch(socialStatusProvider).value;
    final p = status?.profile;
    if (p != null && !_nameLoaded) {
      _name.text = p.displayName;
      _nameLoaded = true;
    }
    final adult = status?.tier == SocialTier.adult;
    final rules = ref.watch(visibilityRulesProvider);
    final roots =
        ref.watch(rootCategoriesProvider).value ?? const <RootCategory>[];
    final cats = ref.watch(categoriesProvider).value ?? const <UserCategory>[];
    String? levelFor(String? categoryId, String? rootKey) =>
        rules.value
                ?.where(
                  (r) =>
                      r['audience'] == _audience &&
                      r['viewer_id'] == null &&
                      r['category_id'] == categoryId &&
                      r['root_category_key'] == rootKey,
                )
                .firstOrNull?['level']
            as String?;

    Widget levelTile(
      Widget leading,
      String title,
      String? categoryId,
      String? rootKey, {
      double indent = 0,
    }) {
      final level = levelFor(categoryId, rootKey);
      return Padding(
        padding: EdgeInsets.only(left: indent),
        child: ListTile(
          leading: leading,
          title: Text(title),
          subtitle: Text(levelText(l, level)),
          trailing: const Icon(Symbols.expand_more_rounded),
          onTap: () => _pickLevel(categoryId, rootKey, level),
        ),
      );
    }

    List<Widget> subtree(String root, String? parent, double indent) => [
      for (final c in cats.where(
        (c) =>
            c.rootCategoryKey == root &&
            c.parentId == parent &&
            c.deletedAt == null,
      )) ...[
        levelTile(
          const Icon(Symbols.folder_rounded),
          c.name,
          c.id,
          null,
          indent: indent,
        ),
        ...subtree(root, c.id, indent + Gap.l),
      ],
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l.tgPrivacy)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: Gap.xxl),
        children: [
          if (p != null) ...[
            SectionTitle(l.tgSecProfile),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.l),
              child: TextField(
                controller: _name,
                maxLength: 40,
                decoration: InputDecoration(
                  labelText: l.tgDisplayName,
                  suffixIcon: IconButton(
                    tooltip: l.commonSave,
                    icon: const Icon(Symbols.check_rounded),
                    onPressed: () {
                      final n = _name.text.trim();
                      if (n.isNotEmpty) _saveProfile(p, name: n);
                    },
                  ),
                ),
              ),
            ),
            SwitchListTile(
              title: Text(l.tgDiscoverable),
              subtitle: Text(
                p.username == null
                    ? l.tgDiscoverableNoUsername
                    : l.tgDiscoverableBody(p.username!),
              ),
              value: p.discoverable,
              onChanged: p.username == null
                  ? null
                  : (v) => _saveProfile(p, discoverable: v),
            ),
            SwitchListTile(
              title: Text(l.tgGlobalBoard),
              subtitle: Text(
                adult ? l.tgGlobalBoardBody : l.tgGlobalBoardMinor,
              ),
              value: p.globalLeaderboard,
              onChanged: adult ? (v) => _saveProfile(p, global: v) : null,
            ),
            SwitchListTile(
              title: Text(l.tgShareBrain),
              subtitle: Text(l.tgShareBrainBody),
              value: p.shareBrain,
              onChanged: (v) => _saveProfile(p, brain: v),
            ),
          ],
          SectionTitle(l.tgSecPlanVisibility),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.l),
            child: Text(l.tgPlanVisibilityBody),
          ),
          Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'partner', label: Text(l.tgPartner)),
                ButtonSegment(value: 'friends', label: Text(l.tgFriends)),
              ],
              selected: {_audience},
              onSelectionChanged: (s) => setState(() => _audience = s.first),
            ),
          ),
          SocialAsync<List<Json>>(
            value: rules,
            onRetry: () => ref.invalidate(visibilityRulesProvider),
            data: (_) => Column(
              children: [
                levelTile(
                  const Icon(Symbols.select_all_rounded),
                  l.tgAllCategories,
                  null,
                  null,
                ),
                for (final r in roots) ...[
                  levelTile(
                    RootBadge(rootKey: r.key, icon: r.icon, color: r.color),
                    r.name(context),
                    null,
                    r.key,
                  ),
                  ...subtree(r.key, null, Gap.xl),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: Text(
              l.tgVisibilityFootnote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
