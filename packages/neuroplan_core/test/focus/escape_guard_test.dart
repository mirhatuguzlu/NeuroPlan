import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

final t0 = DateTime.utc(2026, 11, 19, 9);
DateTime s(num seconds) =>
    t0.add(Duration(milliseconds: (seconds * 1000).round()));

void main() {
  group('10 sn kuralı', () {
    test('10 sn içinde dönüş: kesinti kaydedilir, süre odaktan düşülür', () {
      final g = EscapeGuard()..left(t0);
      expect(g.absence!.deadline, s(10));
      final r = g.returned(s(6)) as Recovered;
      expect(r.record.reason, AwayReason.appLeft);
      expect(r.record.recovered, isTrue);
      expect(r.record.counted, isTrue);
      expect(r.record.away, const Duration(seconds: 6));
      expect(r.gapTo, s(6));
      expect(g.absence, isNull);
    });

    test('dönülmezse tam son tarihte bozulur', () {
      final g = EscapeGuard()..left(t0);
      expect(g.check(s(9.9)), isNull);
      final b = g.check(s(10))!;
      expect(b.at, s(10));
      expect(b.record.recovered, isFalse);
      expect(b.record.counted, isTrue);
    });

    test('uygulama ölüp geç açıldı: dönüşte bozulma', () {
      final saved = (EscapeGuard()..left(t0)).toJson();
      final r = EscapeGuard.fromJson(saved).returned(s(3600));
      expect(r, isA<Broken>().having((b) => b.at, 'at', s(10)));
    });

    test(
      'bildirim paneli ayrı nedendir; panelden çıkış uygulamadan çıkıştır',
      () {
        final g = EscapeGuard()..left(t0, shade: true);
        expect(g.absence!.reason, AwayReason.notificationShade);
        g.left(s(3));
        expect(g.absence!.reason, AwayReason.appLeft);
        expect(
          g.absence!.deadline,
          s(10),
          reason: 'süre panelin açıldığı andan',
        );
      },
    );

    test('1 sn altı titreme kayda geçmez', () {
      final g = EscapeGuard()..left(t0, shade: true);
      expect(g.returned(s(0.5)), isNull);
    });
  });

  group('haksız ceza yok', () {
    test('ekran kapandı: askıda, odak süresi işler', () {
      final g = EscapeGuard()
        ..screenOff(t0)
        ..left(s(0.2));
      expect(g.absence!.reason, AwayReason.screenOff);
      expect(g.check(s(600)), isNull);
      final r = g.returned(s(600)) as Recovered;
      expect(r.record.counted, isFalse);
      expect(r.gapTo, isNull);
    });

    test('ekran kapanması çıkıştan sonra gelirse de geçerli', () {
      final g = EscapeGuard()
        ..left(t0)
        ..screenOff(s(0.3));
      expect(g.absence!.graceFrom, isNull);
    });

    test('cihaz sorgusu ekran kapalı derse ekran kapandı sayılır', () {
      final g = EscapeGuard()
        ..left(t0)
        ..deviceChecked(interactive: false);
      expect(g.absence!.reason, AwayReason.screenOff);
    });

    test('kilit ekranı (sabitlemeden PIN ile çıkış) askıya alır', () {
      final g = EscapeGuard()
        ..left(t0)
        ..deviceChecked(interactive: true, locked: true);
      expect(g.absence!.reason, AwayReason.screenOff);
      expect(g.check(s(60)), isNull);
      g.unlocked(s(60));
      expect(g.absence!.deadline, s(70));
    });

    test('önce çıkıp sonra ekranı kapatmak kaçıştır', () {
      final g = EscapeGuard()
        ..left(t0)
        ..screenOff(s(5));
      expect(g.check(s(10)), isNotNull);
    });

    test('kilit açılınca 10 sn başlar', () {
      final g = EscapeGuard()
        ..left(t0)
        ..screenOff(t0)
        ..unlocked(s(300));
      expect(g.absence!.deadline, s(310));
      final b = g.check(s(310))!;
      expect(b.record.reason, AwayReason.appLeft);
    });

    test('izinli arama: askıda, bitince 10 sn; arama süresi düşülür', () {
      final g = EscapeGuard()
        ..callStarted(t0)
        ..left(s(1));
      expect(g.absence!.reason, AwayReason.phoneCall);
      expect(g.check(s(300)), isNull);
      g.callEnded(s(300));
      expect(g.absence!.deadline, s(310));
      final r = g.returned(s(302)) as Recovered;
      expect(r.record.reason, AwayReason.phoneCall);
      expect(r.record.counted, isFalse);
      expect(r.gapTo, s(302));
    });

    test('ekran kapalıyken gelen arama: odak aramanın başına kadar işler', () {
      final g = EscapeGuard()
        ..screenOff(t0)
        ..left(t0)
        ..callStarted(s(100));
      expect(g.absence!.leftAt, s(100));
    });

    test('izinsiz arama şüphesi: süre dolsa da bozulmaz, dönüşte sorulur', () {
      final g = EscapeGuard()
        ..left(t0)
        ..deviceChecked(interactive: true, audioCall: true);
      expect(g.check(s(500)), isNull);
      expect(g.returned(s(500)), isA<NeedsPardon>());
      final r = g.pardon(s(500));
      expect(r.record.reason, AwayReason.phoneCall);
      expect(r.record.counted, isFalse);
    });

    test('ceza kaldırılmazsa bozulma son tarihte', () {
      final g = EscapeGuard()
        ..left(t0)
        ..deviceChecked(interactive: true, audioCall: true);
      g.returned(s(500));
      expect(g.refuse().at, s(10));
    });

    test('izin varsa ses modu dikkate alınmaz', () {
      final g = EscapeGuard()
        ..left(t0)
        ..deviceChecked(interactive: true, inCall: false, audioCall: true);
      expect(g.absence!.callHint, isFalse);
    });

    test('molada ve acil durumda çıkmak serbest', () {
      final g = EscapeGuard(armed: false)..left(t0);
      expect(g.absence, isNull);
      expect(g.returned(s(100)), isNull);
    });

    test('dışarıdayken mola başlarsa dışarıda kalma kapanır', () {
      final g = EscapeGuard()
        ..left(t0)
        ..screenOff(t0);
      final r = g.disarm(s(60))!;
      expect(r.counted, isFalse);
      expect(g.check(s(600)), isNull);
    });

    test('odak dışarıdayken yeniden başlarsa 10 sn hemen başlar', () {
      final g = EscapeGuard(armed: false)
        ..left(t0)
        ..arm(s(30));
      expect(g.absence!.deadline, s(40));
    });
  });
}
