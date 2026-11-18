import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

void main() {
  group('Hlc', () {
    test('metin biçimi geri dönüşlü', () {
      final h = Hlc(1763481234567, 3, 'a1b2');
      expect(h.toString(), '001763481234567-00003-a1b2');
      expect(Hlc.parse(h.toString()), h);
    });

    test('saat geri gitse de send hep artar', () {
      var h = Hlc.zero('dev1').send(1000);
      final seen = [h];
      for (final now in [900, 900, 1000, 1500, 1200]) {
        h = h.send(now);
        seen.add(h);
      }
      for (var i = 1; i < seen.length; i++) {
        expect(seen[i].compareTo(seen[i - 1]), greaterThan(0));
      }
    });

    test('receive iki taraftan da büyük damga üretir', () {
      final local = Hlc(1000, 5, 'aaa');
      final remote = Hlc(2000, 7, 'bbb');
      final r = local.receive(remote, 1500);
      expect(r.compareTo(remote), greaterThan(0));
      expect(r.compareTo(local), greaterThan(0));
      expect(r.node, 'aaa');
    });

    test('sıralama (ms, sayaç, düğüm)', () {
      expect(Hlc(2, 0, 'a').compareTo(Hlc(1, 9, 'z')), greaterThan(0));
      expect(Hlc(1, 2, 'a').compareTo(Hlc(1, 1, 'z')), greaterThan(0));
      expect(Hlc(1, 1, 'b').compareTo(Hlc(1, 1, 'a')), greaterThan(0));
    });

    test('clamp ileri tarihi kırpar', () {
      expect(Hlc(5000, 1, 'a').clamp(4000), Hlc(4000, 1, 'a'));
      expect(Hlc(3000, 1, 'a').clamp(4000), Hlc(3000, 1, 'a'));
    });

    test('geçersiz metin reddedilir', () {
      expect(() => Hlc.parse('123-1-a'), throwsFormatException);
      expect(
        () => Hlc.parse('001763481234567-00003-A!'),
        throwsFormatException,
      );
    });
  });

  group('mergeFields', () {
    test('farklı alanlar korunur, aynı alanda büyük HLC kazanır', () {
      final m = mergeFields(
        local: {'title': 'A', 'notes': 'eski', 'priority': 1},
        localVersions: {'title': '2', 'priority': '5'},
        remote: {'title': 'eski', 'notes': 'B', 'priority': 3},
        remoteVersions: {'title': '1', 'notes': '3', 'priority': '6'},
      );
      expect(m.values, {'title': 'A', 'notes': 'B', 'priority': 3});
      expect(m.versions, {'title': '2', 'notes': '3', 'priority': '6'});
    });

    test('sürümü olmayan sunucu alanında uzak kazanır', () {
      final m = mergeFields(
        local: {'updated_at': 'yerel'},
        localVersions: {},
        remote: {'updated_at': 'sunucu'},
        remoteVersions: {},
      );
      expect(m.values['updated_at'], 'sunucu');
    });

    test('bekleyen yerel değişiklik uzak sürümsüz değere ezilmez', () {
      final m = mergeFields(
        local: {'title': 'yerel'},
        localVersions: {'title': '9'},
        remote: {'title': 'uzak'},
        remoteVersions: {},
      );
      expect(m.values['title'], 'yerel');
    });
  });

  test('kural oluşumu kimliği deterministik', () {
    const rule = '0193a5b2-7c1d-7e2f-8a3b-4c5d6e7f8091';
    expect(
      ruleInstanceId(rule, '2026-11-21'),
      ruleInstanceId(rule, '2026-11-21'),
    );
    expect(
      ruleInstanceId(rule, '2026-11-21'),
      isNot(ruleInstanceId(rule, '2026-11-28')),
    );
  });
}
