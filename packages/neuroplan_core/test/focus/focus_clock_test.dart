import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

final t0 = DateTime.utc(2026, 11, 19, 9);
DateTime at(int minutes, [int seconds = 0]) =>
    t0.add(Duration(minutes: minutes, seconds: seconds));

const pomodoro = FocusSettings(FocusMode.pomodoro);

void main() {
  group('zaman damgası', () {
    test('süre tick değil zaman farkından gelir', () {
      final c = FocusClock.start(const FocusSettings(FocusMode.free), t0);
      expect(c.focused(at(37, 12)), const Duration(minutes: 37, seconds: 12));
      expect(c.phase, FocusPhase.working);
      expect(c.remaining(at(5)), isNull);
    });

    test('duraklat ve devam: aradaki süre sayılmaz', () {
      final c = FocusClock.start(
        const FocusSettings(FocusMode.free),
        t0,
      ).close(at(10)).resumeWork(at(15));
      expect(c.phase, FocusPhase.working);
      expect(c.focused(at(20)), const Duration(minutes: 15));
      expect(c.longestRun(at(20)), const Duration(minutes: 10));
    });

    test('segmentler JSON üzerinden aynen döner (kurtarma)', () {
      final c = FocusClock.start(pomodoro, t0).advance(at(27));
      final back = FocusClock(
        pomodoro,
        FocusClock.segmentsFromJson(c.toJson()),
      );
      expect(back.segments, c.segments);
      expect(back.phase, FocusPhase.onBreak);
    });

    test('bozuk ayar varsayılana döner, süre en az 1 dk', () {
      final s = FocusSettings.fromJson(FocusMode.pomodoro, {
        'work': 0,
        'break': 'x',
        'long_every': 3,
      });
      expect((s.work, s.rest, s.longEvery), (25, 5, 3));
    });
  });

  group('Pomodoro', () {
    test('odak bloğu tam 25. dakikada kapanır, mola başlar', () {
      final c = FocusClock.start(pomodoro, t0).advance(at(26));
      expect(c.phase, FocusPhase.onBreak);
      expect(c.segments, [
        Segment(SegmentKind.work, t0, at(25)),
        Segment(SegmentKind.rest, at(25)),
      ]);
      expect(c.remaining(at(26)), const Duration(minutes: 4));
      expect(c.completedCycles(at(26)), 1);
    });

    test('3 saat sonra açılış: mola da bitmiş, "bekliyor"', () {
      final c = FocusClock.start(pomodoro, t0).advance(at(180));
      expect(c.phase, FocusPhase.breakOver);
      expect(c.segments.last, Segment(SegmentKind.rest, at(25), at(30)));
      expect(c.focused(at(180)), const Duration(minutes: 25));
      expect(c.nextBoundary(at(180)), isNull);
    });

    test('duraklatma odak bloğunun sonunu kaydırır', () {
      final c = FocusClock.start(
        pomodoro,
        t0,
      ).close(at(10)).resumeWork(at(20)).advance(at(34));
      expect(c.phase, FocusPhase.working);
      expect(c.nextBoundary(at(34)), at(35));
    });

    test('4 döngüde bir uzun mola', () {
      var c = FocusClock.start(pomodoro, t0);
      var now = t0;
      for (var i = 1; i <= 4; i++) {
        now = now.add(const Duration(minutes: 25));
        c = c.advance(now);
        expect(c.breakLength(now), Duration(minutes: i == 4 ? 15 : 5));
        now = now.add(Duration(minutes: i == 4 ? 15 : 5));
        c = c.advance(now).resumeWork(now);
      }
      expect(c.completedCycles(now), 4);
      expect(c.cycle, 5);
    });

    test('molayı erken bitirmek yeni döngü başlatır', () {
      final c = FocusClock.start(
        pomodoro,
        t0,
      ).advance(at(26)).resumeWork(at(27));
      expect(c.phase, FocusPhase.working);
      expect(c.nextBoundary(at(27)), at(52));
    });
  });

  group('derin çalışma', () {
    const deep = FocusSettings(FocusMode.deep, target: 90);

    test('hedef fazı değiştirmez, yalnız sınır verir', () {
      final c = FocusClock.start(deep, t0);
      expect(c.nextBoundary(at(10)), at(90));
      final later = c.advance(at(120));
      expect(later.phase, FocusPhase.working);
      expect(later.nextBoundary(at(120)), isNull);
    });

    test('mola önerisi önceki odak süresinden (Flowtime)', () {
      final c = FocusClock.start(deep, t0);
      expect(c.breakLength(at(20)), const Duration(minutes: 5));
      expect(c.breakLength(at(40)), const Duration(minutes: 8));
      expect(c.breakLength(at(60)), const Duration(minutes: 10));
      expect(c.breakLength(at(100)), const Duration(minutes: 15));
      final b = c.startBreak(at(60)).advance(at(75));
      expect(b.phase, FocusPhase.breakOver);
      expect(b.segments.last, Segment(SegmentKind.rest, at(60), at(70)));
    });

    test('kesinti en uzun kesintisiz süreyi böler', () {
      final c = FocusClock.start(deep, t0).gap(at(30), at(31));
      expect(c.focused(at(61)), const Duration(minutes: 60));
      expect(c.longestRun(at(61)), const Duration(minutes: 30));
    });
  });

  group('blok planlı derin çalışma (D66)', () {
    const deep = FocusSettings(
      FocusMode.deep,
      target: 120,
      block: 50,
      rest: 10,
    );

    test('blok sonunda mola başlar, mola bitince bekler', () {
      final c = FocusClock.start(deep, t0);
      expect(deep.blockCount, 3);
      expect(c.nextBoundary(at(10)), at(50));
      final b = c.advance(at(55));
      expect(b.phase, FocusPhase.onBreak);
      expect(b.breakLength(at(55)), const Duration(minutes: 10));
      expect(b.advance(at(61)).phase, FocusPhase.breakOver);
    });

    test('son blok hedefte biter; mola açılmaz, hedef anı bilinir', () {
      var c = FocusClock.start(deep, t0).advance(at(60)).resumeWork(at(60));
      c = c
          .advance(at(120))
          .resumeWork(at(120)); // 2. blok 60–110, mola 110–120
      expect(c.cycle, 3);
      expect(c.nextBoundary(at(121)), at(140)); // kalan 20 dk
      final end = c.advance(at(150));
      expect(end.phase, FocusPhase.working);
      expect(end.targetReachedAt(at(150)), at(140));
      expect(c.targetReachedAt(at(130)), isNull);
    });

    test('saatler sonra açılış: ilk blok kapanır, mola biter, bekler', () {
      final c = FocusClock.start(deep, t0).advance(at(300));
      expect(c.phase, FocusPhase.breakOver);
      expect(c.focused(at(300)), const Duration(minutes: 50));
    });

    test('JSON: blok ve mola döner; eski kayıtta blok yok', () {
      final back = FocusSettings.fromJson(FocusMode.deep, deep.toJson());
      expect((back.target, back.block, back.rest), (120, 50, 10));
      final old = FocusSettings.fromJson(FocusMode.deep, {'target': 90});
      expect(old.blocked, isFalse);
    });

    test('FocusBlocks: planda kaplanan süre ve tersi', () {
      const b = FocusBlocks();
      expect(b.span(120), 140);
      expect(b.focusOf(140), 120);
      expect(b.span(50), 50);
      expect(b.focusOf(55), 50);
      expect(b.parts(120), [50, 50, 20]);
      expect(FocusBlocks.countOf(5, 50), 1);
    });
  });

  group('planlı Pomodoro (D67)', () {
    // 3 × 25 dk, 5 dk mola, 2 döngüde bir 15 dk uzun mola.
    const plan = FocusSettings(
      FocusMode.pomodoro,
      work: 25,
      rest: 5,
      longRest: 15,
      longEvery: 2,
      target: 75,
      planned: true,
    );

    test('döngü sonunda mola, uzun mola sırası, son döngü hedefte biter', () {
      expect(plan.blockCount, 3);
      var c = FocusClock.start(plan, t0).advance(at(26));
      expect(c.breakLength(at(26)), const Duration(minutes: 5));
      c = c.advance(at(30)).resumeWork(at(30)).advance(at(56));
      expect(c.breakLength(at(56)), const Duration(minutes: 15));
      c = c.advance(at(70)).resumeWork(at(70));
      expect(c.nextBoundary(at(71)), at(95));
      final end = c.advance(at(100));
      expect(end.phase, FocusPhase.working, reason: 'hedefte mola açılmaz');
      expect(end.targetReachedAt(at(100)), at(95));
    });

    test('JSON: hedef yazılır, eski Pomodoro planlı değildir', () {
      final back = FocusSettings.fromJson(FocusMode.pomodoro, plan.toJson());
      expect((back.planned, back.target, back.longEvery), (true, 75, 2));
      expect(
        FocusSettings.fromJson(FocusMode.pomodoro, {'work': 25}).blocked,
        isFalse,
      );
      expect(plan.defaults.planned, isFalse);
    });

    test('FocusBlocks: uzun molalar planda yer kaplar', () {
      const b = FocusBlocks(block: 25, rest: 5, longRest: 15, longEvery: 4);
      expect(b.span(100), 100 + 5 + 5 + 5);
      expect(b.span(200), 200 + 6 * 5 + 15);
      expect(b.focusOf(b.span(200)), 200);
      expect([for (var i = 1; i <= 4; i++) b.restAfter(i)], [5, 5, 5, 15]);
    });
  });

  test('gap: molada ve duraklatmada değişmez', () {
    final onBreak = FocusClock.start(pomodoro, t0).advance(at(26));
    expect(onBreak.gap(at(26), at(27)).segments, onBreak.segments);
    final paused = FocusClock.start(pomodoro, t0).close(at(5));
    expect(paused.gap(at(6), at(7)).segments, paused.segments);
  });

  test('Pomodoro serisi bozulan oturumda durur', () {
    expect(
      pomodoroStreak([
        (mode: 'pomodoro', outcome: 'in_progress'),
        (mode: 'pomodoro', outcome: 'completed'),
        (mode: 'deep', outcome: 'broken'),
        (mode: 'pomodoro', outcome: 'completed'),
        (mode: 'pomodoro', outcome: 'broken'),
        (mode: 'pomodoro', outcome: 'completed'),
      ]),
      2,
    );
  });
}
