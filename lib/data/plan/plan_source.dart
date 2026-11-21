import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';

int _min(DateTime t) => t.millisecondsSinceEpoch ~/ 60000;
int? _minOrNull(DateTime? t) => t == null ? null : _min(t);

/// Plan motorunun okuduğu yerel satırlar (silinmişler hariç). Ekranlar başlık, kategori
/// ve odak bilgisini de buradan alır.
class PlanData {
  PlanData({
    required this.profile,
    required this.activities,
    required this.rules,
    required this.groups,
    required this.variants,
    required this.projects,
    required this.overrides,
    required this.instances,
    required this.categories,
  });

  final Profile profile;
  final Map<String, Activity> activities;
  final List<ScheduleRule> rules;
  final List<VariantGroup> groups;
  final List<Variant> variants;
  final List<Project> projects;
  final List<DayOverride> overrides;
  final List<PlanInstance> instances;
  final Map<String, UserCategory> categories;

  late final calendar = PlanCalendar(profile.timezone);

  /// Aktivitenin kök kategorisi (doğrudan ya da kategoriden).
  String? rootOf(String activityId) => activities[activityId]?.rootCategoryKey;

  /// Odak gerekir mi: aktivite → kategori zinciri → hayır (DB_SCHEMA §3.2–3.3).
  bool requiresFocus(String activityId) {
    final a = activities[activityId];
    if (a == null) return false;
    if (a.requiresFocus != null) return a.requiresFocus!;
    for (
      var c = categories[a.categoryId];
      c != null;
      c = categories[c.parentId]
    ) {
      if (c.requiresFocus != null) return c.requiresFocus!;
    }
    return false;
  }

  /// Varsayılan odak modu: aktivite → kategori zinciri → serbest.
  String focusMode(String activityId) {
    final a = activities[activityId];
    if (a?.focusMode != null) return a!.focusMode!;
    for (
      var c = categories[a?.categoryId];
      c != null;
      c = categories[c.parentId]
    ) {
      if (c.defaultFocusMode != null) return c.defaultFocusMode!;
    }
    return 'free';
  }

  /// Derin çalışma blok planı (D66): yalnız odak gerektiren derin çalışma işinde.
  FocusBlocks? focusBlocks(String activityId) {
    final a = activities[activityId];
    if (a == null ||
        !requiresFocus(activityId) ||
        focusMode(activityId) != FocusMode.deep.name) {
      return null;
    }
    return FocusBlocks(
      block: a.focusBlockMinutes ?? 50,
      rest: a.focusBreakMinutes ?? 10,
      spread: a.focusSpread ?? false,
    );
  }

  /// Önerilen saatli odak işinde bildirime geç kalma payı (D66), dakika.
  int graceMinutes(String activityId) =>
      activities[activityId]?.focusGraceMinutes ?? 10;

  Project? projectOf(String activityId) =>
      projects.where((p) => p.activityId == activityId).firstOrNull;

