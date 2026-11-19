/// Beyin hesabının bütün ayarlanabilir sabitleri (docs/BRAIN_MODEL.md, DECISIONS D39).
///
/// Oranlar binde birdir (‰, tamsayı): hesap kayan noktaya düşmeden deterministik kalır.
/// Bir sabit değişince olaylar değişeceği için [engineVersion] artırılır.
library;

final class BrainConfig {
  const BrainConfig({
    this.neuronsPerMinute = 1000,
    this.escapePenaltyPermille = 100,
    this.minFocusPermille = 600,
    this.cycleBonusPermille = 50,
    this.maxCycleBonusPermille = 200,
    this.streakDayBonusPermille = 30,
    this.maxStreakBonusPermille = 180,
    this.historyDays = 7,
    this.deepLinkPerMinute = 20,
    this.consecutiveDayLink = 100,
    this.maxConsecutiveDays = 7,
    this.crossCategoryLink = 300,
    this.halfLifeDays = 14,
    this.brightnessFloorPermille = 250,
  });

  /// Kategori başına bir odak dakikasının toplam kazancı (binde bir nöron).
  final int neuronsPerMinute;

  /// Geri dönülen her sayılan kaçış odak çarpanından bu kadar düşer…
  final int escapePenaltyPermille;

  /// …ama çarpan bunun altına inmez.
  final int minFocusPermille;

  /// Pomodoro: tamamlanan her döngü için ek kazanç ve tavanı.
  final int cycleBonusPermille;
  final int maxCycleBonusPermille;

  /// Pomodoro haftalık süreklilik: penceredeki her ek gün için ek kazanç ve tavanı.
  final int streakDayBonusPermille;
  final int maxStreakBonusPermille;

  /// Süreklilik ve art arda gün hesabının baktığı gün sayısı (bugün dahil).
  final int historyDays;

  /// Derin çalışma: en uzun kesintisiz dakika başına bölge çiftlerine bağlantı.
  final int deepLinkPerMinute;

  /// Aynı kök kategori art arda günlerde: bölge içi bağlantı × seri günü (tavanlı).
  final int consecutiveDayLink;
  final int maxConsecutiveDays;

  /// Aynı gün iki farklı kök kategori: iki kategorinin bölgeleri arasına toplam bağlantı.
  final int crossCategoryLink;

  /// Sönme: beslenmeyen bölgenin parlaklığı bu kadar günde yarıya iner, tabanın altına inmez.
  final int halfLifeDays;
  final int brightnessFloorPermille;

  static const engineVersion = 2;
}

const brainConfig = BrainConfig();
