import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/plan/plan_source.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../../core/summaries.dart';
import '../../core/wizard.dart';
import 'category_picker.dart';
import 'draft.dart';

/// Aktivite ekleme sihirbazı (PLAN-1): her soru ayrı adım, isteğe bağlılar atlanabilir.
/// [editId] ve [step] verilirse kayıtlı işin yalnız o adımı açılır ve Kaydet onu yazar (D64).
class ActivityWizardScreen extends ConsumerStatefulWidget {
  const ActivityWizardScreen({super.key, this.editId, this.step});

  final String? editId;
  final String? step;

  @override
  ConsumerState<ActivityWizardScreen> createState() => _ActivityWizardState();
}

class _ActivityWizardState extends ConsumerState<ActivityWizardScreen> {
  ActivityDraft? _edit;

  bool get _editing => widget.editId != null;

  ActivityDraft get d => _edit ?? ref.read(activityDraftProvider);

  void _set(VoidCallback change) => setState(change);

  void _close() => context.canPop() ? context.pop() : context.go('/today');

  String _today(PlanData data) => data.calendar
      .dayOf(
        (ref.read(nowProvider).value ?? DateTime.now())
                .millisecondsSinceEpoch ~/
            60000,
      )
      .iso;

  Future<void> _save(PlanData data) async {
    if (_editing) {
      await d.update(
        ref.read(databaseProvider),
        ref.read(activityRepositoryProvider),
        data.calendar,
        step: widget.step!,
        today: _today(data),
      );
      if (!mounted) return;
      showSnack(context, context.l10n.editSaved(d.title.trim()));
      _close();
      return;
    }
    final saved = await d.save(
      ref.read(databaseProvider),
      ref.read(activityRepositoryProvider),
      data.calendar,
    );
    ref.invalidate(activityDraftProvider);
    if (!mounted) return;
    showSnack(context, context.l10n.wizSaved(saved.title));
    _close();
  }

  @override
  Widget build(BuildContext context) => switch (ref.watch(planDataProvider)) {
    AsyncData(value: final data?) => _wizard(context, data),
    AsyncError() => Scaffold(
      body: ErrorState(onRetry: () => ref.invalidate(planDataProvider)),
    ),
    _ => const Scaffold(body: SkeletonList()),
  };

  Widget _wizard(BuildContext context, PlanData data) {
    final l = context.l10n;
    if (_editing && _edit == null) {
      _edit = ActivityDraft.edit(data, widget.editId!, _today(data));
      // Açılan adımın değeri taslaktan yeniden kurulur; diğerleri aynen kalır.
      if (widget.step == 'when') _edit?.keepRecurrence = null;
      if (widget.step == 'time') _edit?.keepTiming = null;
    }
    var steps = <WizardStep>[
      _what(l),
      WizardStep(
        id: 'category',
        title: l.wizCategoryTitle,
        optional: true,
        body: CategoryPicker(
          categoryId: d.categoryId,
          rootKey: d.rootKey,
          onChanged: (cat, root) => _set(() {
            d.categoryId = cat;
            d.rootKey = root;
          }),
        ),
      ),
      if (d.isProject) ...[
        _deadline(l),
        _total(l),
        if (d.kind == 'project') _chunks(l),
      ] else ...[
        _when(l),
        _time(l, data),
        _flex(l),
        WizardStep(
          id: 'duration',
          title: l.wizDurationTitle,
          optional: true,
          body: NumberField(
            label: l.wizMinutes,
            value: d.duration,
            onChanged: (v) => d.duration = v,
          ),
        ),
        if (d.hasVariants) _variants(l),
      ],
      if (d.hasFocus) _focus(l),
      WizardStep(
        id: 'summary',
        title: l.wizSummaryTitle,
        body: ActivitySummary(draft: d, data: data),
      ),
    ];
    if (_editing) {
      // "Şimdilik geç" yalnız temizleyen adımda kalır (son tarih, varyant, odak).
      steps = [
        for (final s in steps)
          if (s.id == widget.step)
            WizardStep(
              id: s.id,
              title: s.title,
              subtitle: s.subtitle,
              body: s.body,
              optional: s.onSkip != null,
              canNext: s.canNext,
              onNext: s.onNext,
              onSkip: s.onSkip,
            ),
      ];
      if (_edit == null || steps.isEmpty) {
        return Scaffold(
          appBar: AppBar(),
          body: MessageState(
            icon: Symbols.info_rounded,
            title: l.focusMissingTitle,
            body: l.focusMissingBody,
            actionLabel: l.commonBack,
            onAction: _close,
          ),
        );
      }
    }
    return WizardScaffold(
      steps: steps,
      onClose: _close,
      onFinish: () => _save(data),
    );
  }