  PlanInput input({
    required String from,
    required String to,
    required DateTime now,
  }) => PlanInput(
    settings: PlanSettings(
      timezone: profile.timezone,
      latitude: profile.locationLat,
      longitude: profile.locationLon,
      prayerMethod: profile.prayerMethod,
      prayerMadhab: profile.prayerMadhab,
      minChunk: profile.minChunkMinutes,
      chunkBuffer: profile.chunkBufferMinutes,
      dailyFocusCap: profile.dailyFocusCapMinutes,
    ),
    from: from,
    to: to,
    asOf: _min(now),
    activities: [
      for (final a in activities.values)
        PlanActivity(
          id: a.id,
          variantId: a.variantId,
          priority: a.priority,
          estimatedMinutes: a.estimatedMinutes,
          blocks: focusBlocks(a.id),
        ),
    ],
    rules: [
      for (final r in rules)
        PlanRule(
          id: r.id,
          activityId: r.activityId,
          recurrence: r.recurrence,
          timing: r.timing,
          durationMin: r.durationMinMinutes,
          durationMax: r.durationMaxMinutes,
          flexibility: Flexibility.fromJson(r.flexibility),
          validFrom: r.validFrom,
          validUntil: r.validUntil,
          exceptionDates: r.exceptionDates,
        ),
    ],
    variantGroups: [
      for (final g in groups)
        PlanVariantGroup(
          id: g.id,
          activityId: g.activityId,
          appliesOn: g.appliesOn,
          defaultVariantId: g.defaultVariantId,
        ),
    ],
    variants: [
      for (final v in variants)
        PlanVariant(
          id: v.id,
          groupId: v.groupId,
          timing: v.timing,
          durationMin: v.durationMinMinutes,
          durationMax: v.durationMaxMinutes,
          cancelsOccurrence: v.cancelsOccurrence,
        ),
    ],
    projects: [
      for (final p in projects)
        PlanProject(
          activityId: p.activityId,
          totalMinutes: p.totalMinutes,
          deadline: _minOrNull(p.deadlineAt),
          autoSplit: p.splitMode == 'auto',
          minChunk: p.minChunkMinutes,
          maxChunk: p.maxChunkMinutes,
          dailyCap: p.dailyCapMinutes,
          safetyMargin: p.safetyMarginMinutes,
          preferredWindows: [
            for (final w in p.preferredWindows ?? const [])
              if (w is Map<String, Object?>) PreferredWindow.fromJson(w),
          ],
        ),
    ],
    dayOverrides: [
      for (final o in overrides)
        PlanDayOverride(
          date: o.date,
          recurrence: o.recurrence,
          validFrom: o.validFrom,
          validUntil: o.validUntil,
          keep: DayKeep.fromJson(o.keep),
          autoPlacement: o.autoPlacement,
        ),
    ],
    instances: [
      for (final i in instances)
        PersistedInstance(
          id: i.id,
          activityId: i.activityId,
          ruleId: i.ruleId,
          date: i.occurrenceDate,
          start: _minOrNull(i.startAt),
          end: _minOrNull(i.endAt),
          status: InstanceStatus.fromJson(i.status),
          source: InstanceSource.fromJson(i.source),
          variantId: i.variantId,
          isManual: i.isManual,
        ),
    ],
  );
}

/// Plan tablolarından biri değişince [PlanData]'yı yeniden okur.
class PlanSource {
  PlanSource(this._db);

  final AppDatabase _db;

  late final _tables = <TableInfo>[
    _db.profiles,
    _db.userCategories,
    _db.activities,
    _db.scheduleRules,
    _db.variantGroups,
    _db.variants,
    _db.projects,
    _db.dayOverrides,
    _db.planInstances,
  ];

  /// Profil yoksa (ilk açılış öncesi) null.
  Stream<PlanData?> watch() async* {
    yield await load();
    await for (final _ in _db.tableUpdates(
      TableUpdateQuery.onAllTables(_tables),
    )) {
      yield await load();
    }
  }

  Future<PlanData?> load() => _db.transaction(() async {
    final profile = await (_db.select(
      _db.profiles,
    )..where((p) => p.id.equals(localProfileId))).getSingleOrNull();
    if (profile == null) return null;
    final activities = await (_db.select(
      _db.activities,
    )..where((a) => a.deletedAt.isNull())).get();
    final live = {for (final a in activities) a.id};
    final rules = await (_db.select(
      _db.scheduleRules,
    )..where((r) => r.deletedAt.isNull())).get();
    final groups = await (_db.select(
      _db.variantGroups,
    )..where((g) => g.deletedAt.isNull())).get();
    final variants = await (_db.select(
      _db.variants,
    )..where((v) => v.deletedAt.isNull())).get();
    final projects = await (_db.select(
      _db.projects,
    )..where((p) => p.deletedAt.isNull())).get();
    final overrides = await (_db.select(
      _db.dayOverrides,
    )..where((o) => o.deletedAt.isNull())).get();
    // shortcut: tüm oluşumlar okunur; yıllar içinde binlerce satıra çıkınca tarih aralığıyla sınırla.
    final instances = await (_db.select(
      _db.planInstances,
    )..where((i) => i.deletedAt.isNull())).get();
    final categories = await (_db.select(
      _db.userCategories,
    )..where((c) => c.deletedAt.isNull())).get();
    return PlanData(
      profile: profile,
      activities: {for (final a in activities) a.id: a},
      rules: [
        for (final r in rules)
          if (live.contains(r.activityId)) r,
      ],
      groups: [
        for (final g in groups)
          if (live.contains(g.activityId)) g,
      ],
      variants: variants,
      projects: [
        for (final p in projects)
          if (live.contains(p.activityId)) p,
      ],
      overrides: overrides,
      instances: [
        for (final i in instances)
          if (live.contains(i.activityId)) i,
      ],
      categories: {for (final c in categories) c.id: c},
    );
  });
}
