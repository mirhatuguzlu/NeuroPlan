import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/plan/plan_source.dart';
import '../../../data/repositories/sleep_window.dart';
import '../../core/app_shell.dart';
import '../../core/format.dart';
import '../../core/location.dart';
import '../../core/prayer_fields.dart';
import '../../core/states.dart';
import '../../core/theme_choice.dart';
import 'account_tiles.dart';
import 'data_tiles.dart';
import '../../core/wizard.dart';
import 'focus_settings.dart';
import 'notification_settings.dart';

/// Ayarlar: kurulumda verilen her kararın sonradan değiştirildiği yer (Aşama 5 §4).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final data = ref.watch(planDataProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: AsyncView<PlanData?>(
        value: data,
        onRetry: () => ref.invalidate(planDataProvider),
        data: (d) => d == null ? const SkeletonList() : _Settings(data: d),
      ),
    );
  }
}

class _Settings extends ConsumerWidget {
  const _Settings({required this.data});

  final PlanData data;

  Future<void> _update(
    BuildContext context,
    WidgetRef ref,
    ProfilesCompanion c,
  ) => guard(context, () => ref.read(profileRepositoryProvider).update(c));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = data.profile;
    final sleep = SleepWindow.find(data);
    Widget section(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.s),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );

    Future<void> saveSleep(int bed, int wake) => guard(
      context,
      () => SleepWindow.save(
        db: ref.read(databaseProvider),
        activities: ref.read(activityRepositoryProvider),
        existing: sleep,
        title: l.sleepActivityTitle,
        today: data.calendar
            .dayOf(DateTime.now().millisecondsSinceEpoch ~/ 60000)
            .iso,
        bed: bed,
        wake: wake,
      ),
    );

    return ListView(
      padding: EdgeInsets.only(bottom: AppShell.bottomInset(context)),
      children: [
        section(l.secGeneral),
        ExpansionTile(
          leading: const Icon(Symbols.translate_rounded),
          title: Text(l.settingLanguage),
          subtitle: Text(switch (p.locale) {
            'tr' => l.langTurkish,
            'en' => l.langEnglish,
            _ => l.langSystem,
          }),
          children: [
            ChoiceList<String?>(
              value: p.locale,
              options: [
                (null, l.langSystem, null),
                ('tr', l.langTurkish, null),
                ('en', l.langEnglish, null),
              ],
              onChanged: (v) =>
                  _update(context, ref, ProfilesCompanion(locale: Value(v))),
            ),
          ],
        ),
        ExpansionTile(
          leading: const Icon(Symbols.contrast_rounded),
          title: Text(l.settingAppearance),
          subtitle: Text(switch (p.themeMode) {
            'light' => l.modeLight,
            'dark' => l.modeDark,
            _ => l.modeSystem,
          }),
          children: [
            ChoiceList<String>(
              value: p.themeMode,
              options: [
                ('system', l.modeSystem, null),
                ('light', l.modeLight, null),
                ('dark', l.modeDark, null),
              ],
              onChanged: (v) =>
                  _update(context, ref, ProfilesCompanion(themeMode: Value(v))),
            ),
          ],
        ),
        ExpansionTile(
          leading: const Icon(Symbols.style_rounded),
          title: Text(l.settingTheme),
          subtitle: Text(themeName(l, AppTheme.of(p.theme))),
          children: [
            ThemeChoice(
              value: p.theme,
              onChanged: (v) =>
                  _update(context, ref, ProfilesCompanion(theme: Value(v))),
            ),
          ],
        ),
        SwitchListTile(
          secondary: const Icon(Symbols.vibration_rounded),
          title: Text(l.settingHaptics),
          value: p.hapticsEnabled,
          onChanged: (v) => _update(
            context,
            ref,
            ProfilesCompanion(hapticsEnabled: Value(v)),
          ),
        ),

        section(l.secPlan),
        ListTile(
          leading: const Icon(Symbols.bedtime_rounded),
          title: Text(l.settingSleep),
          subtitle: sleep == null ? Text(l.notSet) : null,
        ),
        TimeTile(
          label: l.sleepBedtime,
          minuteOfDay: sleep?.bed ?? 23 * 60,
          onChanged: (v) => saveSleep(v, sleep?.wake ?? 7 * 60),
        ),
        TimeTile(
          label: l.sleepWake,
          minuteOfDay: sleep?.wake ?? 7 * 60,
          onChanged: (v) => saveSleep(sleep?.bed ?? 23 * 60, v),
        ),
        _MinutesSetting(
          label: l.settingSleepGoal,
          value: p.sleepGoalMinutes,
          fallback: durationText(l, defaultSleepGoalMinutes),
          min: 60,
          max: 1080,
          onCommit: (v) => _update(
            context,
            ref,
            ProfilesCompanion(sleepGoalMinutes: Value(v)),
          ),
        ),
        _MinutesSetting(
          label: l.settingMinChunk,
          value: p.minChunkMinutes,
          fallback: durationText(l, defaultMinChunk),
          onCommit: (v) => _update(
            context,
            ref,
            ProfilesCompanion(minChunkMinutes: Value(v)),
          ),
        ),
        _MinutesSetting(
          label: l.settingBuffer,
          value: p.chunkBufferMinutes,
          fallback: durationText(l, defaultChunkBuffer),
          min: 0,
          onCommit: (v) => _update(
            context,
            ref,
            ProfilesCompanion(chunkBufferMinutes: Value(v)),
          ),
        ),
        _MinutesSetting(
          label: l.settingDailyCap,
          value: p.dailyFocusCapMinutes,
          fallback: l.noLimit,
          onCommit: (v) => _update(
            context,
            ref,
            ProfilesCompanion(dailyFocusCapMinutes: Value(v)),
          ),
        ),

        section(l.secLocation),
        _LocationTile(profile: p),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.s),
          child: PrayerFields(
            method: p.prayerMethod,
            madhab: p.prayerMadhab ?? 'shafi',
            hasLocation: p.locationLat != null,
            onChanged: (m, h) => _update(
              context,
              ref,
              ProfilesCompanion(
                prayerMethod: Value(m),
                prayerMadhab: Value(m == null ? null : h),
              ),
            ),
          ),
        ),

        section(l.secNotifications),
        const NotificationSettings(),

        section(l.secFocus),
        const FocusSettingsTiles(),

        section(l.secAccount),
        const AccountTiles(),

        section(l.secData),
        const ExportTile(),
        ListTile(
          leading: const Icon(Symbols.science_rounded),
          title: Text(l.sourcesTitle),
          subtitle: Text(l.sourcesSubtitle),
          trailing: const Icon(Symbols.chevron_right_rounded),
          onTap: () => context.push('/profile/sources'),
        ),

        section(l.secAbout),
        ListTile(
          leading: const Icon(Symbols.info_rounded),
          title: Text(l.aboutTitle),
          subtitle: Text(l.aboutSubtitle),
          trailing: const Icon(Symbols.chevron_right_rounded),
          onTap: () => context.push('/profile/about'),
        ),
      ],
    );
  }
}