  WizardStep _what(L10n l) => WizardStep(
    id: 'what',
    title: l.wizWhatTitle,
    canNext: d.title.trim().isNotEmpty,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: d.title,
          autofocus: d.title.isEmpty,
          maxLength: 200,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l.wizWhatLabel),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) =>
              v == null || v.trim().isEmpty ? l.wizWhatError : null,
          onChanged: (v) => _set(() => d.title = v),
        ),
        // Tür düzenlemede değişmez (D64): kural, varyant ve proje verisi türe bağlı.
        if (!_editing) ...[
          const SizedBox(height: Gap.l),
          Text(l.wizKind, style: Theme.of(context).textTheme.titleSmall),
          ChoiceList<String>(
            value: d.kind,
            options: [
              ('routine', l.kindRoutine, null),
              ('one_off', l.kindOneOff, null),
              ('task', l.kindTask, null),
              ('project', l.kindProject, null),
              ('free_time', l.kindFreeTime, null),
              ('travel_prep', l.kindTravel, null),
            ],
            onChanged: (k) => _set(() {
              d.kind = k;
              if (k == 'one_off') d.rec = RecType.once;
            }),
          ),
        ],
      ],
    ),
  );

  WizardStep _when(L10n l) {
    final body = <Widget>[
      ChoiceList<RecType>(
        value: d.rec,
        options: [
          (RecType.once, l.recTypeOnce, null),
          (RecType.daily, l.recTypeDaily, null),
          (RecType.weekly, l.recTypeWeekly, null),
          (RecType.everyN, l.recTypeEveryN, null),
          (RecType.monthly, l.recTypeMonthly, null),
          (RecType.cycle, l.recTypeCycle, null),
          (RecType.dates, l.recTypeDates, null),
          (RecType.perPeriod, l.recTypePerPeriod, null),
          (RecType.follow, l.recTypeFollow, null),
        ],
        onChanged: (r) => _set(() {
          d.rec = r;
          if (r == RecType.follow) d.time = TimeType.relative;
        }),
      ),
      const Divider(height: Gap.xl),
      ..._recFields(l),
    ];
    final valid = switch (d.rec) {
      RecType.weekly => d.weekdays.isNotEmpty,
      RecType.dates => d.dates.isNotEmpty,
      _ => true,
    };
    return WizardStep(
      id: 'when',
      title: l.wizWhenTitle,
      canNext: valid,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: body,
      ),
    );
  }

  List<Widget> _recFields(L10n l) {
    Widget startTile() => DateTile(
      label: l.wizStartDate,
      date: d.start,
      onChanged: (v) => _set(() => d.start = v),
    );
    Widget days(Set<int> selected, ValueChanged<int> toggle) => Wrap(
      spacing: Gap.s,
      runSpacing: Gap.s,
      children: [
        for (var w = 1; w <= 7; w++)
          FilterChip(
            label: Text(weekdayShort(context, w)),
            selected: selected.contains(w),
            onSelected: (_) => toggle(w),
          ),
      ],
    );
    return switch (d.rec) {
      RecType.once => [
        DateTile(
          label: l.wizDate,
          date: d.date,
          onChanged: (v) => _set(() => d.date = v),
        ),
      ],
      RecType.daily => [startTile()],
      RecType.weekly => [
        days(
          d.weekdays,
          (w) => _set(
            () => d.weekdays.contains(w)
                ? d.weekdays.remove(w)
                : d.weekdays.add(w),
          ),
        ),
        if (d.weekdays.isEmpty) _hint(l.wizPickDay),
        startTile(),
      ],
      RecType.everyN => [
        NumberField(
          label: l.wizEveryNDays,
          value: d.everyN,
          min: 2,
          max: 365,
          onChanged: (v) => d.everyN = v ?? 2,
        ),
        startTile(),
      ],
      RecType.monthly => [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(l.wizMonthByDay)),
            ButtonSegment(value: true, label: Text(l.wizMonthByWeek)),
          ],
          selected: {d.monthByWeek},
          onSelectionChanged: (s) => _set(() => d.monthByWeek = s.first),
        ),
        const SizedBox(height: Gap.l),
        if (!d.monthByWeek)
          NumberField(
            label: l.wizMonthDay,
            value: d.monthDay,
            max: 31,
            onChanged: (v) => d.monthDay = v ?? 1,
          )
        else ...[
          DropdownMenu<int>(
            label: Text(l.wizNth),
            initialSelection: d.nth,
            onSelected: (v) => _set(() => d.nth = v ?? 1),
            dropdownMenuEntries: [
              for (var n = 1; n <= 4; n++)
                DropdownMenuEntry(value: n, label: '$n.'),
              DropdownMenuEntry(value: -1, label: l.nthLast),
            ],
          ),
          const SizedBox(height: Gap.m),
          days({d.nthWeekday}, (w) => _set(() => d.nthWeekday = w)),
        ],
        startTile(),
      ],
      RecType.cycle => [
        NumberField(
          label: l.wizCycleOn,
          value: d.cycleOn,
          max: 180,
          onChanged: (v) => d.cycleOn = v ?? 1,
        ),
        const SizedBox(height: Gap.m),
        NumberField(
          label: l.wizCycleOff,
          value: d.cycleOff,
          max: 180,
          onChanged: (v) => d.cycleOff = v ?? 1,
        ),
        startTile(),
      ],
      RecType.dates => [
        for (final (i, date) in d.dates.indexed)
          DateTile(
            label: l.wizDate,
            date: date,
            onChanged: (v) => _set(() => d.dates[i] = v),
            trailing: IconButton(
              tooltip: l.commonDelete,
              icon: const Icon(Symbols.delete_rounded),
              onPressed: () => _set(() => d.dates.removeAt(i)),
            ),
          ),
        if (d.dates.isEmpty) _hint(l.wizPickDate),
        OutlinedButton.icon(
          icon: const Icon(Symbols.add_rounded),
          label: Text(l.wizAddDate),
          onPressed: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: DateTime(now.year - 1),
              lastDate: DateTime(now.year + 5),
            );
            if (picked != null) _set(() => d.dates.add(picked));
          },
        ),
      ],
      RecType.perPeriod => [
        NumberField(
          label: l.wizPerCount,
          value: d.perCount,
          max: 31,
          onChanged: (v) => d.perCount = v ?? 1,
        ),
        const SizedBox(height: Gap.m),
        SegmentedButton<PeriodUnit>(
          segments: [
            ButtonSegment(value: PeriodUnit.day, label: Text(l.unitDay)),
            ButtonSegment(value: PeriodUnit.week, label: Text(l.unitWeek)),
            ButtonSegment(value: PeriodUnit.month, label: Text(l.unitMonth)),
          ],
          selected: {d.perUnit},
          onSelectionChanged: (s) => _set(() => d.perUnit = s.first),
        ),
      ],
      RecType.follow => [_hint(l.wizFollowNote, error: false)],
    };
  }

  Widget _hint(String text, {bool error = true}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Gap.s),
    child: Text(
      text,
      style: TextStyle(
        color: error ? Theme.of(context).colorScheme.error : null,
      ),
    ),
  );

  WizardStep _time(L10n l, PlanData data) {
    final follow = d.rec == RecType.follow;
    final others = [
      for (final a in data.activities.values)
        if (a.kind != 'project' && a.kind != 'task' && a.id != widget.editId) a,
    ]..sort((a, b) => a.title.compareTo(b.title));
    final hasLocation = data.profile.locationLat != null;
    final prayer = data.profile.prayerMethod != null;
    final fields = switch (d.time) {
      TimeType.fixed => [
        TimeTile(
          label: l.wizStartTime,
          minuteOfDay: d.at,
          onChanged: (v) => _set(() => d.at = v),
        ),
      ],
      TimeType.window => [
        TimeTile(
          label: l.wizWindowFrom,
          minuteOfDay: d.windowFrom,
          onChanged: (v) => _set(() => d.windowFrom = v),
        ),
        TimeTile(
          label: l.wizWindowTo,
          minuteOfDay: d.windowTo,
          onChanged: (v) => _set(() => d.windowTo = v),
        ),
      ],
      // Yeni aktiviteye henüz kimse bağlı olmadığı için burada döngü oluşamaz.
      TimeType.relative when others.isEmpty => [_hint(l.wizNoActivities)],
      TimeType.relative => [
        DropdownMenu<String>(
          expandedInsets: EdgeInsets.zero,
          label: Text(l.wizRelativeTo),
          initialSelection: d.relActivity,
          onSelected: (v) => _set(() => d.relActivity = v),
          dropdownMenuEntries: [
            for (final a in others)
              DropdownMenuEntry(value: a.id, label: a.title),
          ],
        ),
        if (d.relActivity == null) _hint(l.wizPickActivity),
        ChoiceList<bool>(
          value: d.relAfterEnd,
          options: [
            (true, l.relAfterEnd, null),
            (false, l.relBeforeStart, null),
          ],
          onChanged: (v) => _set(() => d.relAfterEnd = v),
        ),
        NumberField(
          label: l.wizOffset,
          value: d.relOffset,
          min: 0,
          onChanged: (v) => d.relOffset = v ?? 0,
        ),
      ],
      TimeType.astro => [
        if (!hasLocation) _hint(l.wizAstroNeedsLocation),
        DropdownMenu<AstroEvent>(
          expandedInsets: EdgeInsets.zero,
          label: Text(l.wizAstroEvent),
          initialSelection: d.astro,
          onSelected: (v) => _set(() => d.astro = v ?? AstroEvent.sunrise),
          dropdownMenuEntries: [
            for (final e in AstroEvent.values)
              if (prayer || e == AstroEvent.sunrise || e == AstroEvent.sunset)
                DropdownMenuEntry(value: e, label: l.astroEvent(e.name)),
          ],
        ),
        const SizedBox(height: Gap.m),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: true, label: Text(l.astroBefore)),
            ButtonSegment(value: false, label: Text(l.astroAfter)),
          ],
          selected: {d.astroBefore},
          onSelectionChanged: (s) => _set(() => d.astroBefore = s.first),
        ),
        const SizedBox(height: Gap.m),
        NumberField(
          label: l.wizOffset,
          value: d.astroOffset,
          min: 0,
          onChanged: (v) => d.astroOffset = v ?? 0,
        ),
      ],
      TimeType.none => <Widget>[],
    };
    final valid = switch (d.time) {
      TimeType.relative => d.relActivity != null,
      TimeType.astro => hasLocation,
      _ => true,
    };
    return WizardStep(
      id: 'time',
      title: l.wizTimeTitle,
      canNext: valid,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChoiceList<TimeType>(
            value: d.time,
            options: [
              if (!follow) (TimeType.fixed, l.timeTypeFixed, null),
              if (!follow) (TimeType.window, l.timeTypeWindow, null),
              (TimeType.relative, l.timeTypeRelative, null),
              if (!follow) (TimeType.astro, l.timeTypeAstro, null),
              if (!follow) (TimeType.none, l.timeTypeNone, null),
            ],
            onChanged: (t) => _set(() {
              d.time = t;
              d.flex = t == TimeType.window || t == TimeType.none
                  ? Flexibility.shiftable
                  : Flexibility.fixed;
            }),
          ),
          const Divider(height: Gap.xl),
          ...fields,
        ],
      ),
    );
  }

  /// Ayrı adım (tek soru kuralı); atlanırsa saat türüne göre seçilen varsayılan kalır.
  WizardStep _flex(L10n l) => WizardStep(
    id: 'flex',
    title: l.wizFlex,
    optional: true,
    body: ChoiceList<Flexibility>(
      value: d.flex,
      options: [
        (Flexibility.fixed, l.flexFixed, l.flexFixedHint),
        (Flexibility.shiftable, l.flexShiftable, l.flexShiftableHint),
        (Flexibility.optional, l.flexOptional, l.flexOptionalHint),
      ],
      onChanged: (f) => _set(() => d.flex = f),
    ),
  );

  WizardStep _variants(L10n l) {
    final valid =
        d.variants.isEmpty ||
        d.variants.where((v) => v.name.trim().isNotEmpty).length >= 2;
    return WizardStep(
      id: 'variants',
      title: l.wizVariantTitle,
      subtitle: l.wizVariantBody,
      optional: true,
      canNext: valid,
      onSkip: () async => _set(d.variants.clear),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, v) in d.variants.indexed)
            Card(
              key: ObjectKey(v),
              child: Padding(
                padding: const EdgeInsets.all(Gap.m),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: v.name,
                            maxLength: 100,
                            decoration: InputDecoration(
                              labelText: l.wizVariantName,
                            ),
                            onChanged: (s) => _set(() => v.name = s),
                          ),
                        ),
                        IconButton(
                          tooltip: l.wizVariantRemove,
                          icon: const Icon(Symbols.delete_rounded),
                          onPressed: () => _set(() {
                            d.variants.removeAt(i);
                            if (d.defaultVariant >= d.variants.length) {
                              d.defaultVariant = 0;
                            }
                          }),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.wizVariantCancels),
                      value: v.cancels,
                      onChanged: (c) => _set(() => v.cancels = c),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.wizVariantDefault),
                      value: d.defaultVariant == i,
                      onChanged: (_) => _set(() => d.defaultVariant = i),
                    ),
                  ],
                ),
              ),
            ),
          if (!valid) _hint(l.wizVariantMin),
          OutlinedButton.icon(
            icon: const Icon(Symbols.add_rounded),
            label: Text(l.wizVariantAdd),
            onPressed: () => _set(() => d.variants.add(VariantDraft(''))),
          ),
        ],
      ),
    );
  }

  WizardStep _focus(L10n l) => WizardStep(
    id: 'focus',
    title: l.wizFocusTitle,
    optional: true,
    onSkip: () async => _set(() => d.focus = null),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceList<bool>(
          value: d.focus,
          options: [(true, l.focusYes, null), (false, l.focusNo, null)],
          onChanged: (v) => _set(() => d.focus = v),
        ),
        if (d.focus == true) ...[
          const SizedBox(height: Gap.l),
          Text(l.wizFocusMode, style: Theme.of(context).textTheme.titleSmall),
          ChoiceList<String>(
            value: d.focusMode,
            options: [
              ('free', l.modeFree, null),
              ('pomodoro', l.modePomodoro, null),
              ('deep', l.modeDeep, null),
            ],
            onChanged: (m) => _set(() => d.focusMode = m),
          ),
          // Derin çalışma blok planı (D66): süre saf odaktır, molalar süreyi uzatır.
          if (d.isDeep) ...[
            const SizedBox(height: Gap.l),
            MinuteChips(
              label: l.wizFocusBlock,
              value: d.focusBlock,
              options: const [25, 40, 50, 60, 90],
              onChanged: (v) => _set(() => d.focusBlock = v),
            ),
            MinuteChips(
              label: l.wizFocusBreak,
              value: d.focusBreak,
              options: const [5, 10, 15, 20],
              onChanged: (v) => _set(() => d.focusBreak = v),
            ),
            if (d.duration case final m? when m > 0)
              _hint(
                l.focusBlockPlan(
                  FocusBlocks.countOf(m, d.focusBlock),
                  d.focusBlock,
                  d.focusBreak,
                  m,
                ),
                error: false,
              ),
            if (d.canSpread) ...[
              const SizedBox(height: Gap.m),
              Text(
                l.wizFocusSpread,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              ChoiceList<bool>(
                value: d.focusSpread,
                options: [
                  (false, l.focusSpreadNo, l.focusSpreadNoHint),
                  (true, l.focusSpreadYes, l.focusSpreadYesHint),
                ],
                onChanged: (v) => _set(() => d.focusSpread = v),
              ),
            ],
          ],
          if (d.hasGrace) ...[
            const SizedBox(height: Gap.l),
            MinuteChips(
              label: l.wizFocusGrace,
              value: d.focusGrace,
              options: const [5, 10, 15, 30],
              onChanged: (v) => _set(() => d.focusGrace = v),
            ),
            _hint(l.wizFocusGraceHint, error: false),
          ],
        ],
      ],
    ),
  );

  WizardStep _deadline(L10n l) => WizardStep(
    id: 'deadline',
    title: l.wizDeadlineTitle,
    optional: true,
    onSkip: () async => _set(() => d.deadline = null),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateTile(
          label: l.wizDate,
          date: d.deadline ?? DateTime.now().add(const Duration(days: 7)),
          onChanged: (v) => _set(() => d.deadline = v),
        ),
        if (d.deadline == null) _hint(l.wizDeadlineNone, error: false),
      ],
    ),
    onNext: () async {
      d.deadline ??= DateTime.now().add(const Duration(days: 7));
    },
  );

  WizardStep _total(L10n l) => WizardStep(
    id: 'total',
    title: l.wizTotalTitle,
    optional: true,
    body: Row(
      children: [
        Expanded(
          child: NumberField(
            label: l.wizHours,
            value: d.totalMinutes ~/ 60,
            min: 0,
            max: 999,
            onChanged: (h) =>
                d.totalMinutes = (h ?? 0) * 60 + d.totalMinutes % 60,
          ),
        ),
        const SizedBox(width: Gap.m),
        Expanded(
          child: NumberField(
            label: l.wizMinutes,
            value: d.totalMinutes % 60,
            min: 0,
            max: 59,
            onChanged: (m) =>
                d.totalMinutes = d.totalMinutes ~/ 60 * 60 + (m ?? 0),
          ),
        ),
      ],
    ),
  );

  WizardStep _chunks(L10n l) => WizardStep(
    id: 'chunks',
    title: l.wizChunksTitle,
    optional: true,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChoiceList<bool>(
          value: d.autoSplit,
          options: [(true, l.splitAuto, null), (false, l.splitManual, null)],
          onChanged: (v) => _set(() => d.autoSplit = v),
        ),
        const SizedBox(height: Gap.l),
        NumberField(
          label: l.wizMinChunk,
          value: d.minChunk,
          min: 5,
          max: 480,
          onChanged: (v) => d.minChunk = v,
        ),
        const SizedBox(height: Gap.m),
        NumberField(
          label: l.wizMaxChunk,
          value: d.maxChunk,
          min: 5,
          max: 720,
          onChanged: (v) => d.maxChunk = v,
        ),
        const SizedBox(height: Gap.m),
        NumberField(
          label: l.wizDailyCap,
          value: d.dailyCap,
          min: 5,
          max: 1440,
          onChanged: (v) => d.dailyCap = v,
        ),
      ],
    ),
  );
}

