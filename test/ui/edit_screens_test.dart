import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';

import 'harness.dart';
import 'screens_test.dart' show addDaily, openCategories;

/// Düzenleme ekranları (D64): satıra dokununca özet, satırdan tek soru, Kaydet.
void main() {
  testWidgets('Plan → Kurallar: işe dokun, saati aralığa çevir, kaydet', (
    t,
  ) async {
    late String id;
    final h = await pumpApp(
      t,
      seed: (c) async => id = await addDaily(c, 'Okuma'),
    );
    h.read(routerProvider).go('/plan');
    await h.settle();
    await h.tap(find.text('Kurallar'));
    await h.tap(find.text('Okuma'));
    expect(find.text('Düzenle'), findsOneWidget);
    expect(find.text('Sil'), findsOneWidget);

    await h.tap(find.text('Saat'));
    expect(find.text('Saati var mı?'), findsOneWidget);
    expect(find.text('Şimdilik geç'), findsNothing); // tek adım: yalnız Kaydet
    await h.tap(find.text('Bir saat aralığında'));
    await h.tap(find.text('Kaydet'));
    expect(find.text('Okuma güncellendi'), findsOneWidget);
    expect(find.text('09:00–17:00 arası'), findsOneWidget); // özete döndü

    final data = await t.runAsync(() => h.read(planDataProvider.future));
    expect(data!.activities[id]!.title, 'Okuma');
  });

  testWidgets('Bugün satırından Düzenle: ad değişir, Bugün yeni adı gösterir', (
    t,
  ) async {
    final h = await pumpApp(t, seed: (c) => addDaily(c, 'Okuma', hour: 12));
    h.read(routerProvider).go('/today');
    await h.settle();
    await h.tap(find.text('Okuma').last);
    await h.tap(find.text('Düzenle'));
    await h.tap(find.text('Ad'));
    expect(find.text('Türü'), findsNothing); // tür düzenlemede değişmez
    await t.enterText(find.byType(TextFormField).first, 'Kitap okuma');
    await h.settle();
    await h.tap(find.text('Kaydet'));
    expect(find.text('Kitap okuma güncellendi'), findsOneWidget);
    h.read(routerProvider).go('/today');
    await h.settle();
    expect(find.text('Kitap okuma'), findsWidgets);
    expect(find.text('Okuma'), findsNothing);
  });

  testWidgets('Düzenle → Sil: iş silinir, geri alınabilir', (t) async {
    late String id;
    final h = await pumpApp(
      t,
      seed: (c) async => id = await addDaily(c, 'Okuma'),
    );
    h.read(routerProvider).push('/edit/$id');
    await h.settle();
    await h.tap(find.text('Sil'));
    expect(find.text('Okuma silindi'), findsOneWidget);
    final data = await t.runAsync(() => h.read(planDataProvider.future));
    expect(data!.activities[id], isNull);
  });

  testWidgets('Kategori ağacı: kategori yeniden adlandırılır', (t) async {
    final h = await pumpApp(
      t,
      seed: (c) => c
          .read(categoryRepositoryProvider)
          .create(name: 'Kitaplar', rootCategoryKey: 'learning_memory'),
    );
    await openCategories(h);
    await h.tap(find.text('Öğrenme ve Bellek'));
    await h.tap(find.byTooltip('Yeniden adlandır'));
    await t.enterText(find.byType(TextField).last, 'Romanlar');
    await h.settle();
    await h.tap(find.text('Kaydet'));
    expect(find.text('Romanlar'), findsOneWidget);
    expect(find.text('Kitaplar'), findsNothing);
  });
}
