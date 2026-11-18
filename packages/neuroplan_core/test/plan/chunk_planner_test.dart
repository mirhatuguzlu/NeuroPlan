import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

import 'support.dart';

ChunkPlan run(
  List<PlanProject> projects,
  List<TimeSlot> slots, {
  int buffer = 0,
  int? cap,
  Map<String, int> used = const {},
}) => const EarliestDeadlinePlanner().plan(
  ChunkRequest(
    projects: projects,
    slots: slots,
    calendar: ist,
    usedMinutes: used,
    bookedByDay: const {},
    buffer: buffer,
    dailyFocusCap: cap,
  ),
);

TimeSlot slot(String date, String from, String to) =>
    TimeSlot(at(date, from), at(date, to));

void main() {
  final deadline = at('2026-11-30', '00:00');

  test('son tarihi en yakın proje önce yerleşir', () {
    final plan = run(
      [
        PlanProject(activityId: 'LATE', totalMinutes: 60, deadline: deadline),
        PlanProject(
          activityId: 'SOON',
          totalMinutes: 60,
          deadline: at('2026-11-20', '00:00'),
        ),
      ],
      [
        slot('2026-11-18', '09:00', '10:00'),
        slot('2026-11-18', '14:00', '15:00'),
      ],
    );
    expect(
      [for (final p in plan.proposals) (p.activityId, hm(p.start))],
      [('SOON', '09:00'), ('LATE', '14:00')],
    );
  });

  test('en kısa parçadan küçük boşluk kullanılmaz; kalan az ise son parça kısa olur', () {
    final short = run(
      [PlanProject(activityId: 'P', totalMinutes: 90, deadline: deadline)],
      [
        slot('2026-11-18', '09:00', '09:20'),
        slot('2026-11-18', '10:00', '11:30'),
      ],
    );
    expect([for (final p in short.proposals) hm(p.start)], ['10:00']);

    final tail = run(
      [PlanProject(activityId: 'P', totalMinutes: 140, deadline: deadline)],
      [slot('2026-11-18', '09:00', '13:00')],
    );
    expect([for (final p in tail.proposals) p.minutes], [120, 20]);
  });

  test('parçalar arası tampon ve günlük azami odak süresi uygulanır', () {
    final plan = run(
      [
        PlanProject(
          activityId: 'A',
          totalMinutes: 120,
          deadline: deadline,
          maxChunk: 60,
        ),
        PlanProject(
          activityId: 'B',
          totalMinutes: 120,
          deadline: deadline.add(1),
          maxChunk: 60,
        ),
      ],
      [
        slot('2026-11-18', '09:00', '18:00'),
        slot('2026-11-19', '09:00', '18:00'),
      ],
      buffer: 15,
      cap: 150,
    );
    expect(
      [
        for (final p in plan.proposals)
          '${p.activityId} ${p.date} ${hm(p.start)}',
      ],
      [
        'A 2026-11-18 09:00',
        'A 2026-11-18 10:15',
        'B 2026-11-18 11:30', // günün kalan 30 dakikası
        'B 2026-11-19 09:00',
        'B 2026-11-19 10:15',
      ],
    );
    expect(plan.proposals[2].minutes, 30);
    expect(plan.risks, isEmpty);
  });

  test('elle bölünen ya da son tarihsiz projeye öneri yok', () {
    final plan = run(
      [
        PlanProject(
          activityId: 'M',
          totalMinutes: 60,
          deadline: deadline,
          autoSplit: false,
        ),
        const PlanProject(activityId: 'N', totalMinutes: 60),
      ],
      [slot('2026-11-18', '09:00', '18:00')],
    );
    expect(plan.proposals, isEmpty);
    expect(plan.risks, isEmpty);
  });

  test('yapılmış süre düşülür; bitmiş projeye öneri yok', () {
    final plan = run(
      [PlanProject(activityId: 'P', totalMinutes: 60, deadline: deadline)],
      [slot('2026-11-18', '09:00', '18:00')],
      used: {'P': 60},
    );
    expect(plan.proposals, isEmpty);
  });

  test(
    'motor başka bir planlayıcıyla çalışabilir (değiştirilebilir arayüz)',
    () {
      final out = PlanEngine(chunkPlanner: _OnePerProject()).plan(
        PlanInput(
          settings: const PlanSettings(timezone: istanbul),
          from: '2026-11-18',
          to: '2026-11-18',
          asOf: at('2026-11-18', '00:00'),
          activities: const [PlanActivity(id: 'P')],
          projects: [
            PlanProject(activityId: 'P', totalMinutes: 60, deadline: deadline),
          ],
        ),
      );
      expect(out.proposals.single.minutes, 5);
      expect(
        out.freeSlots['2026-11-18']!.first.start,
        out.proposals.single.end,
      );
    },
  );
}

final class _OnePerProject implements ChunkPlanner {
  @override
  ChunkPlan plan(ChunkRequest r) => ChunkPlan([
    for (final p in r.projects)
      ChunkProposal(
        activityId: p.activityId,
        date: r.calendar.dayOf(r.slots.first.start).iso,
        start: r.slots.first.start,
        end: r.slots.first.start + 5,
      ),
  ], const []);
}

extension on int {
  int add(int minutes) => this + minutes;
}