/// Taslağın özeti: sihirbazın son adımı ve düzenleme ekranı (D64). [onEdit] verilirse
/// her satır kendi adımını açar ve esneklik ile varyantlar her zaman görünür.
class ActivitySummary extends ConsumerWidget {
  const ActivitySummary({
    super.key,
    required this.draft,
    required this.data,
    this.onEdit,
  });

  final ActivityDraft draft;
  final PlanData data;
  final void Function(String step)? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final d = draft;
    final roots = ref.watch(rootCategoriesProvider).value ?? const [];
    final category = d.categoryId != null
        ? data.categories[d.categoryId]?.name
        : roots.where((r) => r.key == d.rootKey).firstOrNull?.name(context);
    final kind = switch (d.kind) {
      'routine' => l.kindRoutine,
      'one_off' => l.kindOneOff,
      'task' => l.kindTask,
      'project' => l.kindProject,
      'free_time' => l.kindFreeTime,
      _ => l.kindTravel,
    };
    final named = d.variants.where((v) => v.name.trim().isNotEmpty);
    final editing = onEdit != null;
    final rows = <(String, String, String?)>[
      (l.sumName, d.title.trim(), 'what'),
      (l.sumKind, kind, null),
      (l.sumCategory, category ?? l.wizCategoryNone, 'category'),
      if (d.isProject) ...[
        (
          l.sumDeadline,
          d.deadline == null
              ? l.wizDeadlineNone
              : dateText(
                  context,
                  d.deadline!.toIso8601String().substring(0, 10),
                ),
          'deadline',
        ),
        (
          l.sumTotal,
          d.totalMinutes == 0 ? l.sumNotSet : durationText(l, d.totalMinutes),
          'total',
        ),
        if (d.kind == 'project')
          (l.sumSplit, d.autoSplit ? l.splitAuto : l.splitManual, 'chunks'),
      ] else ...[
        (l.sumWhen, recurrenceText(context, d.recurrence()), 'when'),
        (
          l.sumTime,
          d.time == TimeType.relative && d.relActivity == null
              ? l.sumNotSet
              : timingText(
                  context,
                  d.timing(),
                  (id) => data.activities[id]?.title ?? '',
                ),
          'time',
        ),
        if (editing)
          (
            l.wizFlex,
            switch (d.flex) {
              Flexibility.fixed => l.flexFixed,
              Flexibility.shiftable => l.flexShiftable,
              Flexibility.optional => l.flexOptional,
            },
            'flex',
          ),
        (
          l.sumDuration,
          d.duration == null ? l.sumNotSet : durationText(l, d.duration!),
          'duration',
        ),
        if (named.length >= 2 || (editing && d.hasVariants))
          (
            l.sumVariants,
            named.length >= 2
                ? named.map((v) => v.name.trim()).join(', ')
                : l.sumNotSet,
            'variants',
          ),
      ],
      if (d.hasFocus)
        (
          l.sumFocus,
          switch (d.focus) {
            true => switch (d.focusMode) {
              'pomodoro' => l.modePomodoro,
              'deep' => l.sumDeep(
                d.focusBlock,
                d.focusBreak,
                d.canSpread && d.focusSpread
                    ? l.focusSpreadYes
                    : l.focusSpreadNo,
              ),
              _ => l.modeFree,
            },
            false => l.focusNo,
            null => l.sumNotSet,
          },
          'focus',
        ),
    ];
    return Column(
      children: [
        for (final (label, value, step) in rows)
          MergeSemantics(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label, style: Theme.of(context).textTheme.labelLarge),
              subtitle: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: editing && step != null
                  ? const Icon(Symbols.chevron_right_rounded)
                  : null,
              onTap: editing && step != null ? () => onEdit!(step) : null,
            ),
          ),
      ],
    );
  }
}
