import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/app/providers.dart';

import 'harness.dart';
import 'screens_test.dart' show addDaily;

void main() {
  Future<Harness> openStart(WidgetTester t) async {
    final h = await pumpApp(t, seed: (c) => addDaily(c, 'Okuma', focus: true));
    await h.tap(find.text('Okuma').last);
    await h.tap(find.text('Odaklan'));
    return h;
  }

  testWidgets('Odaklan → mod → Başla → sayaç; Bitir → 4 adım → Bugün', (
    t,
  ) async {
    final h = await openStart(t);
    expect(find.text('Başla'), findsOneWidget);
    expect(find.textContaining('Süre sınırı yok'), findsOneWidget);
    await h.expectAccessible();

    await h.tap(find.text('Pomodoro'));
    expect(find.textContaining('25 dk odak, 5 dk mola'), findsOneWidget);
    await h.tap(find.text('Başla'));
    expect(find.text('Duraklat'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Odak · 1. döngü'), findsOneWidget);
    expect(find.textContaining('Acil durum (3'), findsOneWidget);
    await h.expectAccessible();

    Harness.focusNow = Harness.focusNow.add(const Duration(minutes: 10));
    await t.pump(const Duration(seconds: 1));
    expect(find.text('15:00'), findsOneWidget);

    await h.tap(find.text('Bitir'));
    expect(find.text('Ne kadar odaklanabildin?'), findsOneWidget);
    await h.expectAccessible();
    await h.tap(find.text('4'));
    await h.tap(find.text('İleri'));
    expect(find.text('Ne kadar yorgunsun?'), findsOneWidget);
    await h.tap(find.text('Şimdilik geç'));
    await h.tap(find.text('Şimdilik geç')); // not
    expect(
      find.text(
        'Öğrenme ve Bellek ile ilişkilendirilen bölgelere 10 dk ayırdın.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('beyninin ölçümü değildir'), findsOneWidget);
    await h.expectAccessible();
    await h.tap(find.text('Bitti'));
    expect(find.text('Sıradaki'), findsOneWidget);

    final s = (await t.runAsync(
      () => h.read(focusRepositoryProvider).watchSessions().first,
    ))!.single;
    expect((s.outcome, s.focusRating, s.fatigueRating), ('completed', 4, null));
    expect(s.focusedSeconds, 600);
  });

  testWidgets(
    '10 sn içinde dönülmezse sakin "bozuldu" ekranı, yeniden başlat',
    (t) async {
      final h = await openStart(t);
      await h.tap(find.text('Başla'));
      expect(find.text('Duraklat'), findsOneWidget);

      Harness.focusNow = Harness.focusNow.add(const Duration(minutes: 3));
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await h.settle();
      expect(h.focus.alertDeadline, isNotNull);

      Harness.focusNow = Harness.focusNow.add(const Duration(minutes: 1));
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await h.settle();
      expect(find.text('Oturum bozuldu'), findsOneWidget);
      expect(find.textContaining('3 dakikalık kısım söndü'), findsOneWidget);
      await h.expectAccessible();

      await h.tap(find.text('Yeniden başlat'));
      expect(find.text('Başla'), findsOneWidget);
    },
  );

  testWidgets('Profil: odak tercihleri görünür', (t) async {
    final h = await pumpApp(t);
    await h.tap(find.text('Profil'));
    await h.tap(find.byTooltip('Ayarlar'));
    await t.scrollUntilVisible(
      find.text('Odakta Rahatsız Etmeyin'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Gelen aramalar kaçış sayılmasın'), findsOneWidget);
  });
}
