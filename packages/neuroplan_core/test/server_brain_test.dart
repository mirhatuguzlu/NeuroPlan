import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

void main() {
  final weights = [
    {'root_category_key': 'learning_memory', 'region_key': 'hippocampus', 'weight': 0.6},
    {'root_category_key': 'learning_memory', 'region_key': 'prefrontal_left', 'weight': 0.6},
  ];
  Map<String, Object?> session(String id, String outcome, {int minutes = 30}) => {
    'id': id,
    'root_category_key': 'learning_memory',
    'mode': 'free',
    'settings': null,
    'segments': [
      {'kind': 'work', 'start': '2026-11-19T10:00:00.000Z', 'end': '2026-11-19T10:${minutes.toString().padLeft(2, '0')}:00.000Z'},
    ],
    'outcome': outcome,
    'focused_seconds': minutes * 60,
    'started_at': '2026-11-19T10:00:00.000Z',
    'ended_at': '2026-11-19T10:${minutes.toString().padLeft(2, '0')}:00.000Z',
    'deleted_at': null,
  };
  Map<String, Object?> input(List<Map<String, Object?>> sessions, {Map<String, int> peers = const {}}) => {
    'timezone': 'Europe/Istanbul',
    'as_of': '2026-11-19T12:00:00.000Z',
    'region_keys': ['hippocampus', 'prefrontal_left', 'amygdala'],
    'weights': weights,
    'sessions': sessions,
    'cofocus_peers': peers,
  };
  int neurons(Map<String, Object?> out, String key) =>
      ((out['regions']! as Map)[key] as Map)['neurons'] as int;

  test('tamamlanan oturum kazandırır, bozulan kazandırmaz', () {
    final out = serverBrain(input([session('a', 'completed'), session('b', 'broken', minutes: 10)]));
    expect(neurons(out, 'hippocampus') + neurons(out, 'prefrontal_left'), 30000);
    expect(neurons(out, 'amygdala'), 0);
    expect(out['engine_version'], BrainConfig.engineVersion);
  });

  test('istemcideki türetmeyle aynı sonuç (aynı motor)', () {
    final s = BrainSession(
      id: 'a',
      rootCategoryKey: 'learning_memory',
      mode: FocusMode.free,
      outcome: 'completed',
      focusedSeconds: 1800,
      endedAt: DateTime.utc(2026, 11, 19, 10, 30),
      day: '2026-11-19',
      longestRunSeconds: 1800,
    );
    final local = foldBrain(
      deriveBrainEvents(s, const [], {
        'learning_memory': {'hippocampus': 0.6, 'prefrontal_left': 0.6},
      }),
      DateTime.utc(2026, 11, 19, 12),
      regionKeys: const ['hippocampus', 'prefrontal_left', 'amygdala'],
      sessionRoots: const {'a': 'learning_memory'},
    ).toJson();
    final server = serverBrain(input([session('a', 'completed')]))..remove('engine_version');
    expect(server, local);
  });

  test('ortak odakta birlikte tamamlanan oturum ortak bağlantı kazandırır', () {
    final alone = serverBrain(input([session('a', 'completed')]));
    final together = serverBrain(input([session('a', 'completed')], peers: {'a': 1}));
    int strength(Map<String, Object?> out) =>
        (out['connections']! as List).fold(0, (t, c) => t + ((c as Map)['strength'] as int));
    expect(strength(together) - strength(alone), brainConfig.cofocusLink);
  });

  test('BrainState JSON gidiş-dönüş', () {
    final out = serverBrain(input([session('a', 'completed')], peers: {'a': 1}))
      ..remove('engine_version');
    expect(BrainState.fromJson(out, DateTime.utc(2026, 11, 19, 12)).toJson(), out);
  });
}
