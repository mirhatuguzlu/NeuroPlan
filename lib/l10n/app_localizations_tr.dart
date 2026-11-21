// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class L10nTr extends L10n {
  L10nTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'NöroPlan';

  @override
  String get navToday => 'Bugün';

  @override
  String get navPlan => 'Plan';

  @override
  String get navBrain => 'Beyin';

  @override
  String get navProfile => 'Profil';

  @override
  String get actionAdd => 'Ekle';

  @override
  String get commonNext => 'İleri';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonSkip => 'Şimdilik geç';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonUndo => 'Geri al';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonLoading => 'Yükleniyor';

  @override
  String errorTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Hoppala, bir şey takıldı',
      'young': 'Ups, bir şey ters gitti',
      'coder': 'Beklenmeyen bir istisna',
      'calm': 'Küçük bir aksilik oldu',
      'other': 'Bir şeyler ters gitti',
    });
    return '$_temp0';
  }

  @override
  String errorBody(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Verilerin cihazında sapasağlam. Bir daha deneyelim mi?',
      'young': 'Verilerin cihazında güvende. Bir daha dene!',
      'coder': 'Veri yerelde bütün, kayıp yok. Yeniden dene.',
      'calm': 'Verilerin cihazında güvende. Hazır olduğunda yeniden dene.',
      'other': 'Verilerin cihazında güvende. Tekrar deneyebilirsin.',
    });
    return '$_temp0';
  }

  @override
  String saveError(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Kaydedemedik, bir kez daha deneyelim.',
      'young': 'Kaydedilmedi, tekrar dene!',
      'coder': 'Yazma başarısız. Tekrar dene.',
      'calm': 'Kaydedilemedi. Biraz sonra tekrar deneyebilirsin.',
      'other': 'Kaydedilemedi. Tekrar dene.',
    });
    return '$_temp0';
  }

  @override
  String stepProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String minutesShort(int n) {
    return '$n dk';
  }

  @override
  String hoursShort(int h) {
    return '$h sa';
  }

  @override
  String hoursMinutes(int h, int m) {
    return '$h sa $m dk';
  }

  @override
  String inDuration(String duration) {
    return '$duration sonra';
  }

  @override
  String timeRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String get langSystem => 'Cihazın dili';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langEnglish => 'English';

  @override
  String get modeSystem => 'Cihazla aynı';

  @override
  String get modeLight => 'Açık';

  @override
  String get modeDark => 'Koyu';

  @override
  String get onbLanguageTitle => 'Hangi dili kullanalım?';

  @override
  String get onbAppearanceTitle => 'Nasıl görünsün?';

  @override
  String get onbAppearanceBody =>
      'Açık ya da koyu görünüm ve bir tema seç. İstediğin zaman Ayarlar\'dan değiştirebilirsin.';

  @override
  String get onbSleepTitle => 'Genelde ne zaman uyursun?';

  @override
  String get onbSleepBody =>
      'Uyku pencereni koruruz: otomatik plan bu saatlere hiçbir şey koymaz.';

  @override
  String get sleepBedtime => 'Yatış';

  @override
  String get sleepWake => 'Kalkış';

  @override
  String get sleepActivityTitle => 'Uyku';

  @override
  String get onbLocationTitle => 'Konumunu kullanalım mı?';

  @override
  String get onbLocationBody =>
      'Bir işi gün doğumuna ya da batımına bağlamak istersen yaklaşık konumun gerekir. Konum yaklaşık 11 km hassasiyetle saklanır ve kimseyle paylaşılmaz. İstemezsen bu adımı geçebilirsin.';

  @override
  String get locationAllow => 'Konumu kullan';

  @override
  String get locationSaved => 'Konum kaydedildi';

  @override
  String get locationDenied =>
      'Konum izni verilmedi. İstersen daha sonra Profil\'den açabilirsin.';

  @override
  String get locationError =>
      'Konum alınamadı. Konum hizmetlerinin açık olduğundan emin ol.';

  @override
  String get onbPrayerTitle => 'Namaz vakitlerini kullanmak ister misin?';

  @override
  String get onbPrayerBody =>
      'İstersen kendi işlerini namaz vakitlerine bağlayabilirsin, örneğin akşam namazından sonra 30 dakika. Vakitler konumundan internetsiz hesaplanır ve yalnız çapa olarak kullanılır.';

  @override
  String get prayerEnable => 'Namaz vakitlerini aç';

  @override
  String get prayerMethod => 'Hesaplama yöntemi';

  @override
  String get prayerMadhab => 'İkindi hesabı';

  @override
  String get madhabShafi => 'Standart (Şafii, Maliki, Hanbeli)';

  @override
  String get madhabHanafi => 'Hanefi';

  @override
  String get prayerNeedsLocation =>
      'Vakitlerin hesaplanması için konum da gerekir.';

  @override
  String prayerMethodName(String method) {
    String _temp0 = intl.Intl.selectLogic(method, {
      'turkiye': 'Türkiye (Diyanet)',
      'muslimWorldLeague': 'Dünya İslam Birliği',
      'egyptian': 'Mısır',
      'karachi': 'Karaçi',
      'ummAlQura': 'Ümmü’l-Kurâ (Mekke)',
      'dubai': 'Dubai',
      'gulfRegion': 'Körfez bölgesi',
      'kuwait': 'Kuveyt',
      'qatar': 'Katar',
      'moonsightingCommittee': 'Hilal Gözlem Komitesi',
      'northAmerica': 'Kuzey Amerika (ISNA)',
      'singapore': 'Singapur',
      'indonesian': 'Endonezya',
      'tehran': 'Tahran',
      'jafari': 'Caferi',
      'jordan': 'Ürdün',
      'algerian': 'Cezayir',
      'morocco': 'Fas',
      'tunisia': 'Tunus',
      'france': 'Fransa (UOIF)',
      'portugal': 'Portekiz',
      'russia': 'Rusya',
      'other': 'Diğer',
    });
    return '$_temp0';
  }

  @override
  String get onbCategoriesTitle => 'Her şey 9 kök kategoriye bağlanır';

  @override
  String get onbCategoriesBody =>
      'Bu kategoriler sabittir; altına istediğin kadar kendi kategorini açarsın. Beyin bir metafordur, ölçüm değildir.';

  @override
  String onbFirstTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Haydi, ilk rutinini ekleyelim',
      'young': 'İlk rutinini ekleyelim mi?',
      'coder': 'İlk rutini tanımla',
      'calm': 'İlk rutinini ekleyelim',
      'other': 'İlk rutinini ekleyelim',
    });
    return '$_temp0';
  }

  @override
  String onbFirstBody(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful':
          'Senin hayatını sen bilirsin; hazır örnek yok, ilk işi sen eklersin.',
      'young': 'Hayatın sana özel: hazır örnek yok, ilk işini sen ekle.',
      'coder':
          'Varsayılan veri yok; şablon boş başlar. İlk kaydı sen eklersin.',
      'calm': 'Uygulama senin hayatın hakkında bir şey varsaymaz. Acele etme; ilk işini sen eklersin.',
      'other': 'Uygulama senin hayatın hakkında hiçbir şey varsaymaz. Hazır örnek yok; ilk işini sen eklersin.',
    });
    return '$_temp0';
  }

  @override
  String get onbFirstAction => 'İlk rutinimi ekle';

  @override
  String get todayNow => 'Şu an';

  @override
  String get todayNext => 'Sıradaki';

  @override
  String todayEnds(String time) {
    return 'Bitiş $time';
  }

  @override
  String todayEmptyTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Bugün bembeyaz bir sayfa',
      'young': 'Günün şu an bomboş',
      'coder': 'Bugün: 0 kayıt',
      'calm': 'Bugün henüz sakin',
      'other': 'Planın henüz boş',
    });
    return '$_temp0';
  }

  @override
  String todayEmptyBody(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful':
          'Rutinlerini ekledikçe gün renklenir; boş zamanını da biz buluruz.',
      'young': 'Rutinlerini ekle, günün burada şekillensin; boş zamanını da hesaplarız.',
      'coder': 'Rutin ve iş ekledikçe gün derlenir; boş dilimler otomatik hesaplanır.',
      'calm': 'Rutinlerini ekledikçe günün burada yavaşça belirir; boş zamanın da hesaplanır.',
      'other': 'Rutinlerini ve işlerini ekledikçe günün burada belirir; boş zamanın da hesaplanır.',
    });
    return '$_temp0';
  }

  @override
  String todayEmptyAction(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'İlk rutinini ekleyelim',
      'young': 'İlk rutinini ekle',
      'coder': 'İlk rutini oluştur',
      'calm': 'İlk rutinini ekle',
      'other': 'İlk rutinini ekle',
    });
    return '$_temp0';
  }

  @override
  String get todayNothing => 'Bugün için planlanmış bir şey yok.';

  @override
  String get todayUnplanned =>
      'Bugün plansız gün: otomatik yerleştirme yok, boş zaman hesaplanmıyor.';

  @override
  String freeSlot(String duration) {
    return 'Boş · $duration';
  }

  @override
  String get untimedSection => 'Bugün bir ara';

  @override
  String relAnchor(String edge, String title) {
    String _temp0 = intl.Intl.selectLogic(edge, {
      'end': '$title bitince',
      'other': '$title başlamadan önce',
    });
    return '$_temp0';
  }

  @override
  String relAnchorOffset(String edge, String title, String duration) {
    String _temp0 = intl.Intl.selectLogic(edge, {
      'end': '$title bitiminden $duration sonra',
      'other': '$title başlamadan $duration önce',
    });
    return '$_temp0';
  }

  @override
  String get overflowSection => 'Tampon: sığmayanlar';

  @override
  String get overflowBody =>
      'Kısıtları içinde yer bulunamadı. Saatini değiştirebilir ya da atlayabilirsin.';

  @override
  String get droppedLabel => 'İsteğe bağlı, yer olmadığı için düştü';

  @override
  String conflictLabel(String title) {
    return '$title ile çakışıyor';
  }

  @override
  String get cycleLabel => 'Göreli bağlantılarda döngü var; saat hesaplanamadı';

  @override
  String get missingAnchorLabel =>
      'Bu iş için konum ya da namaz vakti ayarı gerekiyor';

  @override
  String get focusLabel => 'Odak gerektirir';

  @override
  String get suggestedLabel => 'Önerilen saat';

  @override
  String get actionDone => 'Bitti';

  @override
  String get actionSkip => 'Atla';

  @override
  String get actionChangeTime => 'Saati değiştir';

  @override
  String get statusDone => 'Yapıldı';

  @override
  String get statusSkipped => 'Atlandı';

  @override
  String snackDone(String title) {
    return '$title tamamlandı';
  }

  @override
  String snackSkipped(String title) {
    return '$title atlandı';
  }

  @override
  String variantPrompt(String title) {
    return '$title: bugün hangisi?';
  }

  @override
  String get variantAsIs => 'Olduğu gibi';

  @override
  String get proposalLabel => 'Öneri';

  @override
  String get proposalAccept => 'Onayla';

  @override
  String get proposalAccepted => 'Parça plana eklendi';

  @override
  String get changeScopeTitle => 'Bu değişiklik ne zaman geçerli olsun?';

  @override
  String get changeScopeOnce => 'Yalnız bu sefer';

  @override
  String get changeScopeAlways => 'Her zaman';

  @override
  String get planWeek => 'Hafta';

  @override
  String get planRules => 'Kurallar';

  @override
  String get prevWeek => 'Önceki hafta';

  @override
  String get nextWeek => 'Sonraki hafta';

  @override
  String get thisWeek => 'Bu hafta';

  @override
  String dayFree(String duration) {
    return 'Boş $duration';
  }

  @override
  String get dayUnplanned => 'Plansız gün';

  @override
  String get dayEmpty => 'Planlı iş yok';

  @override
  String get rulesEmptyTitle => 'Henüz bir işin yok';

  @override
  String get rulesEmptyBody =>
      'Bir iş eklediğinde ne zaman olacağı burada listelenir.';

  @override
  String itemDeleted(String title) {
    return '$title silindi';
  }

  @override
  String get inboxSection => 'Tarihsiz işler';

  @override
  String get projectsSection => 'Projeler ve görevler';

  @override
  String get routinesSection => 'Tekrarlar ve tarihli işler';

  @override
  String get recDaily => 'Her gün';

  @override
  String recWeekdays(String days) {
    return 'Her $days';
  }

  @override
  String recEveryNDays(int n) {
    return '$n günde bir';
  }

  @override
  String recMonthDay(int day) {
    return 'Her ayın $day. günü';
  }

  @override
  String recMonthNth(int n, String weekday) {
    return 'Her ayın $n. $weekday günü';
  }

  @override
  String recMonthLast(String weekday) {
    return 'Her ayın son $weekday günü';
  }

  @override
  String recCycle(int length, int count) {
    return '$length günlük döngüde $count gün';
  }

  @override
  String recDates(int count) {
    return '$count seçili gün';
  }

  @override
  String recPerPeriod(String unit, int count) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'day': 'Günde',
      'week': 'Haftada',
      'other': 'Ayda',
    });
    return '$_temp0 $count kez';
  }

  @override
  String get recFollow => 'Bağlı olduğu işle birlikte';

  @override
  String get recCustom => 'Özel tekrar';

  @override
  String timeWindow(String from, String to) {
    return '$from–$to arası';
  }

  @override
  String timeRelative(String title) {
    return '$title işine bağlı';
  }

  @override
  String timeAstro(String event) {
    return '$event vaktine göre';
  }

  @override
  String get timeNone => 'Saat yok';

  @override
  String astroEvent(String event) {
    String _temp0 = intl.Intl.selectLogic(event, {
      'sunrise': 'Gün doğumu',
      'sunset': 'Gün batımı',
      'fajr': 'İmsak',
      'dhuhr': 'Öğle',
      'asr': 'İkindi',
      'maghrib': 'Akşam',
      'other': 'Yatsı',
    });
    return '$_temp0';
  }

  @override
  String get wizTitle => 'Yeni iş';

  @override
  String get wizWhatTitle => 'Ne?';

  @override
  String get wizWhatLabel => 'Adı';

  @override
  String get wizWhatError => 'Bir ad yaz';

  @override
  String get wizKind => 'Türü';

  @override
  String get kindRoutine => 'Rutin';

  @override
  String get kindOneOff => 'Tek seferlik';

  @override
  String get kindTask => 'Son tarihli görev';

  @override
  String get kindProject => 'Proje';

  @override
  String get kindFreeTime => 'Serbest zaman';

  @override
  String get kindTravel => 'Yol / hazırlık';

  @override
  String get wizCategoryTitle => 'Hangi kategoriye ait?';

  @override
  String get wizCategoryNone => 'Kategorisiz (beyne katkı vermez)';

  @override
  String get wizNewSubcategory => 'Yeni alt kategori';

  @override
  String get wizSubcategoryName => 'Alt kategori adı';

  @override
  String get wizWhenTitle => 'Ne zaman olur?';

  @override
  String get recTypeOnce => 'Bir kez';

  @override
  String get recTypeDaily => 'Her gün';

  @override
  String get recTypeWeekly => 'Haftanın belirli günleri';

  @override
  String get recTypeEveryN => 'Her N günde bir';

  @override
  String get recTypeMonthly => 'Ayda bir';

  @override
  String get recTypeCycle => 'Dönüşümlü (açık / kapalı günler)';

  @override
  String get recTypeDates => 'Seçtiğim tarihlerde';

  @override
  String get recTypePerPeriod => 'Belirli sayıda, gün vermeden';

  @override
  String get recTypeFollow => 'Başka bir işle birlikte';

  @override
  String get wizDate => 'Tarih';

  @override
  String get wizStartDate => 'Başlangıç';

  @override
  String get wizEveryNDays => 'Kaç günde bir';

  @override
  String get wizMonthByDay => 'Ayın günü';

  @override
  String get wizMonthByWeek => 'Ayın haftası';

  @override
  String get wizMonthDay => 'Gün';

  @override
  String get wizNth => 'Kaçıncı';

  @override
  String get nthLast => 'Son';

  @override
  String get wizCycleOn => 'Açık gün sayısı';

  @override
  String get wizCycleOff => 'Kapalı gün sayısı';

  @override
  String get wizAddDate => 'Tarih ekle';

  @override
  String get wizPerCount => 'Kaç kez';

  @override
  String get unitDay => 'Günde';

  @override
  String get unitWeek => 'Haftada';

  @override
  String get unitMonth => 'Ayda';

  @override
  String get wizFollowNote =>
      'Bağlanacağı işi bir sonraki adımda seçeceksin. O iş olmayan günlerde bu da olmaz.';

  @override
  String wizNumberError(int min, int max) {
    return '$min ile $max arasında bir sayı yaz';
  }

  @override
  String get wizPickDay => 'En az bir gün seç';

  @override
  String get wizPickDate => 'En az bir tarih ekle';

  @override
  String get wizTimeTitle => 'Saati var mı?';

  @override
  String get timeTypeFixed => 'Sabit saat';

  @override
  String get timeTypeWindow => 'Bir saat aralığında';

  @override
  String get timeTypeRelative => 'Başka bir işe göre';

  @override
  String get timeTypeAstro => 'Gün doğumu ya da namaz vaktine göre';

  @override
  String get timeTypeNone => 'Saat yok, gün içinde bir ara';

  @override
  String get wizStartTime => 'Başlangıç';

  @override
  String get wizWindowFrom => 'En erken';

  @override
  String get wizWindowTo => 'En geç';

  @override
  String get wizRelativeTo => 'Hangi iş';

  @override
  String get relAfterEnd => 'O bitince başlasın';

  @override
  String get relBeforeStart => 'O başlamadan önce bitsin';

  @override
  String get wizOffset => 'Arada kaç dakika';

  @override
  String get wizAstroEvent => 'Hangi vakit';

  @override
  String get astroBefore => 'Önce';

  @override
  String get astroAfter => 'Sonra';

  @override
  String get wizAstroNeedsLocation =>
      'Bunun için konum gerekir. Profil\'den konumu açabilirsin.';

  @override
  String get wizNoActivities => 'Bağlanacak başka bir işin yok.';

  @override
  String get wizPickActivity => 'Bir iş seç';

  @override
  String get wizFlex => 'Esneklik';

  @override
  String get flexFixed => 'Kesin';

  @override
  String get flexShiftable => 'Kaydırılabilir';

  @override
  String get flexOptional => 'İsteğe bağlı';

  @override
  String get flexFixedHint =>
      'Kımıldamaz; başka kesin işle çakışırsa sana gösterilir.';

  @override
  String get flexShiftableHint => 'Yer yoksa en yakın boşluğa taşınır.';

  @override
  String get flexOptionalHint => 'Yer yoksa o gün düşer.';

  @override
  String get wizDurationTitle => 'Ne kadar sürer?';

  @override
  String get wizMinutes => 'Dakika';

  @override
  String get wizVariantTitle => 'Farklı halleri olur mu?';

  @override
  String get wizVariantBody =>
      'Bu iş bazı günler farklı geçiyorsa her hali bir varyant olarak ekle. Günün başında tek dokunuşla seçersin.';

  @override
  String get wizVariantName => 'Varyant adı';

  @override
  String get wizVariantAdd => 'Varyant ekle';

  @override
  String get wizVariantCancels => 'Bu halde o gün olmasın';

  @override
  String get wizVariantDefault => 'Seçim yapmazsam bu geçerli olsun';

  @override
  String get wizVariantMin => 'En az iki varyant gerekir';

  @override
  String get wizVariantRemove => 'Varyantı kaldır';

  @override
  String get wizFocusTitle => 'Odak gerektiriyor mu?';

  @override
  String get focusYes => 'Evet';

  @override
  String get focusNo => 'Hayır';

  @override
  String get wizFocusMode => 'Odak modu';

  @override
  String get modeFree => 'Serbest';

  @override
  String get modePomodoro => 'Pomodoro';

  @override
  String get modeDeep => 'Derin çalışma';

  @override
  String get wizDeadlineTitle => 'Son tarih ne?';

  @override
  String get wizDeadlineNone => 'Son tarih yok';

  @override
  String get wizTotalTitle => 'Toplam ne kadar sürer?';

  @override
  String get wizHours => 'Saat';

  @override
  String get wizChunksTitle => 'Nasıl bölünsün?';

  @override
  String get wizMinChunk => 'En kısa parça (dk)';

  @override
  String get wizMaxChunk => 'En uzun parça (dk)';

  @override
  String get wizDailyCap => 'Günde en çok (dk)';

  @override
  String get splitAuto => 'Otomatik öner, ben onaylarım';

  @override
  String get splitManual => 'Boş dilimlere ben yerleştiririm';

  @override
  String get wizSummaryTitle => 'Özet';

  @override
  String wizSaved(String title) {
    return '$title eklendi';
  }

  @override
  String get sumName => 'Ad';

  @override
  String get sumKind => 'Tür';

  @override
  String get sumCategory => 'Kategori';

  @override
  String get sumWhen => 'Ne zaman';

  @override
  String get sumTime => 'Saat';

  @override
  String get sumDuration => 'Süre';

  @override
  String get sumVariants => 'Varyantlar';

  @override
  String get sumFocus => 'Odak';

  @override
  String get sumDeadline => 'Son tarih';

  @override
  String get sumTotal => 'Toplam süre';

  @override
  String get sumSplit => 'Bölme';

  @override
  String get sumNotSet => 'Belirtilmedi';

  @override
  String get brainTitle => 'Kategoriler ve beyin';

  @override
  String get brainIntro =>
      'Kök kategoriler sabittir; altına sınırsız alt kategori ve iş ekleyebilirsin. 3D beyin bir metafordur, ölçüm değildir.';

  @override
  String get brainRegionsTitle => 'Beyninin neresini çalıştırır?';

  @override
  String evidenceLevel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'strong': 'Güçlü kanıt',
      'moderate': 'Orta düzey kanıt',
      'weak': 'Zayıf kanıt',
      'other': 'Kaynak yok, yalnız ilişkilendirme',
    });
    return '$_temp0';
  }

  @override
  String evidenceSources(String ids) {
    return 'Kaynak: $ids';
  }

  @override
  String get catAddSub => 'Alt kategori ekle';

  @override
  String get catName => 'Ad';

  @override
  String get catMove => 'Taşı';

  @override
  String get catInUse => 'Önce içindeki kategorileri ve işleri taşı ya da sil.';

  @override
  String catMoved(String name) {
    return '$name taşındı';
  }

  @override
  String catEmpty(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Burası henüz boş, ilk alt kategoriyi ekleyebilirsin.',
      'young': 'Henüz bir şey yok, hemen ekle.',
      'coder': 'Düğüm boş: alt kategori ya da iş yok.',
      'calm': 'Burada henüz bir şey yok.',
      'other': 'Henüz alt kategori ya da iş yok.',
    });
    return '$_temp0';
  }

  @override
  String get catDragHint =>
      'Taşımak için satırı soldaki tutamaçtan sürükle, bir kategorinin ya da kök kategori başlığının üstüne bırak.';

  @override
  String get moveTitle => 'Nereye taşınsın?';

  @override
  String get moveCannotIntoSelf => 'Bir kategori kendi altına taşınamaz.';

  @override
  String get projectProgress => 'İlerleme';

  @override
  String projectDoneOf(String done, String total) {
    return '$done / $total yapıldı';
  }

  @override
  String projectRemaining(String duration) {
    return 'Kalan: $duration';
  }

  @override
  String projectDeadline(String date) {
    return 'Son tarih: $date';
  }

  @override
  String get projectNoDeadline =>
      'Son tarih yok; parçaları sen yerleştirirsin.';

  @override
  String get projectNoTotal =>
      'Toplam süre belirtilmedi; parçaları sen yerleştirirsin.';

  @override
  String get projectModeAuto => 'Otomatik';

  @override
  String get projectModeManual => 'Elle';

  @override
  String get projectProposals => 'Önerilen parçalar';

  @override
  String get projectAcceptAll => 'Hepsini onayla';

  @override
  String projectAccepted(int n) {
    return '$n parça onaylandı';
  }

  @override
  String get projectScheduled => 'Plandaki parçalar';

  @override
  String get projectNoProposals => 'Şu an önerilecek parça yok.';

  @override
  String get projectComplete => 'Toplam süre tamamlandı ya da plana yerleşti.';

  @override
  String riskTitle(String date, String duration) {
    return 'Bu tempoyla $date tarihine $duration eksik kalıyor.';
  }

  @override
  String get riskExtendChunk => 'Parçayı uzat';

  @override
  String get riskRaiseCap => 'Günlük sınırı artır';

  @override
  String get riskMoveDeadline => 'Son tarihi taşı';

  @override
  String get riskApplied => 'Ayar güncellendi; plan yeniden hesaplandı.';

  @override
  String get manualTitle => 'Boş dilimler';

  @override
  String get manualHint =>
      'Parçayı tutamaçtan bir boş dilime sürükle ya da dilime dokun.';

  @override
  String manualChunk(String duration) {
    return '$duration parça';
  }

  @override
  String get manualPlaced => 'Parça yerleştirildi';

  @override
  String get manualNoSlots => 'Önümüzdeki günlerde uygun boş dilim yok.';

  @override
  String get projectNotFound => 'Bu proje bulunamadı.';

  @override
  String get chunkRemove => 'Parçayı kaldır';

  @override
  String get profileTitle => 'Profil';

  @override
  String get secGeneral => 'Genel';

  @override
  String get secPlan => 'Plan';

  @override
  String get secLocation => 'Konum ve vakitler';

  @override
  String get secNotifications => 'Bildirimler';

  @override
  String get settingLanguage => 'Dil';

  @override
  String get settingAppearance => 'Görünüm';

  @override
  String get settingSleep => 'Uyku penceresi';

  @override
  String get notSet => 'Ayarlanmadı';

  @override
  String get settingLocation => 'Konum';

  @override
  String locationValue(String lat, String lon) {
    return '$lat, $lon';
  }

  @override
  String get locationRemove => 'Konumu kaldır';

  @override
  String get settingPrayer => 'Namaz vakitleri';

  @override
  String get prayerOff => 'Kapalı';

  @override
  String get settingMinChunk => 'En kısa parça';

  @override
  String get settingBuffer => 'Parçalar arası tampon';

  @override
  String get settingDailyCap => 'Günlük azami odak';

  @override
  String engineDefault(String value) {
    return 'Varsayılan ($value)';
  }

  @override
  String get noLimit => 'Sınır yok';

  @override
  String get settingNotify => 'Sıradaki iş bildirimi';

  @override
  String notifyLead(int n) {
    return '$n dk önce';
  }

  @override
  String get notifyOff => 'Kapalı';

  @override
  String get settingExact => 'Tam zamanında';

  @override
  String get settingExactBody =>
      'Telefon uykudayken bile tam vaktinde gelir; sistem izni ister.';

  @override
  String get notifPermissionDenied =>
      'Bildirim izni verilmedi. Sistem ayarlarından açabilirsin.';

  @override
  String get onbNotifyTitle => 'Bildirimlere izin verelim mi?';

  @override
  String get onbNotifyBody =>
      'Sıradaki işi zamanında hatırlatırız, odak oturumunu kilit ekranında gösteririz, arkadaşın yazınca haber veririz. Bildirimde mesajın içeriği görünmez. Ayarı sonra Profil’den değiştirebilirsin.';

  @override
  String get notifyAllow => 'Bildirimlere izin ver';

  @override
  String get notifyGranted => 'Bildirimler açık.';

  @override
  String get notifyOffTitle => 'Bildirimler kapalı';

  @override
  String get notifyOffBody => 'Hatırlatmalar ve mesaj bildirimleri gelmez.';

  @override
  String get notifyTurnOn => 'Aç';

  @override
  String get settingHaptics => 'Dokunsal geri bildirim';

  @override
  String get notifChannel => 'Sıradaki iş';

  @override
  String get notifChannelDesc =>
      'Sıradaki işin başlamasına az kala hatırlatır.';

  @override
  String notifBody(String time, String when) {
    return '$time · $when';
  }

  @override
  String widgetNext(String title) {
    return 'Sıradaki: $title';
  }

  @override
  String get widgetNone => 'Sıradaki iş yok';

  @override
  String get widgetNow => 'Şimdi başlıyor';

  @override
  String get commonCancel => 'Vazgeç';

  @override
  String get actionFocus => 'Odaklan';

  @override
  String get secFocus => 'Odak';

  @override
  String get focusStart => 'Başla';

  @override
  String get focusMissingTitle => 'Bu iş artık planda yok';

  @override
  String get focusMissingBody =>
      'Plan değişmiş olabilir. Bugün ekranından yeniden seç.';

  @override
  String get focusChangeDurations => 'Süreleri değiştir';

  @override
  String get focusRuleHint =>
      'Başlayınca Android uygulamayı sabitlemek için onay ister; sabitliyken başka uygulamaya geçilemez. Sabitlemeden çıkıp uygulamadan ayrılırsan ya da bildirim panelini çekersen 10 saniye içinde dönmen gerekir; yoksa oturum bozulur. Ekranı kapatmak ve gelen arama sayılmaz, molada çıkmak serbest.';

  @override
  String get focusSummaryFree => 'Süre sınırı yok; bitirdiğinde dur.';

  @override
  String focusSummaryPomodoro(int work, int rest, int every, int long) {
    return '$work dk odak, $rest dk mola; $every döngüde bir $long dk uzun mola.';
  }

  @override
  String focusSummaryDeep(int target) {
    return 'Hedef $target dk kesintisiz odak. İstersen, o ana kadarki odak süresine göre önerilen bir mola verebilirsin.';
  }

  @override
  String focusOwnLength(int minutes) {
    return 'Kendi süresi kadar ($minutes dk)';
  }

  @override
  String get focusOwnLengthHint =>
      'Süre dolunca oturum kendiliğinden tamamlanır.';

  @override
  String get focusFieldWork => 'Odak (dk)';

  @override
  String get focusFieldBreak => 'Mola (dk)';

  @override
  String get focusFieldLongBreak => 'Uzun mola (dk)';

  @override
  String get focusFieldLongEvery => 'Uzun mola kaç döngüde bir';

  @override
  String get focusFieldTarget => 'Hedef (dk)';

  @override
  String get focusPause => 'Duraklat';

  @override
  String get focusResume => 'Devam';

  @override
  String get focusFinish => 'Bitir';

  @override
  String get focusEndBreak => 'Molayı bitir';

  @override
  String focusTakeBreak(int minutes) {
    return 'Mola ver · $minutes dk önerilir';
  }

  @override
  String focusEmergency(int left) {
    return 'Acil durum ($left hakkın var)';
  }

  @override
  String get focusEmergencyNone => 'Bugünkü acil durum hakların bitti';

  @override
  String get focusEmergencyTitle => 'Acil durum';

  @override
  String focusEmergencyBody(int left) {
    return 'Oturum cezasız duraklar ve uygulamadan çıkabilirsin. Döndüğünde Devam\'a dokun. Bundan sonra bugün kalan hakkın: $left.';
  }

  @override
  String get focusEmergencyConfirm => 'Duraklat';

  @override
  String focusPhaseCycle(int n) {
    return 'Odak · $n. döngü';
  }

  @override
  String focusPhaseDeep(int target) {
    return 'Derin çalışma · hedef $target dk';
  }

  @override
  String get focusPhaseBreak => 'Mola · uygulamadan çıkabilirsin';

  @override
  String get focusPhaseBreakOver => 'Mola bitti · hazır olunca devam et';

  @override
  String get focusPhasePaused => 'Duraklatıldı · uygulamada kal';

  @override
  String get focusPhaseEmergency => 'Acil durum · uygulamadan çıkabilirsin';

  @override
  String focusTimeLeft(String time) {
    return 'Kalan $time';
  }

  @override
  String focusTimeElapsed(String time) {
    return 'Geçen $time';
  }

  @override
  String focusTotal(String time) {
    return 'Bu oturumda $time odak';
  }

  @override
  String get focusBackHint => 'Oturumu bitirmek için Bitir\'e dokun.';

  @override
  String focusOverlaySeconds(int seconds) {
    return '$seconds sn içinde dön';
  }

  @override
  String get focusPardonTitle => 'Aramadaymışsın gibi görünüyor';

  @override
  String get focusPardonBody =>
      '10 saniyeden uzun dışarıdaydın ama telefon bir arama gösteriyordu. Aramadaydıysan oturum sürer, arama süresi odak sayılmaz.';

  @override
  String get focusPardonYes => 'Evet, aramadaydım';

  @override
  String get focusPardonNo => 'Hayır';

  @override
  String get focusOngoingChannel => 'Süren odak oturumu';

  @override
  String get focusAlertChannel => 'Odak uyarıları';

  @override
  String get focusAlertTitle => 'Planı bozuyorsun';

  @override
  String get focusAlertBody =>
      '10 saniye içinde dön, yoksa oturum bozulur. Dönmek için dokun.';

  @override
  String get focusBrokenTitle => 'Odak bozuldu';

  @override
  String get focusBrokenBody =>
      '10 saniye içinde dönülmedi. Hazır olduğunda yeniden başlayabilirsin.';

  @override
  String get focusBreakTitle => 'Mola zamanı';

  @override
  String focusBreakBody(int minutes) {
    return '$minutes dk mola. Uygulamadan çıkabilirsin.';
  }

  @override
  String get focusBreakOverTitle => 'Mola bitti';

  @override
  String get focusBreakOverBody => 'Hazır olduğunda uygulamaya dönüp devam et.';

  @override
  String get focusTargetTitle => 'Hedefe ulaştın';

  @override
  String focusTargetBody(int minutes) {
    return '$minutes dk derin çalışma tamam. İstersen sürdür ya da bitir.';
  }

  @override
  String focusBrokenHeading(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Bu sefer olmadı',
      'young': 'Bu tur bozuldu',
      'coder': 'Oturum sonlandı: bozuldu',
      'calm': 'Oturum yarıda kaldı',
      'other': 'Oturum bozuldu',
    });
    return '$_temp0';
  }

  @override
  String focusBrokenWhat(String time) {
    return 'Saat $time: uygulamadan çıkıldı ve 10 saniye içinde dönülmedi, oturum durdu.';
  }

  @override
  String focusBrokenBrain(String root, int minutes) {
    return 'Bu oturum beyne eklenmedi. $root ile ilişkilendirilen bölgelerde $minutes dakikalık kısım söndü; yeniden odaklandıkça yanar.';
  }

  @override
  String get focusBrokenBrainNone =>
      'Bu oturum beyne eklenmedi; sönen bir kısım yok.';

  @override
  String focusBrokenAgain(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Olur böyle şeyler. Hazır olunca yeniden başlarız.',
      'young': 'Takma kafana, hazır olunca yeniden başla.',
      'coder': 'Yeniden başlatmak her zaman mümkün.',
      'calm': 'Sorun değil. Hazır hissettiğinde yeniden başlayabilirsin.',
      'other': 'Olabilir. Hazır olduğunda yeniden başlayabilirsin.',
    });
    return '$_temp0';
  }

  @override
  String get focusRestart => 'Yeniden başlat';

  @override
  String get focusBackToToday => 'Bugün\'e dön';

  @override
  String get focusRateFocus => 'Ne kadar odaklanabildin?';

  @override
  String get focusRateFocusLow => '1 · hiç';

  @override
  String get focusRateFocusHigh => '5 · tamamen';

  @override
  String get focusRateFatigue => 'Ne kadar yorgunsun?';

  @override
  String get focusRateFatigueLow => '1 · hiç';

  @override
  String get focusRateFatigueHigh => '5 · çok';

  @override
  String get focusNoteTitle => 'Kısa bir not';

  @override
  String get focusNoteLabel => 'Not (isteğe bağlı)';

  @override
  String focusGainTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Bu oturumun ödülü',
      'young': 'Bu oturumdan kazancın',
      'coder': 'Oturum çıktısı',
      'calm': 'Bu oturumun karşılığı',
      'other': 'Bu oturumun karşılığı',
    });
    return '$_temp0';
  }

  @override
  String focusGainBody(String root, int minutes) {
    return '$root ile ilişkilendirilen bölgelere $minutes dk ayırdın.';
  }

  @override
  String focusGainNone(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Çok kısa sürdü; beyne eklenecek süre birikmedi.',
      'young': 'Bir dakikadan kısaydı; bu sefer kazanç yok.',
      'coder': 'Süre < 1 dk; beyne yazılacak bir şey yok.',
      'calm':
          'Bir dakikadan kısa sürdü; bu sefer beyne eklenecek süre birikmedi.',
      'other': 'Bir dakikadan kısa sürdü; beyne eklenecek süre birikmedi.',
    });
    return '$_temp0';
  }

  @override
  String focusGainShare(int percent) {
    return 'Pay: %$percent';
  }

  @override
  String get focusGainExplain =>
      'Çubuklar, nöron kazancının bu bölgelere nasıl dağıldığını gösterir. Dağılım, bölgelerin kanıt düzeyine göre belirlenen bir ürün kararıdır; beyninin ölçümü değildir.';

  @override
  String focusRewardPomodoro(int cycles, int streak) {
    return '$cycles döngü tamamladın · seri: $streak oturum';
  }

  @override
  String focusRewardDeep(int longest, int record) {
    return 'En uzun kesintisiz odak: $longest dk · rekorun: $record dk';
  }

  @override
  String get focusDone => 'Bitti';

  @override
  String get settingFocusDnd => 'Odakta Rahatsız Etmeyin';

  @override
  String get settingFocusDndBody =>
      'Oturum başlayınca açılır, bitince eski haline döner.';

  @override
  String get focusDndDenied => 'Rahatsız Etmeyin erişimi verilmedi.';

  @override
  String get settingAutoRun => 'Saatinde otomatik başlat ve bitir';

  @override
  String get settingAutoRunBody =>
      'Uygulama açıksa odak gerektiren iş saatinde kendiliğinden başlar, bitiş saatinde biter. Diğer işler için başlangıçta ve bitişte bildirim gelir.';

  @override
  String get autoFocusBody => 'Odaklanma zamanı. Dokun, oturum başlasın.';

  @override
  String autoStartBody(String time) {
    return 'Şimdi başlıyor · $time';
  }

  @override
  String get autoDoneBody => 'Bitiş saati geldi. Yaptın mı?';

  @override
  String get settingFocusCalls => 'Gelen aramalar kaçış sayılmasın';

  @override
  String get settingFocusCallsBody =>
      'Telefon durumu izni ister. İzin yoksa dönüşte sorulur.';

  @override
  String get settingFocusCallsOn =>
      'İzin verildi. Kaldırmak için sistem ayarlarını kullan.';

  @override
  String get focusPhoneDenied =>
      'Telefon durumu izni verilmedi; aramadan sonra dönüşte sorulur.';

  @override
  String get secAbout => 'Hakkında';

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String get aboutSubtitle => 'Lisanslar ve atıflar';

  @override
  String get aboutAppBody =>
      'NöroPlan açık kaynaklıdır ve AGPL-3.0 lisansıyla dağıtılır.';

  @override
  String get aboutModelTitle => '3D beyin modeli';

  @override
  String get aboutModelBody =>
      '3D beyin, BodyParts3D 4.0 çokgen verisinden sadeleştirilip bölgelere göre birleştirilerek üretildi.';

  @override
  String get aboutModelCredit =>
      'BodyParts3D, © The Database Center for Life Science licensed under CC Attribution 4.0 International';

  @override
  String get aboutThreeBody =>
      '3D sahne Three.js ile çizilir (MIT lisansı). Sahne ve kütüphane uygulamanın içindedir; internet gerekmez.';

  @override
  String get aboutFontsTitle => 'Fontlar';

  @override
  String get aboutFontsBody =>
      'Bütün fontlar uygulamanın içindedir ve SIL Open Font License 1.1 ile dağıtılır. Lisans metinleri aşağıdaki düğmede.';

  @override
  String get aboutLicenses => 'Bütün lisansları göster';

  @override
  String get brainListAction => 'Liste görünümü';

  @override
  String get brainResetView => 'Görünümü sıfırla';

  @override
  String get brainSceneLoading => 'Beyin hazırlanıyor';

  @override
  String get brainSceneErrorTitle => '3D beyin bu cihazda açılamadı';

  @override
  String get brainSceneErrorBody => 'Aynı bilgiyi liste olarak görebilirsin.';

  @override
  String brainEmptyTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Beyin seni bekliyor',
      'young': 'Beynin ışıklarını yakmaya hazır',
      'coder': 'Nöron sayısı: 0',
      'calm': 'Beyin henüz sessiz',
      'other': 'Henüz yanan nöron yok',
    });
    return '$_temp0';
  }

  @override
  String get brainEmptyBody =>
      'Bir odak oturumunu tamamladığında, işin kategorisiyle ilişkilendirilen bölgelerde nöronlar yanar. 3D beyin bir metafordur, ölçüm değildir.';

  @override
  String get brainTimeline => 'Zaman çizelgesi';

  @override
  String get brainTimelineNow => 'Bugün';

  @override
  String brainTimelineAt(String date) {
    return '$date itibarıyla';
  }

  @override
  String get brainListTitle => 'Beyin bölgeleri';

  @override
  String get brainCategoriesTile => 'Kategoriler';

  @override
  String get brainCategoriesBody =>
      'Alt kategori ekle, taşı; her kökün bölgelerini gör.';

  @override
  String regionNeurons(int count, int brightness) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nöron · parlaklık %$brightness',
      zero: 'Henüz beslenmedi',
    );
    return '$_temp0';
  }

  @override
  String regionDimmed(int count) {
    return '$count nöron sönük; yeniden odaklandıkça yanar.';
  }

  @override
  String regionHemisphere(String side) {
    String _temp0 = intl.Intl.selectLogic(side, {
      'left': 'Sol yarımküre',
      'right': 'Sağ yarımküre',
      'other': 'İki yarımküre',
    });
    return '$_temp0';
  }

  @override
  String get regionInner => 'İç yapı';

  @override
  String regionLastActive(String date) {
    return 'Son beslendiği gün: $date';
  }

  @override
  String regionMinutes30(int minutes) {
    return 'Son 30 günde bu bölgeyle ilişkilendirilen etkinliklere $minutes dakika ayırdın.';
  }

  @override
  String get regionMinutes30None =>
      'Son 30 günde bu bölgeyle ilişkilendirilen bir odak oturumu yok.';

  @override
  String get regionChartLabel => 'Son 30 gün, günlük yanan nöron';

  @override
  String regionChartSummary(int days, int max) {
    return '$days gün beslendi; bir günde en çok $max nöron.';
  }

  @override
  String get regionFedBy => 'Seni besleyenler (son 30 gün)';

  @override
  String get regionEvidence => 'Hangi kategoriler, hangi kanıtla';

  @override
  String get regionEvidenceNone =>
      'Bu bölgeye bağlı bir kök kategori yok; beyin bütün görünsün diye çizilir.';

  @override
  String get regionMetaphor =>
      '3D beyin bir metafordur, ölçüm değildir. Kanıt düzeyi ilgili araştırmaların gücünü anlatır; senin beynini ölçmez.';

  @override
  String regionMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get navTogether => 'Birlikte';

  @override
  String navBadge(String label, int count) {
    return '$label, $count bekleyen';
  }

  @override
  String get secAccount => 'Hesap';

  @override
  String get accountGoogle => 'Google hesabı';

  @override
  String get accountGuest => 'Misafir';

  @override
  String get accountGuestBody =>
      'Verilerin bu cihazda ve yedekte. Google ile bağlanınca kalıcı olur, başka cihazda da açılır.';

  @override
  String get accountDeviceOnly => 'Yalnız bu cihazda';

  @override
  String get accountDeviceOnlyBody =>
      'Bu kurulumda sunucu ayarı yok; her şey cihazında çalışır.';

  @override
  String get accountOffline =>
      'Şu an sunucuya bağlı değil; bağlantı gelince eşitlenir.';

  @override
  String get accountDeleteTitle => 'Hesabı ve verileri sil';

  @override
  String get accountDeleteSubtitle =>
      'Planın, odak oturumların, beynin ve sosyal verilerin kalıcı olarak silinir.';

  @override
  String get accountDeleteBody =>
      'Bu işlem geri alınamaz. Arkadaşlıkların, mesajların ve ortak işlerin de silinir. Hakkında yapılmış şikâyetler kimliğin olmadan moderasyon için kalır.';

  @override
  String get accountDeleteAction => 'Kalıcı olarak sil';

  @override
  String get accountDeleteError =>
      'Silinemedi. İnternet bağlantını kontrol edip tekrar dene.';

  @override
  String get onbAgeTitle => 'Doğum yılın';

  @override
  String get onbAgeBody =>
      'Yalnız yıl tutulur. Yaşına göre seni koruyan ayarlar kurulur; 13 yaşından küçükler uygulamayı kullanamaz.';

  @override
  String get onbAgeTooYoung =>
      'NöroPlan 13 yaş ve üstü içindir. Bu yıl seçiliyken devam edilemez.';

  @override
  String onbAgeSaved(String year) {
    return 'Doğum yılın kaydedildi: $year. Yaş sonradan küçültülemez.';
  }

  @override
  String get tgOfflineTitle => 'Birlikte bölümü sunucu ister';

  @override
  String get tgOfflineBody =>
      'Bu kurulumda sunucu ayarı yok. Plan, odak ve beyin cihazında tam çalışır.';

  @override
  String get tgGuestTitle => 'Arkadaşlarınla birlikte çalış';

  @override
  String get tgGuestBody =>
      'Birlikte bölümü Google hesabı ister. Bağlanınca verilerin aynı kalır. Kimse seni rastgele bulamaz; arkadaşlık yalnız davetle kurulur.';

  @override
  String get tgConnectGoogle => 'Google ile bağlan';

  @override
  String get tgConnected => 'Google hesabın bağlandı.';

  @override
  String get tgConnectedSwitched =>
      'Google hesabına geçildi; bu cihazdaki verilerin o hesaba gönderiliyor.';

  @override
  String get tgConnectError => 'Google ile bağlanılamadı. Tekrar dene.';

  @override
  String get tgAgeTitle => 'Önce doğum yılın';

  @override
  String get tgAgeBody =>
      'Sosyal özellikler 15 yaşında açılır; 18 yaşından küçüklerde en sıkı gizlilik ayarları kullanılır. Yalnız yıl tutulur.';

  @override
  String get tgBirthYear => 'Doğum yılı';

  @override
  String get tgTooYoungTitle => 'Birlikte bölümü 15 yaşında açılır';

  @override
  String get tgTooYoungBody =>
      'Bu kural seni korumak için. Plan, odak ve beyin her yaşta tam çalışır.';

  @override
  String get tgSuspendedTitle => 'Sosyal özellikler geçici olarak kapalı';

  @override
  String tgSuspendedBody(String date) {
    return 'Bir şikâyet incelendi ve sosyal özelliklerin $date tarihine kadar kapatıldı. Plan, odak ve beyin çalışmaya devam eder.';
  }

  @override
  String get tgSetupTitle => 'Arkadaşların seni nasıl görsün?';

  @override
  String get tgSetupBody =>
      'Takma adın yalnız arkadaşlarına görünür. Kullanıcı adı isteğe bağlıdır; ayarlardan açmazsan kimse seni onunla bulamaz.';

  @override
  String get tgDisplayName => 'Takma ad';

  @override
  String get tgUsernameOptional => 'Kullanıcı adı (isteğe bağlı)';

  @override
  String get tgUsernameHelp =>
      '3–20 karakter: küçük harf, rakam, alt çizgi. Tam adı bilen biri istek gönderebilir, ama yalnız sen bulunabilirliği açarsan.';

  @override
  String get tgNameRequired => 'Bir takma ad yaz.';

  @override
  String get tgUsernameRule =>
      'Kullanıcı adı 3–20 karakter olmalı: küçük harf, rakam ya da alt çizgi.';

  @override
  String get tgTermsBody =>
      'Devam ederek topluluk kurallarını kabul edersin: taciz, nefret söylemi, cinsel içerik, spam ve çocukları tehlikeye atan her şey yasaktır. Her ekranda şikâyet edebilir ve engelleyebilirsin; şikâyetler incelenir.';

  @override
  String get tgSetupAction => 'Kabul et ve başla';

  @override
  String get tgEmptyTitle => 'İlk arkadaşını davet et';

  @override
  String get tgEmptyBody =>
      'Arkadaşlık yalnız davetle kurulur: kodunu ya da QR kodunu paylaş, ya da onun kodunu gir.';

  @override
  String get tgInviteFirst => 'Arkadaş davet et';

  @override
  String get tgCofocusBack => 'Ortak odak oturumun açık.';

  @override
  String get tgOpen => 'Aç';

  @override
  String tgCofocusInvite(String name) {
    return '$name seni ortak odağa çağırıyor.';
  }

  @override
  String get tgJoin => 'Katıl';

  @override
  String get tgDecline => 'Hayır';

  @override
  String get tgAccept => 'Kabul et';

  @override
  String tgPartnerAsked(String name) {
    return '$name seni partneri olarak seçmek istiyor.';
  }

  @override
  String get tgPartnerDone => 'Artık partnersiniz.';

  @override
  String get tgSecTogether => 'Birlikte çalış';

  @override
  String get tgSecPeople => 'Kişiler';

  @override
  String get tgSecPrivacy => 'Gizlilik';

  @override
  String tgPartnerPlan(String name) {
    return 'Partnerin $name: planı';
  }

  @override
  String get tgChoosePartner => 'Partner seç';

  @override
  String get tgChoosePartnerBody =>
      'Ortak çalışma ve plan görme için daha yakın bir bağ; aynı anda bir partner.';

  @override
  String get tgCofocusNew => 'Ortak odak başlat';

  @override
  String get tgCofocusNewBody =>
      'Aynı anda başlayın, herkes kendi işine odaklansın.';

  @override
  String get tgShared => 'Ortak etkinlikler';

  @override
  String get tgFreeTime => 'Ortak boş zaman bul';

  @override
  String get tgMessages => 'Mesajlar';

  @override
  String get tgFriends => 'Arkadaşlar';

  @override
  String get tgInvite => 'Davet et';

  @override
  String get tgLeaderboard => 'Sıralama';

  @override
  String get tgPrivacy => 'Gizlilik ayarları';

  @override
  String get tgPrivacyBody => 'Kim neyi görür: plan, profil, beyin.';

  @override
  String get tgCancel => 'Vazgeç';

  @override
  String get tgPartner => 'Partner';

  @override
  String get tgErrRate => 'Biraz yavaşla; kısa bir süre sonra tekrar dene.';

  @override
  String get tgErrNetwork =>
      'Sunucuya ulaşılamadı. İnternet bağlantını kontrol et.';

  @override
  String get tgErrNotFound => 'Bulunamadı ya da artık geçerli değil.';

  @override
  String get tgErrForbidden => 'Bunu yapmaya iznin yok.';

  @override
  String get tgErrNotPublished =>
      'Seçtiğin kişilerden biri takvimini henüz paylaşmadı; Birlikte bölümünü açınca paylaşılır.';

  @override
  String get tgErrNotEligible => 'Sosyal özellikler bu hesapta açık değil.';

  @override
  String get tgErrUsernameTaken => 'Bu kullanıcı adı alınmış.';

  @override
  String get tgErrPartnerTaken =>
      'Birinizin zaten partneri var; önce o partnerlik bitmeli.';

  @override
  String get tgErrAlready => 'Bu zaten yapılmış.';

  @override
  String get tgErrInvalid => 'Girilen bilgi geçerli değil.';

  @override
  String get tgIncoming => 'Gelen istekler';

  @override
  String get tgWantsToBeFriends => 'Arkadaş olmak istiyor';

  @override
  String get tgPartnerPending => 'Partner isteği bekliyor';

  @override
  String get tgOutgoing => 'Gönderdiğin istekler';

  @override
  String get tgRequestSent => 'İstek gönderildi';

  @override
  String get tgWithdraw => 'Geri al';

  @override
  String get tgBlocked => 'Engellediklerin';

  @override
  String get tgUnblock => 'Engeli kaldır';

  @override
  String get tgUnblocked =>
      'Engel kaldırıldı. Yeniden arkadaş olmak için yeni bir davet gerekir.';

  @override
  String get tgNotFriendTitle => 'Artık arkadaş değilsiniz';

  @override
  String get tgNotFriendBody =>
      'Bu kişiyle ilgili hiçbir şey görüntülenemiyor.';

  @override
  String get tgSendMessage => 'Mesaj gönder';

  @override
  String get tgSeePlan => 'Planını gör';

  @override
  String get tgCompareBrains => 'Beyinleri karşılaştır';

  @override
  String get tgEndPartner => 'Partnerliği bitir';

  @override
  String get tgEndPartnerBody =>
      'Arkadaşlığınız sürer; partnere özel görünürlük biter.';

  @override
  String get tgAskPartner => 'Partnerim olsun';

  @override
  String get tgAskPartnerBody => 'Karşı taraf onaylayınca partner olursunuz.';

  @override
  String get tgAskPartnerBlocked => 'Önce şu anki partnerliğini bitirmelisin.';

  @override
  String get tgPartnerRequested => 'Partner isteği gönderildi.';

  @override
  String get tgShowFull => 'Planımı bu kişiye tam göster';

  @override
  String get tgShowFullBody =>
      'Başlık, saat, kategori ve notlar. Bu istisna kategori kurallarının önüne geçer.';

  @override
  String get tgSafety => 'Güvenlik';

  @override
  String get tgRemoveFriend => 'Arkadaşlıktan çıkar';

  @override
  String tgRemoveFriendBody(String name) {
    return '$name artık planını, mesajlarını ve beynini göremez. Yeniden arkadaş olmak için yeni bir davet gerekir.';
  }

  @override
  String get tgBlock => 'Engelle';

  @override
  String tgBlockTitle(String name) {
    return '$name engellensin mi?';
  }

  @override
  String get tgBlockBody =>
      'Arkadaşlık ve partnerlik biter, sohbet ikiniz için de kapanır. Seni bulamaz, davet gönderemez ve engellendiğini görmez.';

  @override
  String get tgBlocked1 => 'Engellendi.';

  @override
  String get tgReport => 'Şikâyet et';

  @override
  String get tgInviteTitle => 'Davet kodun';

  @override
  String get tgInviteBody =>
      'Kod 7 gün geçerli ve tek kullanımlık. Yalnız güvendiğin kişiyle paylaş.';

  @override
  String get tgKindFriend => 'Arkadaş daveti';

  @override
  String get tgKindPartner => 'Partner daveti';

  @override
  String get tgCreateCode => 'Kod oluştur';

  @override
  String tgQrLabel(String code) {
    return 'Davet kodunun QR görüntüsü: $code';
  }

  @override
  String tgExpires(String date) {
    return '$date tarihine kadar geçerli';
  }

  @override
  String get tgCopy => 'Kopyala';

  @override
  String get tgCopied => 'Kopyalandı.';

  @override
  String get tgRevoke => 'İptal et';

  @override
  String get tgHaveCode => 'Kodun mu var?';

  @override
  String get tgCode => 'Davet kodu';

  @override
  String get tgScan => 'QR kodu tara';

  @override
  String get tgUseCode => 'Kodu kullan';

  @override
  String get tgCodeRule => 'Davet kodu 10 karakterdir.';

  @override
  String tgRedeemed(String name) {
    return '$name ile artık arkadaşsınız.';
  }

  @override
  String tgRedeemedPartner(String name) {
    return '$name ile artık partnersiniz.';
  }

  @override
  String get tgByUsername => 'Tam kullanıcı adıyla';

  @override
  String get tgByUsernameBody =>
      'Yalnız bulunabilirliği açık hesaplara istek gider. Arama ya da öneri yoktur.';

  @override
  String get tgUsername => 'Kullanıcı adı';

  @override
  String get tgSendRequest => 'İstek gönder';

  @override
  String get tgCameraTitle => 'Kamera açılamadı';

  @override
  String get tgCameraBody =>
      'Kamera izni verilmedi ya da kamera yok. Kodu elle de yazabilirsin.';

  @override
  String get tgScanHint => 'Arkadaşının ekranındaki QR kodu çerçeveye getir.';

  @override
  String tgPlanOf(String name) {
    return '$name: plan';
  }

  @override
  String get tgWeek => 'Hafta';

  @override
  String get tgPlanEmptyTitle => 'Paylaşılan bir şey yok';

  @override
  String tgPlanEmptyBody(String name) {
    return '$name bu günlerde bir şey paylaşmıyor ya da planı boş. Neyin görüneceğine $name karar verir.';
  }

  @override
  String get tgBusy => 'Meşgul';

  @override
  String get tgPlanReadOnly => 'Salt okunur. Görünürlüğü planın sahibi seçer.';

  @override
  String get tgLevelFull => 'Tam (başlık, saat, not)';

  @override
  String get tgLevelTitleTime => 'Başlık ve saat';

  @override
  String get tgLevelBusy => 'Sadece \"meşgul\"';

  @override
  String get tgLevelHidden => 'Gizli';

  @override
  String get tgLevelDefault => 'Varsayılan';

  @override
  String get tgLevelFullBody => 'Başlık, saat, kategori ve notlar görünür.';

  @override
  String get tgLevelTitleTimeBody =>
      'Başlık ve saat görünür; not ve kategori görünmez.';

  @override
  String get tgLevelBusyBody => 'Yalnız o saatte meşgul olduğun görünür.';

  @override
  String get tgLevelHiddenBody => 'Hiç görünmez.';

  @override
  String get tgLevelDefaultBody =>
      'Partnere başlık ve saat, diğer arkadaşlara \"meşgul\".';

  @override
  String get tgSecProfile => 'Profil';

  @override
  String get tgDiscoverable => 'Kullanıcı adımla bulunabilirim';

  @override
  String tgDiscoverableBody(String username) {
    return 'Tam olarak @$username yazan biri istek gönderebilir.';
  }

  @override
  String get tgDiscoverableNoUsername => 'Önce bir kullanıcı adı gerekir.';

  @override
  String get tgGlobalBoard => 'Genel sıralamaya katıl';

  @override
  String get tgGlobalBoardBody =>
      'Takma adınla, haftalık odak dakikası ve süreklilikle.';

  @override
  String get tgGlobalBoardMinor =>
      '18 yaşından küçüklerde genel sıralama kapalıdır.';

  @override
  String get tgShareBrain => 'Arkadaşlarım beynimi görebilsin';

  @override
  String get tgShareBrainBody =>
      'Karşılaştırma için; sunucu beyni oturum kayıtlarından hesaplar.';

  @override
  String get tgSecPlanVisibility => 'Plan görünürlüğü';

  @override
  String get tgPlanVisibilityBody =>
      'Her kategori için seç. Alt kategori kuralı yoksa üst kategoriye bakılır. Kurallar veritabanında uygulanır.';

  @override
  String get tgAllCategories => 'Bütün kategoriler';

  @override
  String get tgVisibilityFootnote =>
      'Ortak boş zaman aramasında yalnız boş aralıklar paylaşılır; gizli işlerin de \"dolu\" sayılır ama içerikleri hiç gönderilmez.';

  @override
  String get tgNoMessagesTitle => 'Henüz mesaj yok';

  @override
  String get tgNoMessagesBody => 'Bir arkadaşının sayfasından sohbet başlat.';

  @override
  String get tgNoMessagesYet => 'Henüz mesaj yok';

  @override
  String get tgMessageDeleted => 'Mesaj silindi';

  @override
  String get tgYou => 'Sen';

  @override
  String get tgMuted => 'Bildirimler kapalı';

  @override
  String tgReactWith(String emoji) {
    return '$emoji ile tepki ver';
  }

  @override
  String get tgReportMessage => 'Mesajı şikâyet et';

  @override
  String get tgMore => 'Diğer';

  @override
  String get tgMute => 'Bildirimleri kapat';

  @override
  String get tgUnmute => 'Bildirimleri aç';

  @override
  String tgChatEmptyTitle(String name) {
    return '$name ile sohbet';
  }

  @override
  String get tgChatEmptyBody =>
      'Mesajlar yalnız ikinize görünür. Uygunsuz kelimeler yıldızlanır.';

  @override
  String get tgMessageHint => 'Tepki, kopyala ya da şikâyet için dokun';

  @override
  String get tgWriteMessage => 'Mesaj yaz';

  @override
  String get tgSend => 'Gönder';

  @override
  String get tgReasonHarassment => 'Taciz ya da zorbalık';

  @override
  String get tgReasonInappropriate => 'Uygunsuz içerik';

  @override
  String get tgReasonSpam => 'Spam';

  @override
  String get tgReasonChildSafety => 'Çocuk güvenliği';

  @override
  String get tgReasonOther => 'Başka bir şey';

  @override
  String get tgReportBody =>
      'Ne oldu? Şikâyetin incelenir; şikâyet ettiğin kişiye adın söylenmez. Mesaj şikâyetinde mesajın bir kopyası saklanır.';

  @override
  String get tgReportDetails => 'Açıklama (isteğe bağlı)';

  @override
  String get tgReportSend => 'Şikâyeti gönder';

  @override
  String get tgReportThanks =>
      'Şikâyetin alındı. İstersen bu kişiyi engelleyebilirsin.';

  @override
  String get tgReportUrgent =>
      'Biri seni ya da başkasını hemen tehlikeye atıyorsa 112\'yi ara.';

  @override
  String get tgGlobal => 'Genel';

  @override
  String get tgMetricFocus => 'Odak dakikası';

  @override
  String get tgMetricStreak => 'Süreklilik';

  @override
  String get tgBoardNote =>
      'Haftalık, pazartesi sıfırlanır. Yalnız sunucuda doğrulanan oturumlar sayılır: çakışan ya da gerçek süreden uzun oturum girmez.';

  @override
  String get tgGlobalNotJoined => 'Genel sıralamaya katılmadın.';

  @override
  String get tgBoardEmpty => 'Bu hafta henüz tamamlanan oturum yok.';

  @override
  String tgDays(int n) {
    return '$n gün';
  }

  @override
  String get tgSharedNew => 'Ortak etkinlik öner';

  @override
  String get tgSharedEmptyTitle => 'Henüz ortak etkinlik yok';

  @override
  String get tgSharedEmptyBody =>
      'Bir etkinlik ya da proje öner; arkadaşın kabul edince ikinizin planına da düşer.';

  @override
  String tgProgress(String done, String total) {
    return '$done / $total';
  }

  @override
  String tgWith(String names) {
    return 'Birlikte: $names';
  }

  @override
  String get tgStatusConfirmed => 'Onaylandı';

  @override
  String get tgStatusCancelled => 'İptal edildi';

  @override
  String get tgStatusProposed => 'Yanıt bekleniyor';

  @override
  String tgChangeProposed(String text) {
    return 'Değişiklik önerildi: $text';
  }

  @override
  String tgChangeWaiting(String text) {
    return 'Onay bekleyen değişiklik: $text';
  }

  @override
  String get tgSharedAccepted => 'Planına eklendi.';

  @override
  String get tgSharedCancel => 'İptal et';

  @override
  String get tgSharedCancelBody => 'Etkinlik herkesin planından kalkar.';

  @override
  String get tgSharedLeave => 'Ayrıl';

  @override
  String get tgSharedLeaveBody =>
      'Etkinlik senin planından kalkar; diğerleri için sürer.';

  @override
  String get tgSuggestChange => 'Değişiklik öner';

  @override
  String tgPatchTitle(String title) {
    return 'ad \"$title\"';
  }

  @override
  String get tgSharedKindTitle => 'Ne planlıyorsunuz?';

  @override
  String get tgKindActivity => 'Etkinlik';

  @override
  String get tgKindActivityBody => 'Belli bir gün ve saatte birlikte.';

  @override
  String get tgKindProject => 'Proje';

  @override
  String get tgKindProjectBody =>
      'Toplam süre ve son tarih; ilerleme paylaşılır.';

  @override
  String get tgSharedNameTitle => 'Adı ne olsun?';

  @override
  String get tgSharedName => 'Ad';

  @override
  String get tgSharedNotes => 'Not (isteğe bağlı)';

  @override
  String get tgSharedWithTitle => 'Kiminle?';

  @override
  String get tgSharedWhenTitle => 'Ne zaman?';

  @override
  String get tgSharedDeadlineTitle => 'Son tarih ve toplam süre';

  @override
  String tgSharedTotal(String duration) {
    return 'Toplam: $duration';
  }

  @override
  String get tgFrom => 'Başlangıç';

  @override
  String get tgTo => 'Bitiş';

  @override
  String get tgEndAfterStart => 'Bitiş başlangıçtan sonra olmalı.';

  @override
  String get tgSharedRootTitle => 'Hangi kök kategori?';

  @override
  String get tgSharedRootBody =>
      'Odak oturumların beyinde bu kategoriye göre büyür.';

  @override
  String get tgNoCategory => 'Kategori yok';

  @override
  String get tgSharedConfirmTitle => 'Gönderilsin mi?';

  @override
  String get tgSharedConfirmBody =>
      'Kabul eden herkesin planına sabit iş olarak düşer. Sonraki değişiklikler karşı tarafın onayına gider.';

  @override
  String get tgSharedSend => 'Gönder';

  @override
  String get tgSharedSent => 'Öneri gönderildi.';

  @override
  String get tgChangeBody =>
      'Değişiklik diğer katılımcıların onayına gider; hepsi onaylayınca uygulanır.';

  @override
  String get tgSendChange => 'Onaya gönder';

  @override
  String get tgChangeSent => 'Değişiklik onaya gönderildi.';

  @override
  String get tgFreeTimeBody =>
      'Seçtiğin arkadaşlarla önümüzdeki 7 günde herkesin boş olduğu saatleri bulur. Kimin ne yaptığı gösterilmez.';

  @override
  String get tgFreeTimeLength => 'En az ne kadar?';

  @override
  String get tgFreeTimeFind => 'Boş zaman bul';

  @override
  String get tgFreeTimeNone =>
      'Herkesin boş olduğu bir aralık bulunamadı. Süreyi kısaltmayı dene.';

  @override
  String get tgPlanHere => 'Burada planla';

  @override
  String tgCompareTitle(String name) {
    return 'Sen ve $name';
  }

  @override
  String get tgCompareNote =>
      'Beyin bir metafordur, ölçüm değildir. Arkadaşının beyni sunucuda oturum kayıtlarından hesaplanır.';

  @override
  String get tgLeftYou => 'Solda sen';

  @override
  String tgRightFriend(String name) {
    return 'Sağda $name';
  }

  @override
  String tgNeurons(int n) {
    return '$n nöron';
  }

  @override
  String get tgCofocus => 'Ortak odak';

  @override
  String get tgCofocusIntro =>
      'Aynı anda başlarsınız; herkes kendi işini ve modunu seçer. Biri planı bozarsa diğerleri sakin bir notla görür. Birlikte tamamlanan oturum küçük bir ortak bağlantı kazandırır.';

  @override
  String get tgCofocusWho => 'Kimler';

  @override
  String get tgVoice => 'Sesli sohbet';

  @override
  String get tgVoiceBody =>
      'İsteğe bağlı. Mikrofon kapalı başlar, kayıt yapılmaz.';

  @override
  String get tgCofocusInviteAction => 'Davet et';

  @override
  String get tgCofocusEnded => 'Bu ortak oturum bitti.';

  @override
  String get tgCofocusLive => 'Oturum başladı. İşini seçip katıl.';

  @override
  String get tgCofocusHostHint =>
      'Herkes işini seçince başlat; sayaçlar aynı anda başlar.';

  @override
  String get tgCofocusGuestHint =>
      'Başlatan başlatınca sayacın kendiliğinden başlar.';

  @override
  String get tgCofocusMine => 'Senin işin';

  @override
  String get tgCofocusNoTasks =>
      'Bugün planında bekleyen iş yok. Önce bir iş ekle.';

  @override
  String get tgCofocusStart => 'Herkesi başlat';

  @override
  String get tgCofocusJoinNow => 'Şimdi katıl';

  @override
  String get tgCofocusLeave => 'Ayrıl';

  @override
  String get tgPhaseDone => 'Tamamladı';

  @override
  String get tgPhaseBroken => 'Oturumdan çıktı';

  @override
  String get tgPhaseLeft => 'Ayrıldı';

  @override
  String get tgPhaseInvited => 'Davet edildi';

  @override
  String get tgPhaseFocus => 'Odakta';

  @override
  String get tgPhaseBreak => 'Molada';

  @override
  String get tgPhasePaused => 'Duraklattı';

  @override
  String get tgPhaseAway => 'Bağlı değil';

  @override
  String get tgPhaseLobby => 'Lobide';

  @override
  String get tgSpeaking => 'konuşuyor';

  @override
  String tgMutePerson(String name) {
    return '$name sesini kapat';
  }

  @override
  String tgUnmutePerson(String name) {
    return '$name sesini aç';
  }

  @override
  String get tgVoiceNoRecording =>
      'Ses kaydedilmez. Birini sessize almak yalnız senin duymanı etkiler.';

  @override
  String get tgVoiceConnect => 'Sese bağlan';

  @override
  String get tgVoiceErrPermission =>
      'Mikrofon izni gerekli. Ayarlardan izin verebilirsin.';

  @override
  String get tgVoiceErrUnavailable => 'Sesli sohbet şu an kullanılamıyor.';

  @override
  String get tgMicOn => 'Mikrofonu aç';

  @override
  String get tgMicOff => 'Mikrofonu kapat';

  @override
  String tgNoticeBroken(String name) {
    return '$name oturumdan çıktı. Sen devam edebilirsin.';
  }

  @override
  String tgNoticeCompleted(String name) {
    return '$name oturumunu tamamladı.';
  }

  @override
  String tgNoticeLeft(String name) {
    return '$name ayrıldı.';
  }

  @override
  String get tgNoticeMessagesTitle => 'NöroPlan';

  @override
  String get tgNoticeMessagesChannel => 'Mesajlar';

  @override
  String tgNoticeMessagesBody(int count) {
    return '$count yeni mesaj';
  }

  @override
  String tgPickMax(int n) {
    return 'En çok $n kişi seçebilirsin.';
  }

  @override
  String get tgCofocusChooseFirst => 'Başlamak için önce işini seç.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingTheme => 'Tema';

  @override
  String get settingSleepGoal => 'Uyku hedefi';

  @override
  String get secData => 'Veri ve kaynaklar';

  @override
  String get exportTitle => 'Verilerimi dışa aktar';

  @override
  String get exportSubtitle =>
      'Bütün verilerin tek bir JSON dosyası olarak; internet gerekmez.';

  @override
  String exportError(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Dosyayı hazırlayamadık, bir daha deneyelim.',
      'young': 'Dosya hazırlanamadı, tekrar dene!',
      'coder': 'Dışa aktarma başarısız. Tekrar dene.',
      'calm': 'Dosya hazırlanamadı. Biraz sonra tekrar deneyebilirsin.',
      'other': 'Dosya hazırlanamadı. Tekrar dene.',
    });
    return '$_temp0';
  }

  @override
  String get sourcesTitle => 'Bilimsel kaynaklar';

  @override
  String get sourcesSubtitle =>
      'Uygulamadaki bilimsel ifadelerin dayandığı çalışmalar';

  @override
  String get sourcesIntro =>
      'Uygulamadaki her bilimsel ifade bu listedeki hakemli bir kaynağa dayanır. Kanıt düzeyleri bölge sayfalarında yazar.';

  @override
  String get sourcesCopy => 'Bağlantıyı kopyala';

  @override
  String get themeSerious => 'Ciddi';

  @override
  String get themeSeriousBody => 'Sakin otorite, önce okunabilirlik';

  @override
  String get themePlayful => 'Eğlenceli';

  @override
  String get themePlayfulBody => 'Yuvarlak hatlar, sıcak renkler';

  @override
  String get themeYoung => 'Genç';

  @override
  String get themeYoungBody => 'Enerjik ve rahat okunur';

  @override
  String get themeCoder => 'Kodcu';

  @override
  String get themeCoderBody => 'Terminal hissi; sayılar eş aralıklı';

  @override
  String get themeCalm => 'Sakin';

  @override
  String get themeCalmBody => 'Düşük doygunluk, akşam için';

  @override
  String get themeHighContrast => 'Yüksek kontrast';

  @override
  String get themeHighContrastBody => 'En yüksek kontrast, kalın çerçeveler';

  @override
  String get themeMinimal => 'Minimal';

  @override
  String get themeMinimalBody => 'Gri yüzeyler, tek vurgu rengi';

  @override
  String get themePaper => 'Kâğıt';

  @override
  String get themePaperBody =>
      'Kâğıt ve mürekkep, geçişsiz; uzun okuma ve ders için';

  @override
  String get themeNature => 'Doğa';

  @override
  String get themeNatureBody => 'Topraksı sıcak renkler, yumuşak hatlar';

  @override
  String get themeNight => 'Gece';

  @override
  String get themeNightBody =>
      'Gerçek siyah zemin, az ışık; gece ve OLED ekran için';

  @override
  String get themeScreenTitle => 'Görünüm ve tema';

  @override
  String get themePreviewBody => 'Sıradaki iş 15 dk sonra · 25 dk odak';

  @override
  String themeRowValue(String theme, String mode) {
    return '$theme · $mode';
  }

  @override
  String get featureOffTitle => 'Bu bölüm şu an kapalı';

  @override
  String get featureOffBody =>
      'Bakım ya da düzenleme için geçici olarak kapattık. Verilerin yerinde; bölüm açılınca kaldığın yerden devam edersin.';

  @override
  String get settingCrashReports => 'Çökme raporları gönder';

  @override
  String get settingCrashReportsBody =>
      'Uygulama çökerse kimliksiz hata ayrıntısı Firebase Crashlytics\'e gider. Planların, notların ve adın gitmez.';

  @override
  String get pfAnalyses => 'Analizler';

  @override
  String get pfWeekFocus => 'Bu hafta odak';

  @override
  String pfLastWeek(String time) {
    return 'Geçen hafta $time';
  }

  @override
  String get pfAdherence => 'Bu hafta plana uyum';

  @override
  String get pfNoPlanYet => 'Henüz planlı iş yok';

  @override
  String get pfStreak => 'Seri';

  @override
  String pfLongest(int n) {
    return 'En uzun: $n gün';
  }

  @override
  String get pfStrongest => 'En güçlü bölge';

  @override
  String get pfStrongestEmpty => 'İlk odak oturumunla başlar';

  @override
  String get stQTime => 'Zamanım nereye gidiyor?';

  @override
  String get stQAdherence => 'Plana ne kadar uyuyorum?';

  @override
  String get stQBestHours => 'Ne zaman en iyi odaklanıyorum?';

  @override
  String get stQConsistency => 'Tutarlı mıyım?';

  @override
  String get stQQuality => 'Odak kalitem nasıl değişiyor?';

  @override
  String get stQInterruptions => 'Ne beni bölüyor?';

  @override
  String get stQModes => 'Pomodoro mu derin çalışma mı bana daha iyi geliyor?';

  @override
  String get stQBrain => 'Beynim nasıl gelişiyor?';

  @override
  String get stQProjects => 'Projelerim yetişecek mi?';

  @override
  String get stQSleep => 'Uykum yeterli mi?';

  @override
  String get stQBalance => 'Dengeli miyim?';

  @override
  String get stQWeekly => 'Haftalık rapor';

  @override
  String get stPeriodWeek => 'Hafta';

  @override
  String get stPeriodMonth => 'Ay';

  @override
  String get stPeriodQuarter => '3 ay';

  @override
  String get stPeriodYear => 'Yıl';

  @override
  String get stPeriodAll => 'Tümü';

  @override
  String get stShowList => 'Liste olarak göster';

  @override
  String get stLoading => 'Yükleniyor';

  @override
  String stEmptyFocus(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Burası henüz boş. İlk odak oturumunu başlat, grafikler renklenmeye başlasın.',
      'young': 'Henüz veri yok. Bir odak oturumu başlat, burası dolsun!',
      'coder': 'Veri kümesi boş. İlk odak oturumu ilk satırı yazar.',
      'calm': 'Henüz veri yok. İlk odak oturumundan sonra burası yavaşça dolmaya başlar.',
      'other':
          'Henüz veri yok. İlk odak oturumunu başlat, burası dolmaya başlar.',
    });
    return '$_temp0';
  }

  @override
  String stEmptyFocusAction(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Haydi, ilk odak oturumu',
      'young': 'Odak oturumu başlat',
      'coder': 'Odak oturumu başlat',
      'calm': 'İlk odak oturumunu başlat',
      'other': 'İlk odak oturumunu başlat',
    });
    return '$_temp0';
  }

  @override
  String stEmptyRated(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Puan verdiğin oturum yok. Oturum bitince odak ve yorgunluğunu puanla, burası şenlensin.',
      'young': 'Puanlı oturum yok. Oturum sonunda puan ver, burada görünsün.',
      'coder': 'Puanlı kayıt yok. Oturum sonunda odak ve yorgunluk puanı gir.',
      'calm': 'Henüz puan verdiğin bir oturum yok. Oturum bitince odak ve yorgunluğunu puanladığında burada görünür.',
      'other': 'Henüz puan verdiğin bir odak oturumu yok. Oturum bitince odak ve yorgunluk puanını verdiğinde burada görünür.',
    });
    return '$_temp0';
  }

  @override
  String stEmptyPlan(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Bu dönemde planlı iş yok. Bir rutin ekle, uyumu ertesi gün ölçmeye başlarız.',
      'young':
          'Bu dönemde plan yok. Rutin ekle, uyum yarından itibaren ölçülsün.',
      'coder': 'Bu aralıkta planlı kayıt yok. Uyum ertesi günden itibaren hesaplanır.',
      'calm': 'Bu dönemde planlanmış iş yok. Bir rutin eklediğinde uyum ertesi günden itibaren ölçülür.',
      'other': 'Bu dönemde planlanmış iş yok. Bir rutin ya da iş ekle; uyum ertesi günden itibaren ölçülür.',
    });
    return '$_temp0';
  }

  @override
  String get stEmptyPlanAction => 'İş ekle';

  @override
  String stEmptyProjects(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Proje yok. Son tarihli bir proje ekle, kalan işi birlikte izleyelim.',
      'young': 'Henüz proje yok. Bir proje ekle, kalan işi takip et.',
      'coder': 'Proje tablosu boş. Toplam süre ve son tarihle bir proje ekle.',
      'calm': 'Henüz proje yok. Son tarihi ve toplam süresi olan bir proje eklediğinde kalan işi burada izlersin.',
      'other': 'Henüz proje yok. Son tarihi ve toplam süresi olan bir proje ekle, kalan işi burada izle.',
    });
    return '$_temp0';
  }

  @override
  String get stEmptyProjectsAction => 'Proje ekle';

  @override
  String stEmptySleep(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful':
          'Uyku pencereni henüz söylemedin. Ayarla, uykunu burada görelim.',
      'young': 'Uyku pencereni ayarla, uykun burada görünsün.',
      'coder': 'Uyku penceresi tanımsız. Ayarlardan tanımla.',
      'calm': 'Uyku pencereni henüz ayarlamadın. Ayarladığında planlanan uykun burada görünür.',
      'other': 'Uyku pencereni henüz ayarlamadın. Ayarladığında planlanan uykun burada görünür.',
    });
    return '$_temp0';
  }

  @override
  String get stEmptySleepAction => 'Uyku penceresini ayarla';

  @override
  String stEmptyWeekly(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful':
          'Bu iki haftada odak oturumu yok. İlk oturumdan sonra raporun hazır.',
      'young': 'İki haftadır oturum yok. İlk oturumdan sonra rapor hazır!',
      'coder': 'Son iki haftada kayıt yok; rapor üretilemedi.',
      'calm': 'Bu hafta ve geçen hafta odak oturumu yok. İlk oturumdan sonra rapor hazır olur.',
      'other': 'Bu hafta ve geçen hafta odak oturumu yok. İlk oturumdan sonra rapor hazır olur.',
    });
    return '$_temp0';
  }

  @override
  String get stNoSessionsHere => 'Burada odak oturumu yok.';

  @override
  String stMoreSessions(int n) {
    return 've $n oturum daha';
  }

  @override
  String get stFreeSession => 'Serbest odak';

  @override
  String get stBroken => 'bozuldu';

  @override
  String stFocusScoreShort(int n) {
    return 'odak $n/5';
  }

  @override
  String stPercent(int n) {
    return '%$n';
  }

  @override
  String stDays(int n) {
    return '$n gün';
  }

  @override
  String stNeurons(int n) {
    return '$n nöron';
  }

  @override
  String stNeuronsGained(int n) {
    return '+$n nöron';
  }

  @override
  String stPoints(int n) {
    return '$n puan';
  }

  @override
  String get stNoCategory => 'Kategorisiz';

  @override
  String get stUncategorized => 'Alt kategorisiz';

  @override
  String get stDirectly => 'Doğrudan bu kategori';

  @override
  String get stUpLevel => 'Bir üst düzey';

  @override
  String get stNone => 'yok';

  @override
  String stTimeInsight(String name, String time, int pct) {
    return 'En çok zamanı $name alanına ayırdın: $time (%$pct).';
  }

  @override
  String stTimeTotal(String time) {
    return 'Toplam odak: $time. Bozulan oturumlardaki odak süresi de sayılır.';
  }

  @override
  String get stPlanned => 'Planlanan';

  @override
  String get stDone => 'Yapılan';

  @override
  String get stAdherence => 'Plana uyum';

  @override
  String stDoneOf(int done, int planned) {
    return '$done / $planned iş';
  }

  @override
  String stAdherenceInsight(int done, int planned, int pct) {
    return 'Planladığın $planned işin $done tanesini yaptın (%$pct).';
  }

  @override
  String get stDailyAdherence => 'Günlük uyum';

  @override
  String stBestInsight(String from, String to, String score) {
    return 'En iyi odak saatin $from–$to (ortalama odak puanı $score).';
  }

  @override
  String get stBestNeedMore =>
      'En iyi saatini bulmak için aynı saat dilimlerinde en az 3 puanlı oturum gerekiyor.';

  @override
  String get stHeatCaption =>
      'Her hücre o gün ve saatte başlayan oturumların ortalama odak puanı (1–5). Gri: oturum yok.';

  @override
  String stScoreCount(String score, int n) {
    return '$score · $n oturum';
  }

  @override
  String get stNoRating => 'Puan yok';

  @override
  String stStreakInsight(int current, int longest) {
    return 'Güncel serin $current gün, en uzun serin $longest gün.';
  }

  @override
  String get stStreakCurrent => 'Güncel seri';

  @override
  String get stStreakLongest => 'En uzun seri';

  @override
  String stCalendarCaption(int n) {
    return 'Son bir yılda $n gün en az bir odak oturumu tamamladın.';
  }

  @override
  String get stLess => 'Az';

  @override
  String get stMore => 'Çok';

  @override
  String get stFocusScore => 'Odak puanı';

  @override
  String get stFatigueScore => 'Yorgunluk puanı';

  @override
  String stFocusFatigue(String focus, String fatigue) {
    return 'Odak $focus · Yorgunluk $fatigue';
  }

  @override
  String stQualityUp(String d) {
    return 'Odak puanın dönemin ikinci yarısında $d puan yükseldi.';
  }

  @override
  String stQualityDown(String d) {
    return 'Odak puanın dönemin ikinci yarısında $d puan düştü.';
  }

  @override
  String get stQualityStable => 'Odak puanın bu dönemde yaklaşık aynı kaldı.';

  @override
  String get stQualityNeedMore =>
      'Eğilim için en az iki farklı zamanda puanlı oturum gerekiyor.';

  @override
  String get stQualityCaption =>
      'Puanlar oturum sonunda senin verdiğin değerlerdir (1–5).';

  @override
  String get stInterruptions => 'Kesinti';

  @override
  String get stPerSession => 'Oturum başına';

  @override
  String get stByReason => 'Sebebe göre';

  @override
  String get stByHour => 'Günün saatine göre';

  @override
  String stInterruptInsight(String reason, String hour, int n) {
    return 'Bu dönemde $n kesinti oldu; en sık sebep: $reason, en çok $hour civarında.';
  }

  @override
  String stNoInterruptions(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Bu dönemde hiç bölünmedin, tertemiz!',
      'young': 'Bu dönemde hiç kesinti yok!',
      'coder': 'Kesinti sayısı: 0.',
      'calm': 'Bu dönemde odak oturumlarında hiç kesinti olmadı.',
      'other': 'Bu dönemde odak oturumlarında hiç kesinti olmadı.',
    });
    return '$_temp0';
  }

  @override
  String get stReasonAppLeft => 'Uygulamadan çıkış';

  @override
  String get stReasonShade => 'Bildirim paneli';

  @override
  String get stReasonScreenOff => 'Ekran kapandı';

  @override
  String get stReasonCall => 'Telefon araması';

  @override
  String get stReasonAlarm => 'Alarm';

  @override
  String get stReasonOther => 'Diğer';

  @override
  String stModesNeedMore(int pomodoro, int deep) {
    return 'Karşılaştırma için Pomodoro\'dan $pomodoro, derin çalışmadan $deep oturum daha gerekiyor.';
  }

  @override
  String stModeProgress(String mode, int n) {
    return '$mode: $n / 5 oturum';
  }

  @override
  String get stModesHow =>
      'Odak oturumunu başlatırken modu seç; her iki moddan en az 5 oturum olunca kendi verinle karşılaştırırız.';

  @override
  String stModesPomodoroHigher(String a, String b) {
    return 'Senin verinde Pomodoro\'da odak puanın daha yüksek ($a – $b).';
  }

  @override
  String stModesDeepHigher(String a, String b) {
    return 'Senin verinde derin çalışmada odak puanın daha yüksek ($a – $b).';
  }

  @override
  String get stModesClose =>
      'Senin verinde iki modda odak puanın birbirine yakın.';

  @override
  String get stModesScience =>
      'Araştırmalarda iki yöntemin birbirinden genel olarak daha iyi olduğuna dair tutarlı bir kanıt yok; bu kıyas yalnız senin verindir.';

  @override
  String get stCompletion => 'Tamamlanma oranı';

  @override
  String get stAvgLength => 'Ortalama süre';

  @override
  String get stSessions => 'Oturum';

  @override
  String stModeSessions(String mode) {
    return '$mode oturumları';
  }

  @override
  String stBrainInsight(String region, int n) {
    return 'Beyin haritanda bu dönemde en çok $region bölgesine nöron eklendi ($n).';
  }

  @override
  String get stBrainNoGrowth => 'Bu dönemde beyin haritana nöron eklenmedi.';

  @override
  String stBrainCaption(int n) {
    return 'Çizgiler en çok nöron eklenen üç bölgenin toplamı. Bu dönemde bağlantı gücü: +$n.';
  }

  @override
  String get stFadingTitle => 'Sönen bölgeler';

  @override
  String get stFadingNone => 'Şu an sönen bölge yok.';

  @override
  String get stFadingBody =>
      'Bu bölgelerle ilişkili etkinliklere bir süredir zaman ayrılmadı. Nöronlar silinmez; yeniden çalışınca canlanır.';

  @override
  String stBrightness(int n) {
    return 'Parlaklık %$n';
  }

  @override
  String get stBrainMetaphor =>
      'Beyin haritası bir metafordur, beyninin ölçümü değildir.';

  @override
  String get stOpenProject => 'Projeyi aç';

  @override
  String get stProjectNoTotal =>
      'Toplam süre girilmemiş; kalan işi hesaplamak için projeye toplam süre ekle.';

  @override
  String get stRemaining => 'Kalan';

  @override
  String stRemainingOf(String left, String total) {
    return 'Kalan $left / $total';
  }

  @override
  String stProjectDone(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Proje tamam! Eline sağlık.',
      'young': 'Proje bitti, süper!',
      'coder': 'Proje: tamamlandı (exit 0).',
      'calm': 'Proje tamamlandı.',
      'other': 'Proje tamamlandı.',
    });
    return '$_temp0';
  }

  @override
  String get stProjectNoForecast =>
      'Tahmin için yakın zamanda çalışma ya da planlı parça yok.';

  @override
  String stProjectFinishPlan(String date) {
    return 'Plana göre tahmini bitiş: $date';
  }

  @override
  String stProjectFinishPace(String date) {
    return 'Son 14 günün temposuyla tahmini bitiş: $date';
  }

  @override
  String stProjectOnTime(String date) {
    return 'son tarih $date, yetişiyor';
  }

  @override
  String stProjectLate(String date) {
    return 'son tarih $date, bu tempoyla yetişmiyor';
  }

  @override
  String get stSleepPlanned => 'Planlanan uyku';

  @override
  String stSleepInsight(String avg, String diff) {
    return 'Planlanan uykun ortalama $avg; $diff.';
  }

  @override
  String get stSleepOnGoal => 'hedefinle aynı';

  @override
  String stSleepAbove(String d) {
    return 'hedefinden $d fazla';
  }

  @override
  String stSleepBelow(String d) {
    return 'hedefinden $d az';
  }

  @override
  String get stSleepNotice =>
      'Planlanan uykun 7 saatin altında. İstersen uyku pencereni gözden geçirebilirsin.';

  @override
  String stSleepGoalLine(String goal) {
    return 'Yatay çizgi uyku hedefin: $goal. Değerler planlanan penceredir, ölçülen uyku değil.';
  }

  @override
  String stBalanceAll(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Her alana biraz zaman ayırdın, rengârenk bir dönem!',
      'young': 'Her alana zaman ayırdın, harika denge!',
      'coder': 'Bütün kökler > 0 dk.',
      'calm': 'Bu dönemde bütün alanlara zaman ayırdın.',
      'other': 'Bu dönemde bütün alanlara zaman ayırdın.',
    });
    return '$_temp0';
  }

  @override
  String stBalanceNeglected(int n, String names) {
    return 'Bu dönemde $n alana odak zamanı ayrılmadı: $names.';
  }

  @override
  String get stBalanceCaption =>
      'Odak oturumlarının kök kategorilere göre dağılımı. Dinlenme ve Uyku odakla ölçülmediği için ihmal sayılmaz.';

  @override
  String get stShareImage => 'Görsel olarak paylaş';

  @override
  String stShareError(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Görseli hazırlayamadık, bir daha deneyelim.',
      'young': 'Görsel olmadı, tekrar dene!',
      'coder': 'Görsel üretilemedi. Tekrar dene.',
      'calm': 'Görsel hazırlanamadı. Biraz sonra tekrar deneyebilirsin.',
      'other': 'Görsel hazırlanamadı. Tekrar dene.',
    });
    return '$_temp0';
  }

  @override
  String get stWeekFocus => 'Odak süresi';

  @override
  String get stWeekSessions => 'Tamamlanan oturum';

  @override
  String get stWeekActiveDays => 'Aktif gün';

  @override
  String get stSameAsLastWeek => 'geçen haftayla aynı';

  @override
  String stUpBy(String d) {
    return 'geçen haftadan $d fazla';
  }

  @override
  String stDownBy(String d) {
    return 'geçen haftadan $d az';
  }

  @override
  String stWeekTop(String name) {
    return 'En çok zaman: $name';
  }

  @override
  String get editTitle => 'Düzenle';

  @override
  String editSaved(String title) {
    return '$title güncellendi';
  }

  @override
  String get editHistoryNote =>
      'Saat, tekrar, süre ve esneklik değişiklikleri bugünden itibaren geçerli; geçmiş günler olduğu gibi kalır.';

  @override
  String get editMissing => 'Silinmiş olabilir.';

  @override
  String get catRename => 'Yeniden adlandır';
}