class _LocationTile extends ConsumerStatefulWidget {
  const _LocationTile({required this.profile});

  final Profile profile;

  @override
  ConsumerState<_LocationTile> createState() => _LocationTileState();
}

class _LocationTileState extends ConsumerState<_LocationTile> {
  LocateResult? _result;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = widget.profile;
    final has = p.locationLat != null && p.locationLon != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Symbols.location_on_rounded),
          title: Text(l.settingLocation),
          subtitle: Text(
            has
                ? l.locationValue(
                    p.locationLat!.toStringAsFixed(1),
                    p.locationLon!.toStringAsFixed(1),
                  )
                : l.notSet,
          ),
          trailing: has
              ? IconButton(
                  tooltip: l.locationRemove,
                  icon: const Icon(Symbols.delete_rounded),
                  onPressed: () => guard(
                    context,
                    () => ref
                        .read(profileRepositoryProvider)
                        .update(
                          const ProfilesCompanion(
                            locationLat: Value(null),
                            locationLon: Value(null),
                          ),
                        ),
                  ),
                )
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.l),
          child: BusyButton(
            tonal: true,
            label: l.locationAllow,
            onPressed: () async {
              final r = await locateAndSave(
                ref.read(profileRepositoryProvider),
              );
              if (mounted) setState(() => _result = r);
            },
          ),
        ),
        if (_result != null && _result != LocateResult.saved)
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, 0),
            child: Semantics(
              liveRegion: true,
              child: Text(
                _result == LocateResult.denied
                    ? l.locationDenied
                    : l.locationError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
      ],
    );
  }
}

/// Dakika ayarı: boş = motor varsayılanı; alandan çıkınca ya da onaylayınca kaydedilir.
class _MinutesSetting extends StatefulWidget {
  const _MinutesSetting({
    required this.label,
    required this.value,
    required this.fallback,
    required this.onCommit,
    this.min = 5,
    this.max = 1440,
  });

  final String label;
  final int? value;
  final String fallback;
  final int min;
  final int max;
  final ValueChanged<int?> onCommit;

  @override
  State<_MinutesSetting> createState() => _MinutesSettingState();
}

class _MinutesSettingState extends State<_MinutesSetting> {
  late final _c = TextEditingController(text: widget.value?.toString() ?? '');
  late final _focus = FocusNode()..addListener(_onFocus);

  void _onFocus() {
    if (!_focus.hasFocus) _commit();
  }

  void _commit() {
    final n = int.tryParse(_c.text);
    final v = n != null && n >= widget.min && n <= widget.max ? n : null;
    if (v != widget.value) widget.onCommit(v);
  }

  @override
  void dispose() {
    _focus.dispose();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.s),
    child: TextFormField(
      controller: _c,
      focusNode: _focus,
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: context.l10n.engineDefault(widget.fallback),
        suffixText: context.l10n.wizMinutes,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return null;
        final n = int.tryParse(v);
        return n == null || n < widget.min || n > widget.max
            ? context.l10n.wizNumberError(widget.min, widget.max)
            : null;
      },
      onFieldSubmitted: (_) => _commit(),
    ),
  );
}
