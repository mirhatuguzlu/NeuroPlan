import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/plan/plan_source.dart';
import 'package:neuroplan/data/repositories/activity_repository.dart';
import 'package:neuroplan/data/repositories/profile_repository.dart';
import 'package:neuroplan/ui/features/activity_wizard/draft.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'test_support.dart';

/// Düzenleme (D64): kayıttan taslak kayıpsız geri kurulur; saat/tekrar değişince
/// geçmiş eski kuralla kalır, bugünden itibaren yenisi geçerli olur.
void main() {
  final now = DateTime.utc(2026, 11, 18, 7); // çarşamba 10:00 İstanbul
  const today = '2026-11-18';
  final cal = PlanCalendar('Europe/Istanbul');

  late TestDevice device;
  late ActivityRepository repo;

  setUp(() async {
    device = TestDevice();
    repo = ActivityRepository(device.db, device.writer);
    await ProfileRepository(
      device.db,
      device.writer,
    ).ensure(timezone: 'Europe/Istanbul');
  });
  tearDown(() => device.db.close());

  Future<PlanData> load() async => (await PlanSource(device.db).load())!;

  Future<String> anchor() async =>
      (await (ActivityDraft(now)
                ..title = 'Kahvaltı'
                ..duration = 30)
              .save(device.db, repo, cal))
          .id;

  String json(Object o) => jsonEncode(o);

  group('kayıt → taslak → aynı kural', () {
    final cases = <String, void Function(ActivityDraft, String)>{
      'her gün 07:30': (d, _) => d.at = 7 * 60 + 30,
      'haftanın günleri': (d, _) => d
        ..rec = RecType.weekly
        ..weekdays = {1, 3, 5},
      '3 günde bir': (d, _) => d
        ..rec = RecType.everyN
        ..everyN = 3,
      'ayın 15\'i': (d, _) => d
        ..rec = RecType.monthly
        ..monthDay = 15,
      'ayın son cuması': (d, _) => d
        ..rec = RecType.monthly
        ..monthByWeek = true
        ..nth = -1
        ..nthWeekday = 5,
      'döngü 3/2': (d, _) => d
        ..rec = RecType.cycle
        ..cycleOn = 3
        ..cycleOff = 2,
      'tarih listesi': (d, _) => d
        ..rec = RecType.dates
        ..dates = [DateTime(2026, 11, 20), DateTime(2026, 12, 1)],
      'haftada 2 kez': (d, _) => d
        ..rec = RecType.perPeriod
        ..perCount = 2
        ..perUnit = PeriodUnit.week,
      'tek sefer': (d, _) => d
        ..rec = RecType.once
        ..date = DateTime(2026, 11, 25),
      'gece aralığı': (d, _) => d
        ..time = TimeType.window
        ..windowFrom = 22 * 60
        ..windowTo = 60
        ..flex = Flexibility.shiftable,
      'kahvaltıdan 15 dk sonra': (d, a) => d
        ..time = TimeType.relative
        ..relActivity = a
        ..relOffset = 15,
      'kahvaltıdan 20 dk önce': (d, a) => d
        ..time = TimeType.relative
        ..relActivity = a
        ..relAfterEnd = false
        ..relOffset = 20,
      'kahvaltının ardından (izle)': (d, a) => d
        ..rec = RecType.follow
        ..time = TimeType.relative
        ..relActivity = a,
      'gün batımından 10 dk önce': (d, _) => d
        ..time = TimeType.astro
        ..astro = AstroEvent.sunset
        ..astroBefore = true
        ..astroOffset = 10,
      'saat yok, isteğe bağlı': (d, _) => d
        ..time = TimeType.none
        ..flex = Flexibility.optional,
    };
    for (final MapEntry(key: name, value: setup) in cases.entries) {
      test(name, () async {
        final a = await anchor();
        final original = ActivityDraft(now)
          ..title = 'İş'
          ..duration = 25
          ..focus = true
          ..focusMode = 'pomodoro'
          ..focusCycles = 1; // planlı Pomodoro: süre = 1 × 25 dk (D67)
        setup(original, a);
        final saved = await original.save(device.db, repo, cal);

        final d = ActivityDraft.edit(await load(), saved.id, today)!
          // Saklanan değerleri bırak: taslağın kendi okuması aynı kuralı kurmalı.
          ..keepRecurrence = null
          ..keepTiming = null;
        expect(json(d.recurrence()), json(original.recurrence()));
        expect(json(d.timing()), json(original.timing()));
        expect(d.flex, original.flex);
        expect(d.duration, 25);
        expect((d.title, d.focus, d.focusMode), ('İş', true, 'pomodoro'));
      });
    }
  });

  test('ad değişince kural değişmez, bölünmez', () async {
    final saved = await (ActivityDraft(
      now,
    )..title = 'Okuma').save(device.db, repo, cal);
    final d = ActivityDraft.edit(await load(), saved.id, today)!
      ..title = 'Kitap okuma';
    await d.update(device.db, repo, cal, step: 'what', today: today);
    final data = await load();
    expect(data.activities[saved.id]!.title, 'Kitap okuma');
    expect(data.rules.where((r) => r.activityId == saved.id), hasLength(1));
  });

  test('bugün başlayan kuralın saati yerinde değişir', () async {
    final saved = await (ActivityDraft(
      now,
    )..title = 'Okuma').save(device.db, repo, cal);
    final d = ActivityDraft.edit(await load(), saved.id, today)!
      ..keepTiming = null
      ..at = 20 * 60;
    await d.update(device.db, repo, cal, step: 'time', today: today);
    final rules = (await load()).rules.where((r) => r.activityId == saved.id);
    expect(rules, hasLength(1));
    expect(rules.single.validUntil, isNull);
  });

  test(
    'geçmişte başlamış kural bölünür: geçmiş eski saatte, bugünden yeni saatte',
    () async {
      final saved =
          await (ActivityDraft(now)
                ..title = 'Okuma'
                ..start = DateTime(2026, 11, 10)
                ..duration = 30)
              .save(device.db, repo, cal);
      final d = ActivityDraft.edit(await load(), saved.id, today)!
        ..keepTiming = null
        ..at = 20 * 60;
      await d.update(device.db, repo, cal, step: 'time', today: today);

      final data = await load();
      final rules = data.rules.where((r) => r.activityId == saved.id).toList()
        ..sort((a, b) => (a.validFrom ?? '').compareTo(b.validFrom ?? ''));
      expect(
        [for (final r in rules) (r.validFrom, r.validUntil)],
        [(null, '2026-11-17'), (today, null)],
      );
      expect(ActivityDraft.activeRule(data, saved.id, today)!.id, rules[1].id);

      final out = const PlanEngine().plan(
        data.input(from: '2026-11-16', to: '2026-11-19', now: now),
      );
      final starts = {
        for (final i in out.instances)
          if (i.activityId == saved.id) i.date: cal.minuteOfDay(i.start!),
      };
      expect(starts, {
        '2026-11-16': 9 * 60,
        '2026-11-17': 9 * 60,
        today: 20 * 60,
        '2026-11-19': 20 * 60,
      });

      // İkinci düzenleme yalnız yeni kuralı değiştirir.
      final again = ActivityDraft.edit(data, saved.id, today)!
        ..keepTiming = null
        ..at = 21 * 60;
      await again.update(device.db, repo, cal, step: 'time', today: today);
      expect(
        (await load()).rules.where((r) => r.activityId == saved.id),
        hasLength(2),
      );
    },
  );

  test('varyantlar: ad değişir, silinir, yenisi eklenir, varsayılan', () async {
    final saved =
        await (ActivityDraft(now)
              ..title = 'Spor'
              ..variants.addAll([VariantDraft('Koşu'), VariantDraft('Yüzme')]))
            .save(device.db, repo, cal);
    final d = ActivityDraft.edit(await load(), saved.id, today)!;
    expect([for (final v in d.variants) v.name], ['Koşu', 'Yüzme']);
    d.variants
      ..first.name = 'Uzun koşu'
      ..removeAt(1)
      ..add(VariantDraft('Bisiklet', cancels: true));
    d.defaultVariant = 1;
    await d.update(device.db, repo, cal, step: 'variants', today: today);

    final data = await load();
    final group = data.groups.singleWhere((g) => g.activityId == saved.id);
    final list = [
      for (final v in data.variants)
        if (v.groupId == group.id) v,
    ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    expect(
      [for (final v in list) (v.name, v.cancelsOccurrence)],
      [('Uzun koşu', false), ('Bisiklet', true)],
    );
    expect(group.defaultVariantId, list[1].id);
    expect(list.first.id, d.variants.first.id); // aynı satır, yeni değil
  });

  test('proje: son tarih ve toplam süre güncellenir', () async {
    final saved =
        await (ActivityDraft(now)
              ..title = 'Tez'
              ..kind = 'project'
              ..deadline = DateTime(2026, 12, 20)
              ..totalMinutes = 600)
            .save(device.db, repo, cal);
    final d = ActivityDraft.edit(await load(), saved.id, today)!;
    expect(d.deadline, DateTime(2026, 12, 20));
    expect(d.totalMinutes, 600);
    d.totalMinutes = 900;
    await d.update(device.db, repo, cal, step: 'total', today: today);
    final p = (await load()).projectOf(saved.id)!;
    expect(p.totalMinutes, 900);
    expect(p.splitMode, 'auto');
  });

  test(
    'düzenlenen uyku kuralı ayarlardaki uyku penceresi olarak kalır',
    () async {
      final a = await repo.create(
        ActivitiesCompanion.insert(
          id: newId(),
          kind: 'routine',
          title: 'Uyku',
          rootCategoryKey: const Value('rest_sleep'),
        ),
      );
      await repo.addRule(
        ScheduleRulesCompanion.insert(
          id: newId(),
          activityId: a.id,
          recurrence: const RRuleRecurrence(
            dtstart: '2026-11-01',
            rrule: 'FREQ=DAILY',
          ),
          timing: Value(
            Timing(
              start: [TimeConstraint(ConstraintOp.at, ClockRef(23, 0))],
              end: [
                TimeConstraint(ConstraintOp.at, ClockRef(7, 0, dayOffset: 1)),
              ],
            ),
          ),
        ),
      );
      final d = ActivityDraft.edit(await load(), a.id, today)!
        ..flex = Flexibility.shiftable;
      await d.update(device.db, repo, cal, step: 'flex', today: today);
      final data = await load();
      final rules = data.rules.where((r) => r.activityId == a.id).toList();
      expect(rules, hasLength(2));
      final active = ActivityDraft.activeRule(data, a.id, today)!;
      // Saat adımı açılmadıkça uyku penceresinin başlangıç + bitiş saati aynen kalır.
      expect(active.timing.end, hasLength(1));
    },
  );
}
