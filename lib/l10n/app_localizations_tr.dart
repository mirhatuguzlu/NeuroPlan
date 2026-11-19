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
  String get errorTitle => 'Bir şeyler ters gitti';

  @override
  String get errorBody => 'Verilerin cihazında güvende. Tekrar deneyebilirsin.';

  @override
  String get saveError => 'Kaydedilemedi. Tekrar dene.';

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
      'Açık, koyu ya da cihazınla aynı. İstediğin zaman Profil\'den değiştirebilirsin.';

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
  String get onbFirstTitle => 'İlk rutinini ekleyelim';

  @override
  String get onbFirstBody =>
      'Uygulama senin hayatın hakkında hiçbir şey varsaymaz. Hazır örnek yok; ilk işini sen eklersin.';

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
  String get todayEmptyTitle => 'Planın henüz boş';

  @override
  String get todayEmptyBody =>
      'Rutinlerini ve işlerini ekledikçe günün burada belirir; boş zamanın da hesaplanır.';

  @override
  String get todayEmptyAction => 'İlk rutinini ekle';

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
  String afterAnchor(String title) {
    return '$title sonrası';
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
  String get catEmpty => 'Henüz alt kategori ya da iş yok.';

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
  String get profileTitle => 'Profil ve ayarlar';

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
  String get focusBrokenHeading => 'Oturum bozuldu';

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
  String get focusBrokenAgain =>
      'Olabilir. Hazır olduğunda yeniden başlayabilirsin.';

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
  String get focusGainTitle => 'Bu oturumun karşılığı';

  @override
  String focusGainBody(String root, int minutes) {
    return '$root ile ilişkilendirilen bölgelere $minutes dk ayırdın.';
  }

  @override
  String get focusGainNone =>
      'Bir dakikadan kısa sürdü; beyne eklenecek süre birikmedi.';

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
  String get brainEmptyTitle => 'Henüz yanan nöron yok';

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
}
