// Derin çalışma blok planı motorda (D66): molalar yer kaplar, dağıtılan bloklar ayrı oluşum.
import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  const day = '2026-11-19';
  PlanActivity deep({bool spread = false}) => PlanActivity(
    id: 'TEZ',
    blocks: FocusBlocks(block: 50, rest: 10, spread: spread),
  );

  test('üst üste: 120 dk odak + 2 mola, 10:00–12:20', () {
    final out = plan(
      from: day,
      activities: [deep()],
      rules: [
        rule(
          'R',
          'TEZ',
          OnceRecurrence(day),
          start: [atClock('10:00')],
          minutes: 120,
        ),
      ],
    );
    expect(out.span('TEZ', day), '10:00–12:20');
    expect(out.one('TEZ', day).blocks, isNull);
  });

  test('başlangıç ve bitiş saati verilen işte de bitiş molalar kadar uzar', () {
    final out = plan(
      from: day,
      activities: [deep()],
      rules: [
        rule(
          'R',
          'TEZ',
          OnceRecurrence(day),
          start: [atClock('10:00')],
          end: [atClock('12:00')],
        ),
      ],
    );
    expect(out.span('TEZ', day), '10:00–12:20');
  });

  test('kesin işte dağıtma yok sayılır: bloklar kendi saatinde üst üste', () {
    final out = plan(
      from: day,
      activities: [deep(spread: true)],
      rules: [
        rule(
          'R',
          'TEZ',
          OnceRecurrence(day),
          start: [atClock('10:00')],
          minutes: 120,
        ),
      ],
    );
    expect(out.span('TEZ', day), '10:00–12:20');
  });

  test('kaydırılabilir + dağıt: 3 blok, her biri öncekinden bir mola sonra, boşlukta', () {
    final out = plan(
      from: day,
      activities: [deep(spread: true)],
      rules: [
        rule(
          'R',
          'TEZ',
          OnceRecurrence(day),
          start: [atClock('10:00')],
          minutes: 120,
          flex: Flexibility.shiftable,
        ),
        rule(
          'R2',
          'YEMEK',
          OnceRecurrence(day),
          start: [atClock('11:00')],
          minutes: 60,
        ),
      ],
    );
    final blocks = out.of('TEZ', day);
    expect(
      [for (final b in blocks) '${hm(b.start)}–${hm(b.end)}'],
      ['10:00–10:50', '12:00–12:50', '13:00–13:20'],
    );
    expect(
      [for (final b in blocks) (b.block, b.blocks)],
      [(1, 3), (2, 3), (3, 3)],
    );
    expect(blocks[0].id, ruleInstanceId('R', day));
    expect(blocks[1].id, blockInstanceId(blocks[0].id, 2));
    expect(blocks[1].suggested, isTrue);
  });

  test('dağıtılan blok bitti diye işaretlenirse kalıcı satırla tek kalır', () {
    final first = ruleInstanceId('R', day);
    final second = blockInstanceId(first, 2);
    final out = plan(
      from: day,
      activities: [deep(spread: true)],
      rules: [
        rule(
          'R',
          'TEZ',
          OnceRecurrence(day),
          start: [atClock('10:00')],
          minutes: 100,
          flex: Flexibility.shiftable,
        ),
      ],
      instances: [
        PersistedInstance(
          id: second,
          activityId: 'TEZ',
          ruleId: 'R',
          date: day,
          status: InstanceStatus.done,
          source: InstanceSource.rule,
          start: at(day, '15:00'),
          end: at(day, '15:50'),
        ),
      ],
    );
    final blocks = out.of('TEZ', day);
    expect(blocks.length, 2);
    expect(hm(blocks.last.start), '15:00');
  });
}
