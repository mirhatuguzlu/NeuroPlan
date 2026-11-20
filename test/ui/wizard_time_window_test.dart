import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/router.dart';

import 'harness.dart';

/// Hata: sihirbazda "Bir saat aralığında" seçilip süre boş geçilince iş Bugün'de
/// "Bugün bir ara"ya, Plan'da "—"ya düşüyordu (D62).
void main() {
  testWidgets('saat aralığı + süresiz: Bugün ve Plan zaman çizelgesinde', (
    t,
  ) async {
    final h = await pumpApp(t);

    await h.tap(find.byTooltip('Ekle'));
    await t.enterText(find.byType(TextFormField).first, 'Okuma');
    await h.settle();
    await h.tap(find.text('İleri'));
    await h.tap(find.text('Şimdilik geç')); // kategori
    await h.tap(find.text('İleri')); // her gün
    await h.tap(find.text('Bir saat aralığında')); // 09:00–17:00
    await h.tap(find.text('İleri'));
    await h.tap(find.text('Şimdilik geç')); // esneklik
    await h.tap(find.text('İleri')); // süre boş
    await h.tap(find.text('Şimdilik geç')); // varyant
    await h.tap(find.text('Şimdilik geç')); // odak
    await h.tap(find.text('Kaydet'));
    expect(find.text('Okuma eklendi'), findsOneWidget);

    // Bugün (saat 10:00): aralığın içinde, şimdiki ana yerleşir.
    h.read(routerProvider).go('/today');
    await h.settle();
    final today = find.ancestor(
      of: find.text('Okuma'),
      matching: find.byType(ListTile),
    );
    expect(today, findsOneWidget);
    expect(
      find.descendant(of: today, matching: find.text('10:00')),
      findsOneWidget,
    );
    expect(find.text('Bugün bir ara'), findsNothing);
    expect(find.textContaining('0 dk'), findsNothing);

    // Plan (hafta): bugün 10:00, sonraki günler aralığın başı 09:00; hiçbiri "—" değil.
    h.read(routerProvider).go('/plan');
    await h.settle();
    final rows = find.ancestor(
      of: find.text('Okuma'),
      matching: find.byType(ListTile),
    );
    final leads = [
      for (final e in rows.evaluate())
        ((e.widget as ListTile).leading! as Text).data,
    ];
    expect(leads, isNotEmpty);
    expect(leads.first, '10:00');
    expect(leads.skip(1), everyElement('09:00'));
  });
}
