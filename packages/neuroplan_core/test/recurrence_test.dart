import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

void main() {
  group('Recurrence JSON', () {
    final valid = <Map<String, Object?>>[
      {'type': 'once', 'date': '2026-11-26'},
      {
        'type': 'rrule',
        'dtstart': '2026-11-23',
        'rrule': 'FREQ=WEEKLY;BYDAY=MO',
      },
      {
        'type': 'rrule',
        'dtstart': '2026-11-23',
        'rrule': 'FREQ=MONTHLY;BYDAY=2TU',
      },
      {
        'type': 'rrule',
        'dtstart': '2026-11-23',
        'rrule': 'FREQ=DAILY;INTERVAL=3;UNTIL=20261231',
      },
      {
        'type': 'rrule',
        'dtstart': '2026-11-23',
        'rrule': 'FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TH',
      },
      {
        'type': 'cycle',
        'anchor': '2026-11-23',
        'length_days': 14,
        'on_days': [0, 3, 8, 11, 13],
      },
      {
        'type': 'dates',
        'dates': ['2026-12-01', '2026-12-09'],
      },
      {'type': 'per_period', 'count': 3, 'unit': 'week'},
      {'type': 'follow'},
    ];

    for (final json in valid) {
      test('geri dönüş: ${json['type']} ${json['rrule'] ?? ''}', () {
        expect(Recurrence.fromJson(json).toJson(), json);
      });
    }

    final invalid = <String, Map<String, Object?>>{
      'olmayan gün': {'type': 'once', 'date': '2026-02-30'},
      'saatlik RRULE': {
        'type': 'rrule',
        'dtstart': '2026-11-23',
        'rrule': 'FREQ=HOURLY',
      },
      'FREQ yok': {
        'type': 'rrule',
        'dtstart': '2026-11-23',
        'rrule': 'BYDAY=MO',
      },
      'iki FREQ': {
        'type': 'rrule',
        'dtstart': '2026-11-23',
        'rrule': 'FREQ=DAILY;FREQ=WEEKLY',
      },
      'BYHOUR': {
        'type': 'rrule',
        'dtstart': '2026-11-23',
        'rrule': 'FREQ=DAILY;BYHOUR=9',
      },
      'döngü dışı ofset': {
        'type': 'cycle',
        'anchor': '2026-11-23',
        'length_days': 7,
        'on_days': [0, 7],
      },
      'sırasız ofset': {
        'type': 'cycle',
        'anchor': '2026-11-23',
        'length_days': 7,
        'on_days': [3, 1],
      },
      'tamsayı olmayan ofset': {
        'type': 'cycle',
        'anchor': '2026-11-23',
        'length_days': 7,
        'on_days': ['1'],
      },
      'boş tarih listesi': {'type': 'dates', 'dates': <String>[]},
      'sıfır adet': {'type': 'per_period', 'count': 0, 'unit': 'week'},
      'bilinmeyen birim': {'type': 'per_period', 'count': 3, 'unit': 'year'},
      'bilinmeyen tür': {'type': 'hourly'},
    };

    invalid.forEach((name, json) {
      test('reddedilir: $name', () {
        expect(() => Recurrence.fromJson(json), throwsFormatException);
      });
    });
  });
}
