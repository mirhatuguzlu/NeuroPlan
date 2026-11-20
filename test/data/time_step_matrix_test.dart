import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/plan/plan_source.dart';
import 'package:neuroplan/data/repositories/activity_repository.dart';
import 'package:neuroplan/data/repositories/profile_repository.dart';
import 'package:neuroplan/ui/features/activity_wizard/draft.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'test_support.dart';

/// Sihirbazın "saat" adımındaki her seçim × süre × tekrar türü: kayıttan Bugün ve
/// Plan (hafta) görünümüne kadar doğru yerde mi (D62)?
void main() {
  // 18 Kasım 2026 çarşamba 10:00 (İstanbul); hafta 16–22 Kasım.
  final now = DateTime.utc(2026, 11, 18, 7);
  const today = '2026-11-18';
  const week = ('2026-11-16', '2026-11-22');

  final recs = <String, (void Function(ActivityDraft), List<String>?)>{
    'tek sefer bugün': ((d) => d.rec = RecType.once, [today]),
    'tek sefer yarın': (
      (d) => d
        ..rec = RecType.once
        ..date = DateTime(2026, 11, 19),
      ['2026-11-19'],
    ),
    'her gün': (
      (d) => d.rec = RecType.daily,
      ['2026-11-18', '2026-11-19', '2026-11-20', '2026-11-21', '2026-11-22'],
    ),
    'haftanın günleri (çar, cum)': (
      (d) => d
        ..rec = RecType.weekly
        ..weekdays = {3, 5},
      ['2026-11-18', '2026-11-20'],
    ),
    '2 günde bir': (
      (d) => d
        ..rec = RecType.everyN
        ..everyN = 2,
      ['2026-11-18', '2026-11-20', '2026-11-22'],
    ),
    'ayın 18\'i': (
      (d) => d
        ..rec = RecType.monthly
        ..monthDay = 18,
      [today],
    ),
    'döngü 2 açık 1 kapalı': (
      (d) => d
        ..rec = RecType.cycle
        ..cycleOn = 2
        ..cycleOff = 1,
      ['2026-11-18', '2026-11-19', '2026-11-21', '2026-11-22'],
    ),
    'tarih listesi': (
      (d) => d
        ..rec = RecType.dates
        ..dates = [DateTime(2026, 11, 18), DateTime(2026, 11, 21)],
      ['2026-11-18', '2026-11-21'],
    ),
    'haftada 3 kez': (
      (d) => d
        ..rec = RecType.perPeriod
        ..perCount = 3
        ..perUnit = PeriodUnit.week,
      null, // günleri motor dağıtır; yalnız sayı denetlenir
    ),
  };

  final times = <String, void Function(ActivityDraft)>{
    'sabit saat 09:00': (d) => d.time = TimeType.fixed,
    'saat aralığı 09:00–17:00': (d) => d
      ..time = TimeType.window
      ..flex = Flexibility.shiftable,
    'saat aralığı 13:00–15:00': (d) => d
      ..time = TimeType.window
      ..windowFrom = 13 * 60
      ..windowTo = 15 * 60
      ..flex = Flexibility.shiftable,
    'gece aralığı 22:00–02:00': (d) => d
      ..time = TimeType.window
      ..windowFrom = 22 * 60
      ..windowTo = 2 * 60
      ..flex = Flexibility.shiftable,
    'kahvaltıdan sonra': (d) => d
      ..time = TimeType.relative
      ..relAfterEnd = true,
    'kahvaltıdan önce': (d) => d
      ..time = TimeType.relative
      ..relAfterEnd = false,
    'gün doğumuna göre': (d) => d.time = TimeType.astro,
    'saat yok': (d) => d
      ..time = TimeType.none
      ..flex = Flexibility.shiftable,
  };

  late TestDevice device;
  late ActivityRepository activities;
  late String anchorId;

  setUp(() async {
    device = TestDevice();
    activities = ActivityRepository(device.db, device.writer);
    final profiles = ProfileRepository(device.db, device.writer);
    await profiles.ensure(timezone: 'Europe/Istanbul');
    await profiles.update(
      const ProfilesCompanion(
        locationLat: Value(41.0),
        locationLon: Value(29.0),
      ),
    );
    final cal = PlanCalendar('Europe/Istanbul');
    final anchor = ActivityDraft(now)
      ..title = 'Kahvaltı'
      ..at = 8 * 60
      ..duration = 30;
    anchorId = (await anchor.save(device.db, activities, cal)).id;
  });
  tearDown(() => device.db.close());

  for (final MapEntry(key: timeName, value: setTime) in times.entries) {
    for (final duration in [null, 45]) {
      for (final MapEntry(key: recName, value: (setRec, days))
          in recs.entries) {
        test('$timeName · süre ${duration ?? 'yok'} · $recName', () async {
          final cal = PlanCalendar('Europe/Istanbul');
          final draft = ActivityDraft(now)
            ..title = 'İş'
            ..duration = duration
            ..relActivity = anchorId;
          setRec(draft);
          setTime(draft);
          final saved = await draft.save(device.db, activities, cal);

          final data = (await PlanSource(device.db).load())!;
          final view = PlanView(
            data,
            const PlanEngine().plan(
              data.input(from: week.$1, to: week.$2, now: now),
            ),
            now,
          );
          final mine = [
            for (final i in view.output.instances)
              if (i.activityId == saved.id) i,
          ];
          expect(view.output.overflow, isEmpty);

          // Hafta görünümü: oluşumlar doğru günlerde (`PlanView.on`).
          final weekDays = [
            for (
              var d = Day.parse(week.$1);
              !d.isAfter(Day.parse(week.$2));
              d = d.add(1)
            )
              for (final i in view.on(d.iso))
                if (i.activityId == saved.id) d.iso,
          ];
          if (days != null) {
            expect(weekDays, days);
          } else {
            expect(weekDays, hasLength(3));
          }

          final untimed = draft.time == TimeType.none && duration == null;
          for (final i in mine) {
            // "Bugün bir ara" / haftada "—": yalnız saati de süresi de olmayan iş.
            expect(i.isTimed, !untimed, reason: i.date);
            if (untimed) continue;
            final start = cal.minuteOfDay(i.start!);
            final len = i.end! - i.start!;
            expect(len, duration ?? 0, reason: i.date);
            switch (draft.time) {
              case TimeType.fixed:
                expect(start, 9 * 60);
              case TimeType.window:
                final day = Day.parse(i.date);
                final lo = cal.wallToUtc(day, draft.windowFrom);
                final hi = cal.wallToUtc(
                  day.add(draft.windowTo <= draft.windowFrom ? 1 : 0),
                  draft.windowTo,
                );
                // Bugün 10:00'dan önce başlayan aralık şimdiye kayar.
                final floor = i.date == today
                    ? lo > view.nowMinute
                          ? lo
                          : view.nowMinute
                    : lo;
                expect(i.start, floor, reason: i.date);
                expect(i.end! <= hi, isTrue, reason: i.date);
                expect(i.suggested, isFalse);
              case TimeType.relative when draft.relAfterEnd:
                expect(start, 8 * 60 + 30);
              case TimeType.relative:
                expect(cal.minuteOfDay(i.end!), 8 * 60);
              case TimeType.astro:
                expect(start, inInclusiveRange(6 * 60, 8 * 60));
              case TimeType.none:
                expect(i.suggested, isTrue);
            }
          }
        });
      }
    }
  }
}
