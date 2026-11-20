import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/theme.dart';
import '../../core/app_shell.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../stats/stats_page.dart';
import '../stats/stats_providers.dart';

/// Profil: bu haftanın özeti ve analizlere giriş (Aşama 5 §1). Ayarlar ayrı ekrandadır.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.profileTitle),
        actions: [
          IconButton(
            tooltip: l.settingsTitle,
            icon: const Icon(Symbols.settings_rounded),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
      body: AsyncView<StatsContext>(
        value: ref.watch(statsContextProvider),
        onRetry: () => ref.invalidate(statsSourceProvider),
        data: (s) => ListView(
          padding: EdgeInsets.fromLTRB(
            Gap.l,
            Gap.s,
            Gap.l,
            AppShell.bottomInset(context),
          ),
          children: [
            _Summary(s: s),
            const SizedBox(height: Gap.xl),
            Semantics(
              header: true,
              child: Text(
                l.pfAnalyses,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: Gap.s),
            for (final p in StatPage.values)
              ListTile(
                leading: _ListBadge(icon: p.icon, index: p.index),
                title: Text(p.question(l)),
                trailing: const Icon(Symbols.chevron_right_rounded),
                onTap: () => context.push('/profile/stats/${p.name}'),
              ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.s});
  final StatsContext s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final week = DayRange.weekOf(s.today);
    final summary = weekSummary(s.sessions, const [], week, s.today, s.cal);
    final last = weekSummary(
      s.sessions,
      const [],
      week.previous,
      s.today,
      s.cal,
    );
    final hist = ref.watch(planHistoryProvider(week));
    final adh = hist.whenData((h) => adherence(h.items, week, s.today));
    final st = streaks(s.sessions, s.cal, s.today);
    final strongest = s.brain.regions.values
        .where((r) => r.total > 0)
        .fold<RegionState?>(
          null,
          (a, r) => a == null || r.total > a.total ? r : a,
        );
    final cards = [
      _Card(
        icon: Symbols.timer_rounded,
        label: l.pfWeekFocus,
        value: durationText(l, summary.focusMinutes),
        sub: l.pfLastWeek(durationText(l, last.focusMinutes)),
        page: StatPage.time,
      ),
      _Card(
        icon: Symbols.task_alt_rounded,
        label: l.pfAdherence,
        value: switch (adh) {
          AsyncData(value: Adherence(percent: final p?)) => l.stPercent(
            p.round(),
          ),
          AsyncData() => '–',
          _ => '…',
        },
        sub: switch (adh) {
          AsyncData(value: final a) when a.planned > 0 => l.stDoneOf(
            a.done,
            a.planned,
          ),
          AsyncData() => l.pfNoPlanYet,
          _ => l.stLoading,
        },
        page: StatPage.adherence,
      ),
      _Card(
        icon: Symbols.local_fire_department_rounded,
        label: l.pfStreak,
        value: l.stDays(st.current),
        sub: l.pfLongest(st.longest),
        page: StatPage.consistency,
      ),
      _Card(
        icon: Symbols.psychology_rounded,
        label: l.pfStrongest,
        value: strongest == null
            ? '–'
            : s.regions[strongest.key]?.name(context) ?? strongest.key,
        sub: strongest == null
            ? l.pfStrongestEmpty
            : l.stNeurons(strongest.total ~/ unitsPerNeuron),
        page: StatPage.brain,
      ),
    ];
    return LayoutBuilder(
      builder: (context, box) {
        // Dar ekran ya da büyük yazı: tek sütun; tablet / yatay: dört sütun.
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final cols = box.maxWidth < 320 || scale > 1.5
            ? 1
            : box.maxWidth >= 640 && scale <= 1.2
            ? 4
            : 2;
        final w = (box.maxWidth - Gap.m * (cols - 1)) / cols;
        return Wrap(
          spacing: Gap.m,
          runSpacing: Gap.m,
          children: [
            for (final c in cards) SizedBox(width: math.max(0, w), child: c),
          ],
        );
      },
    );
  }
}

/// Analiz listesinin ikonu: renkli temalarda renkli dairede, diğerlerinde yalın.
class _ListBadge extends StatelessWidget {
  const _ListBadge({required this.icon, required this.index});
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    final tint = AppTokens.tint(context, index);
    if (tint == null) return Icon(icon);
    return CircleAvatar(
      radius: 20,
      backgroundColor: tint,
      child: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.page,
  });

  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final StatPage page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      // Renkli temalarda her kart kendi rengini alır (D55).
      color: AppTokens.tint(context, page.index),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/profile/stats/${page.name}'),
        child: Semantics(
          button: true,
          child: Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Icon(icon, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: Gap.s),
                Text(label, style: theme.textTheme.labelLarge),
                const SizedBox(height: Gap.xs),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Gap.xs),
                Text(
                  sub,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
