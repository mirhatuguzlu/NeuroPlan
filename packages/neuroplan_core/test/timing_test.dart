import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

const x = '0193a5b2-7c1d-7e2f-8a3b-4c5d6e7f8091';

void main() {
  // docs/DB_SCHEMA.md §3.4.2'deki hazır kalıplar.
  final presets = <String, Map<String, Object?>>{
    'saat yok': {},
    'sabit saat': {
      'start': [
        {
          'op': 'at',
          'ref': {'clock': '13:00'},
        },
      ],
    },
    'pencere': {
      'start': [
        {
          'op': 'not_before',
          'ref': {'clock': '14:00'},
        },
      ],
      'end': [
        {
          'op': 'not_after',
          'ref': {'clock': '18:00'},
        },
      ],
    },
    'X bitince': {
      'start': [
        {
          'op': 'at',
          'ref': {'activity_id': x, 'edge': 'end'},
        },
      ],
    },
    'X\'ten 30 dk önce': {
      'end': [
        {
          'op': 'at',
          'ref': {'activity_id': x, 'edge': 'start'},
          'offset_minutes': -30,
        },
      ],
    },
    'gün doğumundan 40 dk önce, en geç 00:00': {
      'start': [
        {
          'op': 'not_after',
          'ref': {'clock': '00:00', 'day_offset': 1},
        },
      ],
      'end': [
        {
          'op': 'at',
          'ref': {'astro': 'sunrise', 'day_offset': 1},
          'offset_minutes': -40,
        },
      ],
    },
  };

  presets.forEach((name, json) {
    test('geri dönüş: $name', () {
      expect(Timing.fromJson(json).toJson(), json);
    });
  });

  test('çapa aktiviteleri toplanır', () {
    expect(Timing.fromJson(presets['X bitince']!).anchorActivityIds, {x});
    expect(Timing.none.anchorActivityIds, isEmpty);
  });

  final invalid = <String, Map<String, Object?>>{
    '24:00': {
      'start': [
        {
          'op': 'at',
          'ref': {'clock': '24:00'},
        },
      ],
    },
    'iki at': {
      'start': [
        {
          'op': 'at',
          'ref': {'clock': '10:00'},
        },
        {
          'op': 'at',
          'ref': {'clock': '11:00'},
        },
      ],
    },
    'bilinmeyen anahtar': {'when': []},
    'UUID olmayan aktivite': {
      'start': [
        {
          'op': 'at',
          'ref': {'activity_id': 'yemek', 'edge': 'end'},
        },
      ],
    },
    'aşırı ofset': {
      'start': [
        {
          'op': 'at',
          'ref': {'clock': '10:00'},
          'offset_minutes': 2000,
        },
      ],
    },
    'bilinmeyen astro': {
      'start': [
        {
          'op': 'at',
          'ref': {'astro': 'noon'},
        },
      ],
    },
    'geçersiz day_offset': {
      'start': [
        {
          'op': 'at',
          'ref': {'clock': '10:00', 'day_offset': 3},
        },
      ],
    },
    'bilinmeyen op': {
      'start': [
        {
          'op': 'around',
          'ref': {'clock': '10:00'},
        },
      ],
    },
  };

  invalid.forEach((name, json) {
    test('reddedilir: $name', () {
      expect(() => Timing.fromJson(json), throwsFormatException);
    });
  });
}
