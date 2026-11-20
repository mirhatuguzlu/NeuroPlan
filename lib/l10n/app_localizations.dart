import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'NöroPlan'**
  String get appTitle;

  /// No description provided for @navToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get navToday;

  /// No description provided for @navPlan.
  ///
  /// In tr, this message translates to:
  /// **'Plan'**
  String get navPlan;

  /// No description provided for @navBrain.
  ///
  /// In tr, this message translates to:
  /// **'Beyin'**
  String get navBrain;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @actionAdd.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get actionAdd;

  /// No description provided for @commonNext.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get commonBack;

  /// No description provided for @commonClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get commonClose;

  /// No description provided for @commonSkip.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik geç'**
  String get commonSkip;

  /// No description provided for @commonSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get commonSave;

  /// No description provided for @commonRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get commonRetry;

  /// No description provided for @commonUndo.
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get commonUndo;

  /// No description provided for @commonDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get commonDelete;

  /// No description provided for @commonLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get commonLoading;

  /// No description provided for @errorTitle.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Hoppala, bir şey takıldı} young{Ups, bir şey ters gitti} coder{Beklenmeyen bir istisna} calm{Küçük bir aksilik oldu} other{Bir şeyler ters gitti}}'**
  String errorTitle(String tone);

  /// No description provided for @errorBody.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Verilerin cihazında sapasağlam. Bir daha deneyelim mi?} young{Verilerin cihazında güvende. Bir daha dene!} coder{Veri yerelde bütün, kayıp yok. Yeniden dene.} calm{Verilerin cihazında güvende. Hazır olduğunda yeniden dene.} other{Verilerin cihazında güvende. Tekrar deneyebilirsin.}}'**
  String errorBody(String tone);

  /// No description provided for @saveError.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Kaydedemedik, bir kez daha deneyelim.} young{Kaydedilmedi, tekrar dene!} coder{Yazma başarısız. Tekrar dene.} calm{Kaydedilemedi. Biraz sonra tekrar deneyebilirsin.} other{Kaydedilemedi. Tekrar dene.}}'**
  String saveError(String tone);

  /// No description provided for @stepProgress.
  ///
  /// In tr, this message translates to:
  /// **'{current} / {total}'**
  String stepProgress(int current, int total);

  /// No description provided for @minutesShort.
  ///
  /// In tr, this message translates to:
  /// **'{n} dk'**
  String minutesShort(int n);

  /// No description provided for @hoursShort.
  ///
  /// In tr, this message translates to:
  /// **'{h} sa'**
  String hoursShort(int h);

  /// No description provided for @hoursMinutes.
  ///
  /// In tr, this message translates to:
  /// **'{h} sa {m} dk'**
  String hoursMinutes(int h, int m);

  /// No description provided for @inDuration.
  ///
  /// In tr, this message translates to:
  /// **'{duration} sonra'**
  String inDuration(String duration);

  /// No description provided for @timeRange.
  ///
  /// In tr, this message translates to:
  /// **'{from}–{to}'**
  String timeRange(String from, String to);

  /// No description provided for @langSystem.
  ///
  /// In tr, this message translates to:
  /// **'Cihazın dili'**
  String get langSystem;

  /// No description provided for @langTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @langEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @modeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Cihazla aynı'**
  String get modeSystem;

  /// No description provided for @modeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get modeLight;

  /// No description provided for @modeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get modeDark;

  /// No description provided for @onbLanguageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hangi dili kullanalım?'**
  String get onbLanguageTitle;

  /// No description provided for @onbAppearanceTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl görünsün?'**
  String get onbAppearanceTitle;

  /// No description provided for @onbAppearanceBody.
  ///
  /// In tr, this message translates to:
  /// **'Açık ya da koyu görünüm ve bir tema seç. İstediğin zaman Ayarlar\'dan değiştirebilirsin.'**
  String get onbAppearanceBody;

  /// No description provided for @onbSleepTitle.
  ///
  /// In tr, this message translates to:
  /// **'Genelde ne zaman uyursun?'**
  String get onbSleepTitle;

  /// No description provided for @onbSleepBody.
  ///
  /// In tr, this message translates to:
  /// **'Uyku pencereni koruruz: otomatik plan bu saatlere hiçbir şey koymaz.'**
  String get onbSleepBody;

  /// No description provided for @sleepBedtime.
  ///
  /// In tr, this message translates to:
  /// **'Yatış'**
  String get sleepBedtime;

  /// No description provided for @sleepWake.
  ///
  /// In tr, this message translates to:
  /// **'Kalkış'**
  String get sleepWake;

  /// No description provided for @sleepActivityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uyku'**
  String get sleepActivityTitle;

  /// No description provided for @onbLocationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Konumunu kullanalım mı?'**
  String get onbLocationTitle;

  /// No description provided for @onbLocationBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir işi gün doğumuna ya da batımına bağlamak istersen yaklaşık konumun gerekir. Konum yaklaşık 11 km hassasiyetle saklanır ve kimseyle paylaşılmaz. İstemezsen bu adımı geçebilirsin.'**
  String get onbLocationBody;

  /// No description provided for @locationAllow.
  ///
  /// In tr, this message translates to:
  /// **'Konumu kullan'**
  String get locationAllow;

  /// No description provided for @locationSaved.
  ///
  /// In tr, this message translates to:
  /// **'Konum kaydedildi'**
  String get locationSaved;

  /// No description provided for @locationDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni verilmedi. İstersen daha sonra Profil\'den açabilirsin.'**
  String get locationDenied;

  /// No description provided for @locationError.
  ///
  /// In tr, this message translates to:
  /// **'Konum alınamadı. Konum hizmetlerinin açık olduğundan emin ol.'**
  String get locationError;

  /// No description provided for @onbPrayerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Namaz vakitlerini kullanmak ister misin?'**
  String get onbPrayerTitle;

  /// No description provided for @onbPrayerBody.
  ///
  /// In tr, this message translates to:
  /// **'İstersen kendi işlerini namaz vakitlerine bağlayabilirsin, örneğin akşam namazından sonra 30 dakika. Vakitler konumundan internetsiz hesaplanır ve yalnız çapa olarak kullanılır.'**
  String get onbPrayerBody;

  /// No description provided for @prayerEnable.
  ///
  /// In tr, this message translates to:
  /// **'Namaz vakitlerini aç'**
  String get prayerEnable;

  /// No description provided for @prayerMethod.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplama yöntemi'**
  String get prayerMethod;

  /// No description provided for @prayerMadhab.
  ///
  /// In tr, this message translates to:
  /// **'İkindi hesabı'**
  String get prayerMadhab;

  /// No description provided for @madhabShafi.
  ///
  /// In tr, this message translates to:
  /// **'Standart (Şafii, Maliki, Hanbeli)'**
  String get madhabShafi;

  /// No description provided for @madhabHanafi.
  ///
  /// In tr, this message translates to:
  /// **'Hanefi'**
  String get madhabHanafi;

  /// No description provided for @prayerNeedsLocation.
  ///
  /// In tr, this message translates to:
  /// **'Vakitlerin hesaplanması için konum da gerekir.'**
  String get prayerNeedsLocation;

  /// No description provided for @prayerMethodName.
  ///
  /// In tr, this message translates to:
  /// **'{method, select, turkiye{Türkiye (Diyanet)} muslimWorldLeague{Dünya İslam Birliği} egyptian{Mısır} karachi{Karaçi} ummAlQura{Ümmü’l-Kurâ (Mekke)} dubai{Dubai} gulfRegion{Körfez bölgesi} kuwait{Kuveyt} qatar{Katar} moonsightingCommittee{Hilal Gözlem Komitesi} northAmerica{Kuzey Amerika (ISNA)} singapore{Singapur} indonesian{Endonezya} tehran{Tahran} jafari{Caferi} jordan{Ürdün} algerian{Cezayir} morocco{Fas} tunisia{Tunus} france{Fransa (UOIF)} portugal{Portekiz} russia{Rusya} other{Diğer}}'**
  String prayerMethodName(String method);

  /// No description provided for @onbCategoriesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Her şey 9 kök kategoriye bağlanır'**
  String get onbCategoriesTitle;

  /// No description provided for @onbCategoriesBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu kategoriler sabittir; altına istediğin kadar kendi kategorini açarsın. Beyin bir metafordur, ölçüm değildir.'**
  String get onbCategoriesBody;

  /// No description provided for @onbFirstTitle.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Haydi, ilk rutinini ekleyelim} young{İlk rutinini ekleyelim mi?} coder{İlk rutini tanımla} calm{İlk rutinini ekleyelim} other{İlk rutinini ekleyelim}}'**
  String onbFirstTitle(String tone);

  /// No description provided for @onbFirstBody.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Senin hayatını sen bilirsin; hazır örnek yok, ilk işi sen eklersin.} young{Hayatın sana özel: hazır örnek yok, ilk işini sen ekle.} coder{Varsayılan veri yok; şablon boş başlar. İlk kaydı sen eklersin.} calm{Uygulama senin hayatın hakkında bir şey varsaymaz. Acele etme; ilk işini sen eklersin.} other{Uygulama senin hayatın hakkında hiçbir şey varsaymaz. Hazır örnek yok; ilk işini sen eklersin.}}'**
  String onbFirstBody(String tone);

  /// No description provided for @onbFirstAction.
  ///
  /// In tr, this message translates to:
  /// **'İlk rutinimi ekle'**
  String get onbFirstAction;

  /// No description provided for @todayNow.
  ///
  /// In tr, this message translates to:
  /// **'Şu an'**
  String get todayNow;

  /// No description provided for @todayNext.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki'**
  String get todayNext;

  /// No description provided for @todayEnds.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş {time}'**
  String todayEnds(String time);

  /// No description provided for @todayEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Bugün bembeyaz bir sayfa} young{Günün şu an bomboş} coder{Bugün: 0 kayıt} calm{Bugün henüz sakin} other{Planın henüz boş}}'**
  String todayEmptyTitle(String tone);

  /// No description provided for @todayEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Rutinlerini ekledikçe gün renklenir; boş zamanını da biz buluruz.} young{Rutinlerini ekle, günün burada şekillensin; boş zamanını da hesaplarız.} coder{Rutin ve iş ekledikçe gün derlenir; boş dilimler otomatik hesaplanır.} calm{Rutinlerini ekledikçe günün burada yavaşça belirir; boş zamanın da hesaplanır.} other{Rutinlerini ve işlerini ekledikçe günün burada belirir; boş zamanın da hesaplanır.}}'**
  String todayEmptyBody(String tone);

  /// No description provided for @todayEmptyAction.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{İlk rutinini ekleyelim} young{İlk rutinini ekle} coder{İlk rutini oluştur} calm{İlk rutinini ekle} other{İlk rutinini ekle}}'**
  String todayEmptyAction(String tone);

  /// No description provided for @todayNothing.
  ///
  /// In tr, this message translates to:
  /// **'Bugün için planlanmış bir şey yok.'**
  String get todayNothing;

  /// No description provided for @todayUnplanned.
  ///
  /// In tr, this message translates to:
  /// **'Bugün plansız gün: otomatik yerleştirme yok, boş zaman hesaplanmıyor.'**
  String get todayUnplanned;

  /// No description provided for @freeSlot.
  ///
  /// In tr, this message translates to:
  /// **'Boş · {duration}'**
  String freeSlot(String duration);

  /// No description provided for @untimedSection.
  ///
  /// In tr, this message translates to:
  /// **'Bugün bir ara'**
  String get untimedSection;

  /// No description provided for @afterAnchor.
  ///
  /// In tr, this message translates to:
  /// **'{title} sonrası'**
  String afterAnchor(String title);

  /// No description provided for @overflowSection.
  ///
  /// In tr, this message translates to:
  /// **'Tampon: sığmayanlar'**
  String get overflowSection;

  /// No description provided for @overflowBody.
  ///
  /// In tr, this message translates to:
  /// **'Kısıtları içinde yer bulunamadı. Saatini değiştirebilir ya da atlayabilirsin.'**
  String get overflowBody;

  /// No description provided for @droppedLabel.
  ///
  /// In tr, this message translates to:
  /// **'İsteğe bağlı, yer olmadığı için düştü'**
  String get droppedLabel;

  /// No description provided for @conflictLabel.
  ///
  /// In tr, this message translates to:
  /// **'{title} ile çakışıyor'**
  String conflictLabel(String title);

  /// No description provided for @cycleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Göreli bağlantılarda döngü var; saat hesaplanamadı'**
  String get cycleLabel;

  /// No description provided for @missingAnchorLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bu iş için konum ya da namaz vakti ayarı gerekiyor'**
  String get missingAnchorLabel;

  /// No description provided for @focusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Odak gerektirir'**
  String get focusLabel;

  /// No description provided for @suggestedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen saat'**
  String get suggestedLabel;

  /// No description provided for @actionDone.
  ///
  /// In tr, this message translates to:
  /// **'Bitti'**
  String get actionDone;

  /// No description provided for @actionSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get actionSkip;

  /// No description provided for @actionChangeTime.
  ///
  /// In tr, this message translates to:
  /// **'Saati değiştir'**
  String get actionChangeTime;

  /// No description provided for @statusDone.
  ///
  /// In tr, this message translates to:
  /// **'Yapıldı'**
  String get statusDone;

  /// No description provided for @statusSkipped.
  ///
  /// In tr, this message translates to:
  /// **'Atlandı'**
  String get statusSkipped;

  /// No description provided for @snackDone.
  ///
  /// In tr, this message translates to:
  /// **'{title} tamamlandı'**
  String snackDone(String title);

  /// No description provided for @snackSkipped.
  ///
  /// In tr, this message translates to:
  /// **'{title} atlandı'**
  String snackSkipped(String title);

  /// No description provided for @variantPrompt.
  ///
  /// In tr, this message translates to:
  /// **'{title}: bugün hangisi?'**
  String variantPrompt(String title);

  /// No description provided for @variantAsIs.
  ///
  /// In tr, this message translates to:
  /// **'Olduğu gibi'**
  String get variantAsIs;

  /// No description provided for @proposalLabel.
  ///
  /// In tr, this message translates to:
  /// **'Öneri'**
  String get proposalLabel;

  /// No description provided for @proposalAccept.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get proposalAccept;

  /// No description provided for @proposalAccepted.
  ///
  /// In tr, this message translates to:
  /// **'Parça plana eklendi'**
  String get proposalAccepted;

  /// No description provided for @changeScopeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu değişiklik ne zaman geçerli olsun?'**
  String get changeScopeTitle;

  /// No description provided for @changeScopeOnce.
  ///
  /// In tr, this message translates to:
  /// **'Yalnız bu sefer'**
  String get changeScopeOnce;

  /// No description provided for @changeScopeAlways.
  ///
  /// In tr, this message translates to:
  /// **'Her zaman'**
  String get changeScopeAlways;

  /// No description provided for @planWeek.
  ///
  /// In tr, this message translates to:
  /// **'Hafta'**
  String get planWeek;

  /// No description provided for @planRules.
  ///
  /// In tr, this message translates to:
  /// **'Kurallar'**
  String get planRules;

  /// No description provided for @prevWeek.
  ///
  /// In tr, this message translates to:
  /// **'Önceki hafta'**
  String get prevWeek;

  /// No description provided for @nextWeek.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki hafta'**
  String get nextWeek;

  /// No description provided for @thisWeek.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta'**
  String get thisWeek;

  /// No description provided for @dayFree.
  ///
  /// In tr, this message translates to:
  /// **'Boş {duration}'**
  String dayFree(String duration);

  /// No description provided for @dayUnplanned.
  ///
  /// In tr, this message translates to:
  /// **'Plansız gün'**
  String get dayUnplanned;

  /// No description provided for @dayEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Planlı iş yok'**
  String get dayEmpty;

  /// No description provided for @rulesEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir işin yok'**
  String get rulesEmptyTitle;

  /// No description provided for @rulesEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir iş eklediğinde ne zaman olacağı burada listelenir.'**
  String get rulesEmptyBody;

  /// No description provided for @itemDeleted.
  ///
  /// In tr, this message translates to:
  /// **'{title} silindi'**
  String itemDeleted(String title);

  /// No description provided for @inboxSection.
  ///
  /// In tr, this message translates to:
  /// **'Tarihsiz işler'**
  String get inboxSection;

  /// No description provided for @projectsSection.
  ///
  /// In tr, this message translates to:
  /// **'Projeler ve görevler'**
  String get projectsSection;

  /// No description provided for @routinesSection.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlar ve tarihli işler'**
  String get routinesSection;

  /// No description provided for @recDaily.
  ///
  /// In tr, this message translates to:
  /// **'Her gün'**
  String get recDaily;

  /// No description provided for @recWeekdays.
  ///
  /// In tr, this message translates to:
  /// **'Her {days}'**
  String recWeekdays(String days);

  /// No description provided for @recEveryNDays.
  ///
  /// In tr, this message translates to:
  /// **'{n} günde bir'**
  String recEveryNDays(int n);

  /// No description provided for @recMonthDay.
  ///
  /// In tr, this message translates to:
  /// **'Her ayın {day}. günü'**
  String recMonthDay(int day);

  /// No description provided for @recMonthNth.
  ///
  /// In tr, this message translates to:
  /// **'Her ayın {n}. {weekday} günü'**
  String recMonthNth(int n, String weekday);

  /// No description provided for @recMonthLast.
  ///
  /// In tr, this message translates to:
  /// **'Her ayın son {weekday} günü'**
  String recMonthLast(String weekday);

  /// No description provided for @recCycle.
  ///
  /// In tr, this message translates to:
  /// **'{length} günlük döngüde {count} gün'**
  String recCycle(int length, int count);

  /// No description provided for @recDates.
  ///
  /// In tr, this message translates to:
  /// **'{count} seçili gün'**
  String recDates(int count);

  /// No description provided for @recPerPeriod.
  ///
  /// In tr, this message translates to:
  /// **'{unit, select, day{Günde} week{Haftada} other{Ayda}} {count} kez'**
  String recPerPeriod(String unit, int count);

  /// No description provided for @recFollow.
  ///
  /// In tr, this message translates to:
  /// **'Bağlı olduğu işle birlikte'**
  String get recFollow;

  /// No description provided for @recCustom.
  ///
  /// In tr, this message translates to:
  /// **'Özel tekrar'**
  String get recCustom;

  /// No description provided for @timeWindow.
  ///
  /// In tr, this message translates to:
  /// **'{from}–{to} arası'**
  String timeWindow(String from, String to);

  /// No description provided for @timeRelative.
  ///
  /// In tr, this message translates to:
  /// **'{title} işine bağlı'**
  String timeRelative(String title);

  /// No description provided for @timeAstro.
  ///
  /// In tr, this message translates to:
  /// **'{event} vaktine göre'**
  String timeAstro(String event);

  /// No description provided for @timeNone.
  ///
  /// In tr, this message translates to:
  /// **'Saat yok'**
  String get timeNone;

  /// No description provided for @astroEvent.
  ///
  /// In tr, this message translates to:
  /// **'{event, select, sunrise{Gün doğumu} sunset{Gün batımı} fajr{İmsak} dhuhr{Öğle} asr{İkindi} maghrib{Akşam} other{Yatsı}}'**
  String astroEvent(String event);

  /// No description provided for @wizTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni iş'**
  String get wizTitle;

  /// No description provided for @wizWhatTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ne?'**
  String get wizWhatTitle;

  /// No description provided for @wizWhatLabel.
  ///
  /// In tr, this message translates to:
  /// **'Adı'**
  String get wizWhatLabel;

  /// No description provided for @wizWhatError.
  ///
  /// In tr, this message translates to:
  /// **'Bir ad yaz'**
  String get wizWhatError;

  /// No description provided for @wizKind.
  ///
  /// In tr, this message translates to:
  /// **'Türü'**
  String get wizKind;

  /// No description provided for @kindRoutine.
  ///
  /// In tr, this message translates to:
  /// **'Rutin'**
  String get kindRoutine;

  /// No description provided for @kindOneOff.
  ///
  /// In tr, this message translates to:
  /// **'Tek seferlik'**
  String get kindOneOff;

  /// No description provided for @kindTask.
  ///
  /// In tr, this message translates to:
  /// **'Son tarihli görev'**
  String get kindTask;

  /// No description provided for @kindProject.
  ///
  /// In tr, this message translates to:
  /// **'Proje'**
  String get kindProject;

  /// No description provided for @kindFreeTime.
  ///
  /// In tr, this message translates to:
  /// **'Serbest zaman'**
  String get kindFreeTime;

  /// No description provided for @kindTravel.
  ///
  /// In tr, this message translates to:
  /// **'Yol / hazırlık'**
  String get kindTravel;

  /// No description provided for @wizCategoryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hangi kategoriye ait?'**
  String get wizCategoryTitle;

  /// No description provided for @wizCategoryNone.
  ///
  /// In tr, this message translates to:
  /// **'Kategorisiz (beyne katkı vermez)'**
  String get wizCategoryNone;

  /// No description provided for @wizNewSubcategory.
  ///
  /// In tr, this message translates to:
  /// **'Yeni alt kategori'**
  String get wizNewSubcategory;

  /// No description provided for @wizSubcategoryName.
  ///
  /// In tr, this message translates to:
  /// **'Alt kategori adı'**
  String get wizSubcategoryName;

  /// No description provided for @wizWhenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ne zaman olur?'**
  String get wizWhenTitle;

  /// No description provided for @recTypeOnce.
  ///
  /// In tr, this message translates to:
  /// **'Bir kez'**
  String get recTypeOnce;

  /// No description provided for @recTypeDaily.
  ///
  /// In tr, this message translates to:
  /// **'Her gün'**
  String get recTypeDaily;

  /// No description provided for @recTypeWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftanın belirli günleri'**
  String get recTypeWeekly;

  /// No description provided for @recTypeEveryN.
  ///
  /// In tr, this message translates to:
  /// **'Her N günde bir'**
  String get recTypeEveryN;

  /// No description provided for @recTypeMonthly.
  ///
  /// In tr, this message translates to:
  /// **'Ayda bir'**
  String get recTypeMonthly;

  /// No description provided for @recTypeCycle.
  ///
  /// In tr, this message translates to:
  /// **'Dönüşümlü (açık / kapalı günler)'**
  String get recTypeCycle;

  /// No description provided for @recTypeDates.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğim tarihlerde'**
  String get recTypeDates;

  /// No description provided for @recTypePerPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Belirli sayıda, gün vermeden'**
  String get recTypePerPeriod;

  /// No description provided for @recTypeFollow.
  ///
  /// In tr, this message translates to:
  /// **'Başka bir işle birlikte'**
  String get recTypeFollow;

  /// No description provided for @wizDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get wizDate;

  /// No description provided for @wizStartDate.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get wizStartDate;

  /// No description provided for @wizEveryNDays.
  ///
  /// In tr, this message translates to:
  /// **'Kaç günde bir'**
  String get wizEveryNDays;

  /// No description provided for @wizMonthByDay.
  ///
  /// In tr, this message translates to:
  /// **'Ayın günü'**
  String get wizMonthByDay;

  /// No description provided for @wizMonthByWeek.
  ///
  /// In tr, this message translates to:
  /// **'Ayın haftası'**
  String get wizMonthByWeek;

  /// No description provided for @wizMonthDay.
  ///
  /// In tr, this message translates to:
  /// **'Gün'**
  String get wizMonthDay;

  /// No description provided for @wizNth.
  ///
  /// In tr, this message translates to:
  /// **'Kaçıncı'**
  String get wizNth;

  /// No description provided for @nthLast.
  ///
  /// In tr, this message translates to:
  /// **'Son'**
  String get nthLast;

  /// No description provided for @wizCycleOn.
  ///
  /// In tr, this message translates to:
  /// **'Açık gün sayısı'**
  String get wizCycleOn;

  /// No description provided for @wizCycleOff.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı gün sayısı'**
  String get wizCycleOff;

  /// No description provided for @wizAddDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih ekle'**
  String get wizAddDate;

  /// No description provided for @wizPerCount.
  ///
  /// In tr, this message translates to:
  /// **'Kaç kez'**
  String get wizPerCount;

  /// No description provided for @unitDay.
  ///
  /// In tr, this message translates to:
  /// **'Günde'**
  String get unitDay;

  /// No description provided for @unitWeek.
  ///
  /// In tr, this message translates to:
  /// **'Haftada'**
  String get unitWeek;

  /// No description provided for @unitMonth.
  ///
  /// In tr, this message translates to:
  /// **'Ayda'**
  String get unitMonth;

  /// No description provided for @wizFollowNote.
  ///
  /// In tr, this message translates to:
  /// **'Bağlanacağı işi bir sonraki adımda seçeceksin. O iş olmayan günlerde bu da olmaz.'**
  String get wizFollowNote;

  /// No description provided for @wizNumberError.
  ///
  /// In tr, this message translates to:
  /// **'{min} ile {max} arasında bir sayı yaz'**
  String wizNumberError(int min, int max);

  /// No description provided for @wizPickDay.
  ///
  /// In tr, this message translates to:
  /// **'En az bir gün seç'**
  String get wizPickDay;

  /// No description provided for @wizPickDate.
  ///
  /// In tr, this message translates to:
  /// **'En az bir tarih ekle'**
  String get wizPickDate;

  /// No description provided for @wizTimeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Saati var mı?'**
  String get wizTimeTitle;

  /// No description provided for @timeTypeFixed.
  ///
  /// In tr, this message translates to:
  /// **'Sabit saat'**
  String get timeTypeFixed;

  /// No description provided for @timeTypeWindow.
  ///
  /// In tr, this message translates to:
  /// **'Bir saat aralığında'**
  String get timeTypeWindow;

  /// No description provided for @timeTypeRelative.
  ///
  /// In tr, this message translates to:
  /// **'Başka bir işe göre'**
  String get timeTypeRelative;

  /// No description provided for @timeTypeAstro.
  ///
  /// In tr, this message translates to:
  /// **'Gün doğumu ya da namaz vaktine göre'**
  String get timeTypeAstro;

  /// No description provided for @timeTypeNone.
  ///
  /// In tr, this message translates to:
  /// **'Saat yok, gün içinde bir ara'**
  String get timeTypeNone;

  /// No description provided for @wizStartTime.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get wizStartTime;

  /// No description provided for @wizWindowFrom.
  ///
  /// In tr, this message translates to:
  /// **'En erken'**
  String get wizWindowFrom;

  /// No description provided for @wizWindowTo.
  ///
  /// In tr, this message translates to:
  /// **'En geç'**
  String get wizWindowTo;

  /// No description provided for @wizRelativeTo.
  ///
  /// In tr, this message translates to:
  /// **'Hangi iş'**
  String get wizRelativeTo;

  /// No description provided for @relAfterEnd.
  ///
  /// In tr, this message translates to:
  /// **'O bitince başlasın'**
  String get relAfterEnd;

  /// No description provided for @relBeforeStart.
  ///
  /// In tr, this message translates to:
  /// **'O başlamadan önce bitsin'**
  String get relBeforeStart;

  /// No description provided for @wizOffset.
  ///
  /// In tr, this message translates to:
  /// **'Arada kaç dakika'**
  String get wizOffset;

  /// No description provided for @wizAstroEvent.
  ///
  /// In tr, this message translates to:
  /// **'Hangi vakit'**
  String get wizAstroEvent;

  /// No description provided for @astroBefore.
  ///
  /// In tr, this message translates to:
  /// **'Önce'**
  String get astroBefore;

  /// No description provided for @astroAfter.
  ///
  /// In tr, this message translates to:
  /// **'Sonra'**
  String get astroAfter;

  /// No description provided for @wizAstroNeedsLocation.
  ///
  /// In tr, this message translates to:
  /// **'Bunun için konum gerekir. Profil\'den konumu açabilirsin.'**
  String get wizAstroNeedsLocation;

  /// No description provided for @wizNoActivities.
  ///
  /// In tr, this message translates to:
  /// **'Bağlanacak başka bir işin yok.'**
  String get wizNoActivities;

  /// No description provided for @wizPickActivity.
  ///
  /// In tr, this message translates to:
  /// **'Bir iş seç'**
  String get wizPickActivity;

  /// No description provided for @wizFlex.
  ///
  /// In tr, this message translates to:
  /// **'Esneklik'**
  String get wizFlex;

  /// No description provided for @flexFixed.
  ///
  /// In tr, this message translates to:
  /// **'Kesin'**
  String get flexFixed;

  /// No description provided for @flexShiftable.
  ///
  /// In tr, this message translates to:
  /// **'Kaydırılabilir'**
  String get flexShiftable;

  /// No description provided for @flexOptional.
  ///
  /// In tr, this message translates to:
  /// **'İsteğe bağlı'**
  String get flexOptional;

  /// No description provided for @flexFixedHint.
  ///
  /// In tr, this message translates to:
  /// **'Kımıldamaz; başka kesin işle çakışırsa sana gösterilir.'**
  String get flexFixedHint;

  /// No description provided for @flexShiftableHint.
  ///
  /// In tr, this message translates to:
  /// **'Yer yoksa en yakın boşluğa taşınır.'**
  String get flexShiftableHint;

  /// No description provided for @flexOptionalHint.
  ///
  /// In tr, this message translates to:
  /// **'Yer yoksa o gün düşer.'**
  String get flexOptionalHint;

  /// No description provided for @wizDurationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ne kadar sürer?'**
  String get wizDurationTitle;

  /// No description provided for @wizMinutes.
  ///
  /// In tr, this message translates to:
  /// **'Dakika'**
  String get wizMinutes;

  /// No description provided for @wizVariantTitle.
  ///
  /// In tr, this message translates to:
  /// **'Farklı halleri olur mu?'**
  String get wizVariantTitle;

  /// No description provided for @wizVariantBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu iş bazı günler farklı geçiyorsa her hali bir varyant olarak ekle. Günün başında tek dokunuşla seçersin.'**
  String get wizVariantBody;

  /// No description provided for @wizVariantName.
  ///
  /// In tr, this message translates to:
  /// **'Varyant adı'**
  String get wizVariantName;

  /// No description provided for @wizVariantAdd.
  ///
  /// In tr, this message translates to:
  /// **'Varyant ekle'**
  String get wizVariantAdd;

  /// No description provided for @wizVariantCancels.
  ///
  /// In tr, this message translates to:
  /// **'Bu halde o gün olmasın'**
  String get wizVariantCancels;

  /// No description provided for @wizVariantDefault.
  ///
  /// In tr, this message translates to:
  /// **'Seçim yapmazsam bu geçerli olsun'**
  String get wizVariantDefault;

  /// No description provided for @wizVariantMin.
  ///
  /// In tr, this message translates to:
  /// **'En az iki varyant gerekir'**
  String get wizVariantMin;

  /// No description provided for @wizVariantRemove.
  ///
  /// In tr, this message translates to:
  /// **'Varyantı kaldır'**
  String get wizVariantRemove;

  /// No description provided for @wizFocusTitle.
  ///
  /// In tr, this message translates to:
  /// **'Odak gerektiriyor mu?'**
  String get wizFocusTitle;

  /// No description provided for @focusYes.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get focusYes;

  /// No description provided for @focusNo.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get focusNo;

  /// No description provided for @wizFocusMode.
  ///
  /// In tr, this message translates to:
  /// **'Odak modu'**
  String get wizFocusMode;

  /// No description provided for @modeFree.
  ///
  /// In tr, this message translates to:
  /// **'Serbest'**
  String get modeFree;

  /// No description provided for @modePomodoro.
  ///
  /// In tr, this message translates to:
  /// **'Pomodoro'**
  String get modePomodoro;

  /// No description provided for @modeDeep.
  ///
  /// In tr, this message translates to:
  /// **'Derin çalışma'**
  String get modeDeep;

  /// No description provided for @wizDeadlineTitle.
  ///
  /// In tr, this message translates to:
  /// **'Son tarih ne?'**
  String get wizDeadlineTitle;

  /// No description provided for @wizDeadlineNone.
  ///
  /// In tr, this message translates to:
  /// **'Son tarih yok'**
  String get wizDeadlineNone;

  /// No description provided for @wizTotalTitle.
  ///
  /// In tr, this message translates to:
  /// **'Toplam ne kadar sürer?'**
  String get wizTotalTitle;

  /// No description provided for @wizHours.
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get wizHours;

  /// No description provided for @wizChunksTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl bölünsün?'**
  String get wizChunksTitle;

  /// No description provided for @wizMinChunk.
  ///
  /// In tr, this message translates to:
  /// **'En kısa parça (dk)'**
  String get wizMinChunk;

  /// No description provided for @wizMaxChunk.
  ///
  /// In tr, this message translates to:
  /// **'En uzun parça (dk)'**
  String get wizMaxChunk;

  /// No description provided for @wizDailyCap.
  ///
  /// In tr, this message translates to:
  /// **'Günde en çok (dk)'**
  String get wizDailyCap;

  /// No description provided for @splitAuto.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik öner, ben onaylarım'**
  String get splitAuto;

  /// No description provided for @splitManual.
  ///
  /// In tr, this message translates to:
  /// **'Boş dilimlere ben yerleştiririm'**
  String get splitManual;

  /// No description provided for @wizSummaryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Özet'**
  String get wizSummaryTitle;

  /// No description provided for @wizSaved.
  ///
  /// In tr, this message translates to:
  /// **'{title} eklendi'**
  String wizSaved(String title);

  /// No description provided for @sumName.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get sumName;

  /// No description provided for @sumKind.
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get sumKind;

  /// No description provided for @sumCategory.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get sumCategory;

  /// No description provided for @sumWhen.
  ///
  /// In tr, this message translates to:
  /// **'Ne zaman'**
  String get sumWhen;

  /// No description provided for @sumTime.
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get sumTime;

  /// No description provided for @sumDuration.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get sumDuration;

  /// No description provided for @sumVariants.
  ///
  /// In tr, this message translates to:
  /// **'Varyantlar'**
  String get sumVariants;

  /// No description provided for @sumFocus.
  ///
  /// In tr, this message translates to:
  /// **'Odak'**
  String get sumFocus;

  /// No description provided for @sumDeadline.
  ///
  /// In tr, this message translates to:
  /// **'Son tarih'**
  String get sumDeadline;

  /// No description provided for @sumTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam süre'**
  String get sumTotal;

  /// No description provided for @sumSplit.
  ///
  /// In tr, this message translates to:
  /// **'Bölme'**
  String get sumSplit;

  /// No description provided for @sumNotSet.
  ///
  /// In tr, this message translates to:
  /// **'Belirtilmedi'**
  String get sumNotSet;

  /// No description provided for @brainTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler ve beyin'**
  String get brainTitle;

  /// No description provided for @brainIntro.
  ///
  /// In tr, this message translates to:
  /// **'Kök kategoriler sabittir; altına sınırsız alt kategori ve iş ekleyebilirsin. 3D beyin bir metafordur, ölçüm değildir.'**
  String get brainIntro;

  /// No description provided for @brainRegionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Beyninin neresini çalıştırır?'**
  String get brainRegionsTitle;

  /// No description provided for @evidenceLevel.
  ///
  /// In tr, this message translates to:
  /// **'{level, select, strong{Güçlü kanıt} moderate{Orta düzey kanıt} weak{Zayıf kanıt} other{Kaynak yok, yalnız ilişkilendirme}}'**
  String evidenceLevel(String level);

  /// No description provided for @evidenceSources.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: {ids}'**
  String evidenceSources(String ids);

  /// No description provided for @catAddSub.
  ///
  /// In tr, this message translates to:
  /// **'Alt kategori ekle'**
  String get catAddSub;

  /// No description provided for @catName.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get catName;

  /// No description provided for @catMove.
  ///
  /// In tr, this message translates to:
  /// **'Taşı'**
  String get catMove;

  /// No description provided for @catInUse.
  ///
  /// In tr, this message translates to:
  /// **'Önce içindeki kategorileri ve işleri taşı ya da sil.'**
  String get catInUse;

  /// No description provided for @catMoved.
  ///
  /// In tr, this message translates to:
  /// **'{name} taşındı'**
  String catMoved(String name);

  /// No description provided for @catEmpty.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Burası henüz boş, ilk alt kategoriyi ekleyebilirsin.} young{Henüz bir şey yok, hemen ekle.} coder{Düğüm boş: alt kategori ya da iş yok.} calm{Burada henüz bir şey yok.} other{Henüz alt kategori ya da iş yok.}}'**
  String catEmpty(String tone);

  /// No description provided for @catDragHint.
  ///
  /// In tr, this message translates to:
  /// **'Taşımak için satırı soldaki tutamaçtan sürükle, bir kategorinin ya da kök kategori başlığının üstüne bırak.'**
  String get catDragHint;

  /// No description provided for @moveTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nereye taşınsın?'**
  String get moveTitle;

  /// No description provided for @moveCannotIntoSelf.
  ///
  /// In tr, this message translates to:
  /// **'Bir kategori kendi altına taşınamaz.'**
  String get moveCannotIntoSelf;

  /// No description provided for @projectProgress.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get projectProgress;

  /// No description provided for @projectDoneOf.
  ///
  /// In tr, this message translates to:
  /// **'{done} / {total} yapıldı'**
  String projectDoneOf(String done, String total);

  /// No description provided for @projectRemaining.
  ///
  /// In tr, this message translates to:
  /// **'Kalan: {duration}'**
  String projectRemaining(String duration);

  /// No description provided for @projectDeadline.
  ///
  /// In tr, this message translates to:
  /// **'Son tarih: {date}'**
  String projectDeadline(String date);

  /// No description provided for @projectNoDeadline.
  ///
  /// In tr, this message translates to:
  /// **'Son tarih yok; parçaları sen yerleştirirsin.'**
  String get projectNoDeadline;

  /// No description provided for @projectNoTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam süre belirtilmedi; parçaları sen yerleştirirsin.'**
  String get projectNoTotal;

  /// No description provided for @projectModeAuto.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik'**
  String get projectModeAuto;

  /// No description provided for @projectModeManual.
  ///
  /// In tr, this message translates to:
  /// **'Elle'**
  String get projectModeManual;

  /// No description provided for @projectProposals.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen parçalar'**
  String get projectProposals;

  /// No description provided for @projectAcceptAll.
  ///
  /// In tr, this message translates to:
  /// **'Hepsini onayla'**
  String get projectAcceptAll;

  /// No description provided for @projectAccepted.
  ///
  /// In tr, this message translates to:
  /// **'{n} parça onaylandı'**
  String projectAccepted(int n);

  /// No description provided for @projectScheduled.
  ///
  /// In tr, this message translates to:
  /// **'Plandaki parçalar'**
  String get projectScheduled;

  /// No description provided for @projectNoProposals.
  ///
  /// In tr, this message translates to:
  /// **'Şu an önerilecek parça yok.'**
  String get projectNoProposals;

  /// No description provided for @projectComplete.
  ///
  /// In tr, this message translates to:
  /// **'Toplam süre tamamlandı ya da plana yerleşti.'**
  String get projectComplete;

  /// No description provided for @riskTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu tempoyla {date} tarihine {duration} eksik kalıyor.'**
  String riskTitle(String date, String duration);

  /// No description provided for @riskExtendChunk.
  ///
  /// In tr, this message translates to:
  /// **'Parçayı uzat'**
  String get riskExtendChunk;

  /// No description provided for @riskRaiseCap.
  ///
  /// In tr, this message translates to:
  /// **'Günlük sınırı artır'**
  String get riskRaiseCap;

  /// No description provided for @riskMoveDeadline.
  ///
  /// In tr, this message translates to:
  /// **'Son tarihi taşı'**
  String get riskMoveDeadline;

  /// No description provided for @riskApplied.
  ///
  /// In tr, this message translates to:
  /// **'Ayar güncellendi; plan yeniden hesaplandı.'**
  String get riskApplied;

  /// No description provided for @manualTitle.
  ///
  /// In tr, this message translates to:
  /// **'Boş dilimler'**
  String get manualTitle;

  /// No description provided for @manualHint.
  ///
  /// In tr, this message translates to:
  /// **'Parçayı tutamaçtan bir boş dilime sürükle ya da dilime dokun.'**
  String get manualHint;

  /// No description provided for @manualChunk.
  ///
  /// In tr, this message translates to:
  /// **'{duration} parça'**
  String manualChunk(String duration);

  /// No description provided for @manualPlaced.
  ///
  /// In tr, this message translates to:
  /// **'Parça yerleştirildi'**
  String get manualPlaced;

  /// No description provided for @manualNoSlots.
  ///
  /// In tr, this message translates to:
  /// **'Önümüzdeki günlerde uygun boş dilim yok.'**
  String get manualNoSlots;

  /// No description provided for @projectNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu proje bulunamadı.'**
  String get projectNotFound;

  /// No description provided for @chunkRemove.
  ///
  /// In tr, this message translates to:
  /// **'Parçayı kaldır'**
  String get chunkRemove;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @secGeneral.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get secGeneral;

  /// No description provided for @secPlan.
  ///
  /// In tr, this message translates to:
  /// **'Plan'**
  String get secPlan;

  /// No description provided for @secLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum ve vakitler'**
  String get secLocation;

  /// No description provided for @secNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get secNotifications;

  /// No description provided for @settingLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingLanguage;

  /// No description provided for @settingAppearance.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get settingAppearance;

  /// No description provided for @settingSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku penceresi'**
  String get settingSleep;

  /// No description provided for @notSet.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlanmadı'**
  String get notSet;

  /// No description provided for @settingLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get settingLocation;

  /// No description provided for @locationValue.
  ///
  /// In tr, this message translates to:
  /// **'{lat}, {lon}'**
  String locationValue(String lat, String lon);

  /// No description provided for @locationRemove.
  ///
  /// In tr, this message translates to:
  /// **'Konumu kaldır'**
  String get locationRemove;

  /// No description provided for @settingPrayer.
  ///
  /// In tr, this message translates to:
  /// **'Namaz vakitleri'**
  String get settingPrayer;

  /// No description provided for @prayerOff.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get prayerOff;

  /// No description provided for @settingMinChunk.
  ///
  /// In tr, this message translates to:
  /// **'En kısa parça'**
  String get settingMinChunk;

  /// No description provided for @settingBuffer.
  ///
  /// In tr, this message translates to:
  /// **'Parçalar arası tampon'**
  String get settingBuffer;

  /// No description provided for @settingDailyCap.
  ///
  /// In tr, this message translates to:
  /// **'Günlük azami odak'**
  String get settingDailyCap;

  /// No description provided for @engineDefault.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan ({value})'**
  String engineDefault(String value);

  /// No description provided for @noLimit.
  ///
  /// In tr, this message translates to:
  /// **'Sınır yok'**
  String get noLimit;

  /// No description provided for @settingNotify.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki iş bildirimi'**
  String get settingNotify;

  /// No description provided for @notifyLead.
  ///
  /// In tr, this message translates to:
  /// **'{n} dk önce'**
  String notifyLead(int n);

  /// No description provided for @notifyOff.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get notifyOff;

  /// No description provided for @settingExact.
  ///
  /// In tr, this message translates to:
  /// **'Tam zamanında'**
  String get settingExact;

  /// No description provided for @settingExactBody.
  ///
  /// In tr, this message translates to:
  /// **'Telefon uykudayken bile tam vaktinde gelir; sistem izni ister.'**
  String get settingExactBody;

  /// No description provided for @notifPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim izni verilmedi. Sistem ayarlarından açabilirsin.'**
  String get notifPermissionDenied;

  /// No description provided for @onbNotifyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlere izin verelim mi?'**
  String get onbNotifyTitle;

  /// No description provided for @onbNotifyBody.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki işi zamanında hatırlatırız, odak oturumunu kilit ekranında gösteririz, arkadaşın yazınca haber veririz. Bildirimde mesajın içeriği görünmez. Ayarı sonra Profil’den değiştirebilirsin.'**
  String get onbNotifyBody;

  /// No description provided for @notifyAllow.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlere izin ver'**
  String get notifyAllow;

  /// No description provided for @notifyGranted.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler açık.'**
  String get notifyGranted;

  /// No description provided for @notifyOffTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler kapalı'**
  String get notifyOffTitle;

  /// No description provided for @notifyOffBody.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar ve mesaj bildirimleri gelmez.'**
  String get notifyOffBody;

  /// No description provided for @notifyTurnOn.
  ///
  /// In tr, this message translates to:
  /// **'Aç'**
  String get notifyTurnOn;

  /// No description provided for @settingHaptics.
  ///
  /// In tr, this message translates to:
  /// **'Dokunsal geri bildirim'**
  String get settingHaptics;

  /// No description provided for @notifChannel.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki iş'**
  String get notifChannel;

  /// No description provided for @notifChannelDesc.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki işin başlamasına az kala hatırlatır.'**
  String get notifChannelDesc;

  /// No description provided for @notifBody.
  ///
  /// In tr, this message translates to:
  /// **'{time} · {when}'**
  String notifBody(String time, String when);

  /// No description provided for @widgetNext.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki: {title}'**
  String widgetNext(String title);

  /// No description provided for @widgetNone.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki iş yok'**
  String get widgetNone;

  /// No description provided for @widgetNow.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi başlıyor'**
  String get widgetNow;

  /// No description provided for @commonCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get commonCancel;

  /// No description provided for @actionFocus.
  ///
  /// In tr, this message translates to:
  /// **'Odaklan'**
  String get actionFocus;

  /// No description provided for @secFocus.
  ///
  /// In tr, this message translates to:
  /// **'Odak'**
  String get secFocus;

  /// No description provided for @focusStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get focusStart;

  /// No description provided for @focusMissingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu iş artık planda yok'**
  String get focusMissingTitle;

  /// No description provided for @focusMissingBody.
  ///
  /// In tr, this message translates to:
  /// **'Plan değişmiş olabilir. Bugün ekranından yeniden seç.'**
  String get focusMissingBody;

  /// No description provided for @focusChangeDurations.
  ///
  /// In tr, this message translates to:
  /// **'Süreleri değiştir'**
  String get focusChangeDurations;

  /// No description provided for @focusRuleHint.
  ///
  /// In tr, this message translates to:
  /// **'Başlayınca Android uygulamayı sabitlemek için onay ister; sabitliyken başka uygulamaya geçilemez. Sabitlemeden çıkıp uygulamadan ayrılırsan ya da bildirim panelini çekersen 10 saniye içinde dönmen gerekir; yoksa oturum bozulur. Ekranı kapatmak ve gelen arama sayılmaz, molada çıkmak serbest.'**
  String get focusRuleHint;

  /// No description provided for @focusSummaryFree.
  ///
  /// In tr, this message translates to:
  /// **'Süre sınırı yok; bitirdiğinde dur.'**
  String get focusSummaryFree;

  /// No description provided for @focusSummaryPomodoro.
  ///
  /// In tr, this message translates to:
  /// **'{work} dk odak, {rest} dk mola; {every} döngüde bir {long} dk uzun mola.'**
  String focusSummaryPomodoro(int work, int rest, int every, int long);

  /// No description provided for @focusSummaryDeep.
  ///
  /// In tr, this message translates to:
  /// **'Hedef {target} dk kesintisiz odak. İstersen, o ana kadarki odak süresine göre önerilen bir mola verebilirsin.'**
  String focusSummaryDeep(int target);

  /// No description provided for @focusFieldWork.
  ///
  /// In tr, this message translates to:
  /// **'Odak (dk)'**
  String get focusFieldWork;

  /// No description provided for @focusFieldBreak.
  ///
  /// In tr, this message translates to:
  /// **'Mola (dk)'**
  String get focusFieldBreak;

  /// No description provided for @focusFieldLongBreak.
  ///
  /// In tr, this message translates to:
  /// **'Uzun mola (dk)'**
  String get focusFieldLongBreak;

  /// No description provided for @focusFieldLongEvery.
  ///
  /// In tr, this message translates to:
  /// **'Uzun mola kaç döngüde bir'**
  String get focusFieldLongEvery;

  /// No description provided for @focusFieldTarget.
  ///
  /// In tr, this message translates to:
  /// **'Hedef (dk)'**
  String get focusFieldTarget;

  /// No description provided for @focusPause.
  ///
  /// In tr, this message translates to:
  /// **'Duraklat'**
  String get focusPause;

  /// No description provided for @focusResume.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get focusResume;

  /// No description provided for @focusFinish.
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get focusFinish;

  /// No description provided for @focusEndBreak.
  ///
  /// In tr, this message translates to:
  /// **'Molayı bitir'**
  String get focusEndBreak;

  /// No description provided for @focusTakeBreak.
  ///
  /// In tr, this message translates to:
  /// **'Mola ver · {minutes} dk önerilir'**
  String focusTakeBreak(int minutes);

  /// No description provided for @focusEmergency.
  ///
  /// In tr, this message translates to:
  /// **'Acil durum ({left} hakkın var)'**
  String focusEmergency(int left);

  /// No description provided for @focusEmergencyNone.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü acil durum hakların bitti'**
  String get focusEmergencyNone;

  /// No description provided for @focusEmergencyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Acil durum'**
  String get focusEmergencyTitle;

  /// No description provided for @focusEmergencyBody.
  ///
  /// In tr, this message translates to:
  /// **'Oturum cezasız duraklar ve uygulamadan çıkabilirsin. Döndüğünde Devam\'a dokun. Bundan sonra bugün kalan hakkın: {left}.'**
  String focusEmergencyBody(int left);

  /// No description provided for @focusEmergencyConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Duraklat'**
  String get focusEmergencyConfirm;

  /// No description provided for @focusPhaseCycle.
  ///
  /// In tr, this message translates to:
  /// **'Odak · {n}. döngü'**
  String focusPhaseCycle(int n);

  /// No description provided for @focusPhaseDeep.
  ///
  /// In tr, this message translates to:
  /// **'Derin çalışma · hedef {target} dk'**
  String focusPhaseDeep(int target);

  /// No description provided for @focusPhaseBreak.
  ///
  /// In tr, this message translates to:
  /// **'Mola · uygulamadan çıkabilirsin'**
  String get focusPhaseBreak;

  /// No description provided for @focusPhaseBreakOver.
  ///
  /// In tr, this message translates to:
  /// **'Mola bitti · hazır olunca devam et'**
  String get focusPhaseBreakOver;

  /// No description provided for @focusPhasePaused.
  ///
  /// In tr, this message translates to:
  /// **'Duraklatıldı · uygulamada kal'**
  String get focusPhasePaused;

  /// No description provided for @focusPhaseEmergency.
  ///
  /// In tr, this message translates to:
  /// **'Acil durum · uygulamadan çıkabilirsin'**
  String get focusPhaseEmergency;

  /// No description provided for @focusTimeLeft.
  ///
  /// In tr, this message translates to:
  /// **'Kalan {time}'**
  String focusTimeLeft(String time);

  /// No description provided for @focusTimeElapsed.
  ///
  /// In tr, this message translates to:
  /// **'Geçen {time}'**
  String focusTimeElapsed(String time);

  /// No description provided for @focusTotal.
  ///
  /// In tr, this message translates to:
  /// **'Bu oturumda {time} odak'**
  String focusTotal(String time);

  /// No description provided for @focusBackHint.
  ///
  /// In tr, this message translates to:
  /// **'Oturumu bitirmek için Bitir\'e dokun.'**
  String get focusBackHint;

  /// No description provided for @focusOverlaySeconds.
  ///
  /// In tr, this message translates to:
  /// **'{seconds} sn içinde dön'**
  String focusOverlaySeconds(int seconds);

  /// No description provided for @focusPardonTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aramadaymışsın gibi görünüyor'**
  String get focusPardonTitle;

  /// No description provided for @focusPardonBody.
  ///
  /// In tr, this message translates to:
  /// **'10 saniyeden uzun dışarıdaydın ama telefon bir arama gösteriyordu. Aramadaydıysan oturum sürer, arama süresi odak sayılmaz.'**
  String get focusPardonBody;

  /// No description provided for @focusPardonYes.
  ///
  /// In tr, this message translates to:
  /// **'Evet, aramadaydım'**
  String get focusPardonYes;

  /// No description provided for @focusPardonNo.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get focusPardonNo;

  /// No description provided for @focusOngoingChannel.
  ///
  /// In tr, this message translates to:
  /// **'Süren odak oturumu'**
  String get focusOngoingChannel;

  /// No description provided for @focusAlertChannel.
  ///
  /// In tr, this message translates to:
  /// **'Odak uyarıları'**
  String get focusAlertChannel;

  /// No description provided for @focusAlertTitle.
  ///
  /// In tr, this message translates to:
  /// **'Planı bozuyorsun'**
  String get focusAlertTitle;

  /// No description provided for @focusAlertBody.
  ///
  /// In tr, this message translates to:
  /// **'10 saniye içinde dön, yoksa oturum bozulur. Dönmek için dokun.'**
  String get focusAlertBody;

  /// No description provided for @focusBrokenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Odak bozuldu'**
  String get focusBrokenTitle;

  /// No description provided for @focusBrokenBody.
  ///
  /// In tr, this message translates to:
  /// **'10 saniye içinde dönülmedi. Hazır olduğunda yeniden başlayabilirsin.'**
  String get focusBrokenBody;

  /// No description provided for @focusBreakTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mola zamanı'**
  String get focusBreakTitle;

  /// No description provided for @focusBreakBody.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk mola. Uygulamadan çıkabilirsin.'**
  String focusBreakBody(int minutes);

  /// No description provided for @focusBreakOverTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mola bitti'**
  String get focusBreakOverTitle;

  /// No description provided for @focusBreakOverBody.
  ///
  /// In tr, this message translates to:
  /// **'Hazır olduğunda uygulamaya dönüp devam et.'**
  String get focusBreakOverBody;

  /// No description provided for @focusTargetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hedefe ulaştın'**
  String get focusTargetTitle;

  /// No description provided for @focusTargetBody.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk derin çalışma tamam. İstersen sürdür ya da bitir.'**
  String focusTargetBody(int minutes);

  /// No description provided for @focusBrokenHeading.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Bu sefer olmadı} young{Bu tur bozuldu} coder{Oturum sonlandı: bozuldu} calm{Oturum yarıda kaldı} other{Oturum bozuldu}}'**
  String focusBrokenHeading(String tone);

  /// No description provided for @focusBrokenWhat.
  ///
  /// In tr, this message translates to:
  /// **'Saat {time}: uygulamadan çıkıldı ve 10 saniye içinde dönülmedi, oturum durdu.'**
  String focusBrokenWhat(String time);

  /// No description provided for @focusBrokenBrain.
  ///
  /// In tr, this message translates to:
  /// **'Bu oturum beyne eklenmedi. {root} ile ilişkilendirilen bölgelerde {minutes} dakikalık kısım söndü; yeniden odaklandıkça yanar.'**
  String focusBrokenBrain(String root, int minutes);

  /// No description provided for @focusBrokenBrainNone.
  ///
  /// In tr, this message translates to:
  /// **'Bu oturum beyne eklenmedi; sönen bir kısım yok.'**
  String get focusBrokenBrainNone;

  /// No description provided for @focusBrokenAgain.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Olur böyle şeyler. Hazır olunca yeniden başlarız.} young{Takma kafana, hazır olunca yeniden başla.} coder{Yeniden başlatmak her zaman mümkün.} calm{Sorun değil. Hazır hissettiğinde yeniden başlayabilirsin.} other{Olabilir. Hazır olduğunda yeniden başlayabilirsin.}}'**
  String focusBrokenAgain(String tone);

  /// No description provided for @focusRestart.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden başlat'**
  String get focusRestart;

  /// No description provided for @focusBackToToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün\'e dön'**
  String get focusBackToToday;

  /// No description provided for @focusRateFocus.
  ///
  /// In tr, this message translates to:
  /// **'Ne kadar odaklanabildin?'**
  String get focusRateFocus;

  /// No description provided for @focusRateFocusLow.
  ///
  /// In tr, this message translates to:
  /// **'1 · hiç'**
  String get focusRateFocusLow;

  /// No description provided for @focusRateFocusHigh.
  ///
  /// In tr, this message translates to:
  /// **'5 · tamamen'**
  String get focusRateFocusHigh;

  /// No description provided for @focusRateFatigue.
  ///
  /// In tr, this message translates to:
  /// **'Ne kadar yorgunsun?'**
  String get focusRateFatigue;

  /// No description provided for @focusRateFatigueLow.
  ///
  /// In tr, this message translates to:
  /// **'1 · hiç'**
  String get focusRateFatigueLow;

  /// No description provided for @focusRateFatigueHigh.
  ///
  /// In tr, this message translates to:
  /// **'5 · çok'**
  String get focusRateFatigueHigh;

  /// No description provided for @focusNoteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kısa bir not'**
  String get focusNoteTitle;

  /// No description provided for @focusNoteLabel.
  ///
  /// In tr, this message translates to:
  /// **'Not (isteğe bağlı)'**
  String get focusNoteLabel;

  /// No description provided for @focusGainTitle.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Bu oturumun ödülü} young{Bu oturumdan kazancın} coder{Oturum çıktısı} calm{Bu oturumun karşılığı} other{Bu oturumun karşılığı}}'**
  String focusGainTitle(String tone);

  /// No description provided for @focusGainBody.
  ///
  /// In tr, this message translates to:
  /// **'{root} ile ilişkilendirilen bölgelere {minutes} dk ayırdın.'**
  String focusGainBody(String root, int minutes);

  /// No description provided for @focusGainNone.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Çok kısa sürdü; beyne eklenecek süre birikmedi.} young{Bir dakikadan kısaydı; bu sefer kazanç yok.} coder{Süre < 1 dk; beyne yazılacak bir şey yok.} calm{Bir dakikadan kısa sürdü; bu sefer beyne eklenecek süre birikmedi.} other{Bir dakikadan kısa sürdü; beyne eklenecek süre birikmedi.}}'**
  String focusGainNone(String tone);

  /// No description provided for @focusGainShare.
  ///
  /// In tr, this message translates to:
  /// **'Pay: %{percent}'**
  String focusGainShare(int percent);

  /// No description provided for @focusGainExplain.
  ///
  /// In tr, this message translates to:
  /// **'Çubuklar, nöron kazancının bu bölgelere nasıl dağıldığını gösterir. Dağılım, bölgelerin kanıt düzeyine göre belirlenen bir ürün kararıdır; beyninin ölçümü değildir.'**
  String get focusGainExplain;

  /// No description provided for @focusRewardPomodoro.
  ///
  /// In tr, this message translates to:
  /// **'{cycles} döngü tamamladın · seri: {streak} oturum'**
  String focusRewardPomodoro(int cycles, int streak);

  /// No description provided for @focusRewardDeep.
  ///
  /// In tr, this message translates to:
  /// **'En uzun kesintisiz odak: {longest} dk · rekorun: {record} dk'**
  String focusRewardDeep(int longest, int record);

  /// No description provided for @focusDone.
  ///
  /// In tr, this message translates to:
  /// **'Bitti'**
  String get focusDone;

  /// No description provided for @settingFocusDnd.
  ///
  /// In tr, this message translates to:
  /// **'Odakta Rahatsız Etmeyin'**
  String get settingFocusDnd;

  /// No description provided for @settingFocusDndBody.
  ///
  /// In tr, this message translates to:
  /// **'Oturum başlayınca açılır, bitince eski haline döner.'**
  String get settingFocusDndBody;

  /// No description provided for @focusDndDenied.
  ///
  /// In tr, this message translates to:
  /// **'Rahatsız Etmeyin erişimi verilmedi.'**
  String get focusDndDenied;

  /// No description provided for @settingFocusCalls.
  ///
  /// In tr, this message translates to:
  /// **'Gelen aramalar kaçış sayılmasın'**
  String get settingFocusCalls;

  /// No description provided for @settingFocusCallsBody.
  ///
  /// In tr, this message translates to:
  /// **'Telefon durumu izni ister. İzin yoksa dönüşte sorulur.'**
  String get settingFocusCallsBody;

  /// No description provided for @settingFocusCallsOn.
  ///
  /// In tr, this message translates to:
  /// **'İzin verildi. Kaldırmak için sistem ayarlarını kullan.'**
  String get settingFocusCallsOn;

  /// No description provided for @focusPhoneDenied.
  ///
  /// In tr, this message translates to:
  /// **'Telefon durumu izni verilmedi; aramadan sonra dönüşte sorulur.'**
  String get focusPhoneDenied;

  /// No description provided for @secAbout.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get secAbout;

  /// No description provided for @aboutTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get aboutTitle;

  /// No description provided for @aboutSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Lisanslar ve atıflar'**
  String get aboutSubtitle;

  /// No description provided for @aboutAppBody.
  ///
  /// In tr, this message translates to:
  /// **'NöroPlan açık kaynaklıdır ve AGPL-3.0 lisansıyla dağıtılır.'**
  String get aboutAppBody;

  /// No description provided for @aboutModelTitle.
  ///
  /// In tr, this message translates to:
  /// **'3D beyin modeli'**
  String get aboutModelTitle;

  /// No description provided for @aboutModelBody.
  ///
  /// In tr, this message translates to:
  /// **'3D beyin, BodyParts3D 4.0 çokgen verisinden sadeleştirilip bölgelere göre birleştirilerek üretildi.'**
  String get aboutModelBody;

  /// No description provided for @aboutModelCredit.
  ///
  /// In tr, this message translates to:
  /// **'BodyParts3D, © The Database Center for Life Science licensed under CC Attribution 4.0 International'**
  String get aboutModelCredit;

  /// No description provided for @aboutThreeBody.
  ///
  /// In tr, this message translates to:
  /// **'3D sahne Three.js ile çizilir (MIT lisansı). Sahne ve kütüphane uygulamanın içindedir; internet gerekmez.'**
  String get aboutThreeBody;

  /// No description provided for @aboutFontsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fontlar'**
  String get aboutFontsTitle;

  /// No description provided for @aboutFontsBody.
  ///
  /// In tr, this message translates to:
  /// **'Bütün fontlar uygulamanın içindedir ve SIL Open Font License 1.1 ile dağıtılır. Lisans metinleri aşağıdaki düğmede.'**
  String get aboutFontsBody;

  /// No description provided for @aboutLicenses.
  ///
  /// In tr, this message translates to:
  /// **'Bütün lisansları göster'**
  String get aboutLicenses;

  /// No description provided for @brainListAction.
  ///
  /// In tr, this message translates to:
  /// **'Liste görünümü'**
  String get brainListAction;

  /// No description provided for @brainResetView.
  ///
  /// In tr, this message translates to:
  /// **'Görünümü sıfırla'**
  String get brainResetView;

  /// No description provided for @brainSceneLoading.
  ///
  /// In tr, this message translates to:
  /// **'Beyin hazırlanıyor'**
  String get brainSceneLoading;

  /// No description provided for @brainSceneErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'3D beyin bu cihazda açılamadı'**
  String get brainSceneErrorTitle;

  /// No description provided for @brainSceneErrorBody.
  ///
  /// In tr, this message translates to:
  /// **'Aynı bilgiyi liste olarak görebilirsin.'**
  String get brainSceneErrorBody;

  /// No description provided for @brainEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Beyin seni bekliyor} young{Beynin ışıklarını yakmaya hazır} coder{Nöron sayısı: 0} calm{Beyin henüz sessiz} other{Henüz yanan nöron yok}}'**
  String brainEmptyTitle(String tone);

  /// No description provided for @brainEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir odak oturumunu tamamladığında, işin kategorisiyle ilişkilendirilen bölgelerde nöronlar yanar. 3D beyin bir metafordur, ölçüm değildir.'**
  String get brainEmptyBody;

  /// No description provided for @brainTimeline.
  ///
  /// In tr, this message translates to:
  /// **'Zaman çizelgesi'**
  String get brainTimeline;

  /// No description provided for @brainTimelineNow.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get brainTimelineNow;

  /// No description provided for @brainTimelineAt.
  ///
  /// In tr, this message translates to:
  /// **'{date} itibarıyla'**
  String brainTimelineAt(String date);

  /// No description provided for @brainListTitle.
  ///
  /// In tr, this message translates to:
  /// **'Beyin bölgeleri'**
  String get brainListTitle;

  /// No description provided for @brainCategoriesTile.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler'**
  String get brainCategoriesTile;

  /// No description provided for @brainCategoriesBody.
  ///
  /// In tr, this message translates to:
  /// **'Alt kategori ekle, taşı; her kökün bölgelerini gör.'**
  String get brainCategoriesBody;

  /// No description provided for @regionNeurons.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Henüz beslenmedi} other{{count} nöron · parlaklık %{brightness}}}'**
  String regionNeurons(int count, int brightness);

  /// No description provided for @regionDimmed.
  ///
  /// In tr, this message translates to:
  /// **'{count} nöron sönük; yeniden odaklandıkça yanar.'**
  String regionDimmed(int count);

  /// No description provided for @regionHemisphere.
  ///
  /// In tr, this message translates to:
  /// **'{side, select, left{Sol yarımküre} right{Sağ yarımküre} other{İki yarımküre}}'**
  String regionHemisphere(String side);

  /// No description provided for @regionInner.
  ///
  /// In tr, this message translates to:
  /// **'İç yapı'**
  String get regionInner;

  /// No description provided for @regionLastActive.
  ///
  /// In tr, this message translates to:
  /// **'Son beslendiği gün: {date}'**
  String regionLastActive(String date);

  /// No description provided for @regionMinutes30.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 günde bu bölgeyle ilişkilendirilen etkinliklere {minutes} dakika ayırdın.'**
  String regionMinutes30(int minutes);

  /// No description provided for @regionMinutes30None.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 günde bu bölgeyle ilişkilendirilen bir odak oturumu yok.'**
  String get regionMinutes30None;

  /// No description provided for @regionChartLabel.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 gün, günlük yanan nöron'**
  String get regionChartLabel;

  /// No description provided for @regionChartSummary.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün beslendi; bir günde en çok {max} nöron.'**
  String regionChartSummary(int days, int max);

  /// No description provided for @regionFedBy.
  ///
  /// In tr, this message translates to:
  /// **'Seni besleyenler (son 30 gün)'**
  String get regionFedBy;

  /// No description provided for @regionEvidence.
  ///
  /// In tr, this message translates to:
  /// **'Hangi kategoriler, hangi kanıtla'**
  String get regionEvidence;

  /// No description provided for @regionEvidenceNone.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölgeye bağlı bir kök kategori yok; beyin bütün görünsün diye çizilir.'**
  String get regionEvidenceNone;

  /// No description provided for @regionMetaphor.
  ///
  /// In tr, this message translates to:
  /// **'3D beyin bir metafordur, ölçüm değildir. Kanıt düzeyi ilgili araştırmaların gücünü anlatır; senin beynini ölçmez.'**
  String get regionMetaphor;

  /// No description provided for @regionMinutes.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk'**
  String regionMinutes(int minutes);

  /// No description provided for @navTogether.
  ///
  /// In tr, this message translates to:
  /// **'Birlikte'**
  String get navTogether;

  /// No description provided for @navBadge.
  ///
  /// In tr, this message translates to:
  /// **'{label}, {count} bekleyen'**
  String navBadge(String label, int count);

  /// No description provided for @secAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get secAccount;

  /// No description provided for @accountGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google hesabı'**
  String get accountGoogle;

  /// No description provided for @accountGuest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir'**
  String get accountGuest;

  /// No description provided for @accountGuestBody.
  ///
  /// In tr, this message translates to:
  /// **'Verilerin bu cihazda ve yedekte. Google ile bağlanınca kalıcı olur, başka cihazda da açılır.'**
  String get accountGuestBody;

  /// No description provided for @accountDeviceOnly.
  ///
  /// In tr, this message translates to:
  /// **'Yalnız bu cihazda'**
  String get accountDeviceOnly;

  /// No description provided for @accountDeviceOnlyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu kurulumda sunucu ayarı yok; her şey cihazında çalışır.'**
  String get accountDeviceOnlyBody;

  /// No description provided for @accountOffline.
  ///
  /// In tr, this message translates to:
  /// **'Şu an sunucuya bağlı değil; bağlantı gelince eşitlenir.'**
  String get accountOffline;

  /// No description provided for @accountDeleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı ve verileri sil'**
  String get accountDeleteTitle;

  /// No description provided for @accountDeleteSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Planın, odak oturumların, beynin ve sosyal verilerin kalıcı olarak silinir.'**
  String get accountDeleteSubtitle;

  /// No description provided for @accountDeleteBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz. Arkadaşlıkların, mesajların ve ortak işlerin de silinir. Hakkında yapılmış şikâyetler kimliğin olmadan moderasyon için kalır.'**
  String get accountDeleteBody;

  /// No description provided for @accountDeleteAction.
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı olarak sil'**
  String get accountDeleteAction;

  /// No description provided for @accountDeleteError.
  ///
  /// In tr, this message translates to:
  /// **'Silinemedi. İnternet bağlantını kontrol edip tekrar dene.'**
  String get accountDeleteError;

  /// No description provided for @onbAgeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Doğum yılın'**
  String get onbAgeTitle;

  /// No description provided for @onbAgeBody.
  ///
  /// In tr, this message translates to:
  /// **'Yalnız yıl tutulur. Yaşına göre seni koruyan ayarlar kurulur; 13 yaşından küçükler uygulamayı kullanamaz.'**
  String get onbAgeBody;

  /// No description provided for @onbAgeTooYoung.
  ///
  /// In tr, this message translates to:
  /// **'NöroPlan 13 yaş ve üstü içindir. Bu yıl seçiliyken devam edilemez.'**
  String get onbAgeTooYoung;

  /// No description provided for @onbAgeSaved.
  ///
  /// In tr, this message translates to:
  /// **'Doğum yılın kaydedildi: {year}. Yaş sonradan küçültülemez.'**
  String onbAgeSaved(String year);

  /// No description provided for @tgOfflineTitle.
  ///
  /// In tr, this message translates to:
  /// **'Birlikte bölümü sunucu ister'**
  String get tgOfflineTitle;

  /// No description provided for @tgOfflineBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu kurulumda sunucu ayarı yok. Plan, odak ve beyin cihazında tam çalışır.'**
  String get tgOfflineBody;

  /// No description provided for @tgGuestTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlarınla birlikte çalış'**
  String get tgGuestTitle;

  /// No description provided for @tgGuestBody.
  ///
  /// In tr, this message translates to:
  /// **'Birlikte bölümü Google hesabı ister. Bağlanınca verilerin aynı kalır. Kimse seni rastgele bulamaz; arkadaşlık yalnız davetle kurulur.'**
  String get tgGuestBody;

  /// No description provided for @tgConnectGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile bağlan'**
  String get tgConnectGoogle;

  /// No description provided for @tgConnected.
  ///
  /// In tr, this message translates to:
  /// **'Google hesabın bağlandı.'**
  String get tgConnected;

  /// No description provided for @tgConnectedSwitched.
  ///
  /// In tr, this message translates to:
  /// **'Google hesabına geçildi; bu cihazdaki verilerin o hesaba gönderiliyor.'**
  String get tgConnectedSwitched;

  /// No description provided for @tgConnectError.
  ///
  /// In tr, this message translates to:
  /// **'Google ile bağlanılamadı. Tekrar dene.'**
  String get tgConnectError;

  /// No description provided for @tgAgeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önce doğum yılın'**
  String get tgAgeTitle;

  /// No description provided for @tgAgeBody.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal özellikler 15 yaşında açılır; 18 yaşından küçüklerde en sıkı gizlilik ayarları kullanılır. Yalnız yıl tutulur.'**
  String get tgAgeBody;

  /// No description provided for @tgBirthYear.
  ///
  /// In tr, this message translates to:
  /// **'Doğum yılı'**
  String get tgBirthYear;

  /// No description provided for @tgTooYoungTitle.
  ///
  /// In tr, this message translates to:
  /// **'Birlikte bölümü 15 yaşında açılır'**
  String get tgTooYoungTitle;

  /// No description provided for @tgTooYoungBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu kural seni korumak için. Plan, odak ve beyin her yaşta tam çalışır.'**
  String get tgTooYoungBody;

  /// No description provided for @tgSuspendedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal özellikler geçici olarak kapalı'**
  String get tgSuspendedTitle;

  /// No description provided for @tgSuspendedBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir şikâyet incelendi ve sosyal özelliklerin {date} tarihine kadar kapatıldı. Plan, odak ve beyin çalışmaya devam eder.'**
  String tgSuspendedBody(String date);

  /// No description provided for @tgSetupTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşların seni nasıl görsün?'**
  String get tgSetupTitle;

  /// No description provided for @tgSetupBody.
  ///
  /// In tr, this message translates to:
  /// **'Takma adın yalnız arkadaşlarına görünür. Kullanıcı adı isteğe bağlıdır; ayarlardan açmazsan kimse seni onunla bulamaz.'**
  String get tgSetupBody;

  /// No description provided for @tgDisplayName.
  ///
  /// In tr, this message translates to:
  /// **'Takma ad'**
  String get tgDisplayName;

  /// No description provided for @tgUsernameOptional.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı adı (isteğe bağlı)'**
  String get tgUsernameOptional;

  /// No description provided for @tgUsernameHelp.
  ///
  /// In tr, this message translates to:
  /// **'3–20 karakter: küçük harf, rakam, alt çizgi. Tam adı bilen biri istek gönderebilir, ama yalnız sen bulunabilirliği açarsan.'**
  String get tgUsernameHelp;

  /// No description provided for @tgNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bir takma ad yaz.'**
  String get tgNameRequired;

  /// No description provided for @tgUsernameRule.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı adı 3–20 karakter olmalı: küçük harf, rakam ya da alt çizgi.'**
  String get tgUsernameRule;

  /// No description provided for @tgTermsBody.
  ///
  /// In tr, this message translates to:
  /// **'Devam ederek topluluk kurallarını kabul edersin: taciz, nefret söylemi, cinsel içerik, spam ve çocukları tehlikeye atan her şey yasaktır. Her ekranda şikâyet edebilir ve engelleyebilirsin; şikâyetler incelenir.'**
  String get tgTermsBody;

  /// No description provided for @tgSetupAction.
  ///
  /// In tr, this message translates to:
  /// **'Kabul et ve başla'**
  String get tgSetupAction;

  /// No description provided for @tgEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlk arkadaşını davet et'**
  String get tgEmptyTitle;

  /// No description provided for @tgEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlık yalnız davetle kurulur: kodunu ya da QR kodunu paylaş, ya da onun kodunu gir.'**
  String get tgEmptyBody;

  /// No description provided for @tgInviteFirst.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaş davet et'**
  String get tgInviteFirst;

  /// No description provided for @tgCofocusBack.
  ///
  /// In tr, this message translates to:
  /// **'Ortak odak oturumun açık.'**
  String get tgCofocusBack;

  /// No description provided for @tgOpen.
  ///
  /// In tr, this message translates to:
  /// **'Aç'**
  String get tgOpen;

  /// No description provided for @tgCofocusInvite.
  ///
  /// In tr, this message translates to:
  /// **'{name} seni ortak odağa çağırıyor.'**
  String tgCofocusInvite(String name);

  /// No description provided for @tgJoin.
  ///
  /// In tr, this message translates to:
  /// **'Katıl'**
  String get tgJoin;

  /// No description provided for @tgDecline.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get tgDecline;

  /// No description provided for @tgAccept.
  ///
  /// In tr, this message translates to:
  /// **'Kabul et'**
  String get tgAccept;

  /// No description provided for @tgPartnerAsked.
  ///
  /// In tr, this message translates to:
  /// **'{name} seni partneri olarak seçmek istiyor.'**
  String tgPartnerAsked(String name);

  /// No description provided for @tgPartnerDone.
  ///
  /// In tr, this message translates to:
  /// **'Artık partnersiniz.'**
  String get tgPartnerDone;

  /// No description provided for @tgSecTogether.
  ///
  /// In tr, this message translates to:
  /// **'Birlikte çalış'**
  String get tgSecTogether;

  /// No description provided for @tgSecPeople.
  ///
  /// In tr, this message translates to:
  /// **'Kişiler'**
  String get tgSecPeople;

  /// No description provided for @tgSecPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik'**
  String get tgSecPrivacy;

  /// No description provided for @tgPartnerPlan.
  ///
  /// In tr, this message translates to:
  /// **'Partnerin {name}: planı'**
  String tgPartnerPlan(String name);

  /// No description provided for @tgChoosePartner.
  ///
  /// In tr, this message translates to:
  /// **'Partner seç'**
  String get tgChoosePartner;

  /// No description provided for @tgChoosePartnerBody.
  ///
  /// In tr, this message translates to:
  /// **'Ortak çalışma ve plan görme için daha yakın bir bağ; aynı anda bir partner.'**
  String get tgChoosePartnerBody;

  /// No description provided for @tgCofocusNew.
  ///
  /// In tr, this message translates to:
  /// **'Ortak odak başlat'**
  String get tgCofocusNew;

  /// No description provided for @tgCofocusNewBody.
  ///
  /// In tr, this message translates to:
  /// **'Aynı anda başlayın, herkes kendi işine odaklansın.'**
  String get tgCofocusNewBody;

  /// No description provided for @tgShared.
  ///
  /// In tr, this message translates to:
  /// **'Ortak etkinlikler'**
  String get tgShared;

  /// No description provided for @tgFreeTime.
  ///
  /// In tr, this message translates to:
  /// **'Ortak boş zaman bul'**
  String get tgFreeTime;

  /// No description provided for @tgMessages.
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar'**
  String get tgMessages;

  /// No description provided for @tgFriends.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlar'**
  String get tgFriends;

  /// No description provided for @tgInvite.
  ///
  /// In tr, this message translates to:
  /// **'Davet et'**
  String get tgInvite;

  /// No description provided for @tgLeaderboard.
  ///
  /// In tr, this message translates to:
  /// **'Sıralama'**
  String get tgLeaderboard;

  /// No description provided for @tgPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik ayarları'**
  String get tgPrivacy;

  /// No description provided for @tgPrivacyBody.
  ///
  /// In tr, this message translates to:
  /// **'Kim neyi görür: plan, profil, beyin.'**
  String get tgPrivacyBody;

  /// No description provided for @tgCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get tgCancel;

  /// No description provided for @tgPartner.
  ///
  /// In tr, this message translates to:
  /// **'Partner'**
  String get tgPartner;

  /// No description provided for @tgErrRate.
  ///
  /// In tr, this message translates to:
  /// **'Biraz yavaşla; kısa bir süre sonra tekrar dene.'**
  String get tgErrRate;

  /// No description provided for @tgErrNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Sunucuya ulaşılamadı. İnternet bağlantını kontrol et.'**
  String get tgErrNetwork;

  /// No description provided for @tgErrNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bulunamadı ya da artık geçerli değil.'**
  String get tgErrNotFound;

  /// No description provided for @tgErrForbidden.
  ///
  /// In tr, this message translates to:
  /// **'Bunu yapmaya iznin yok.'**
  String get tgErrForbidden;

  /// No description provided for @tgErrNotPublished.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğin kişilerden biri takvimini henüz paylaşmadı; Birlikte bölümünü açınca paylaşılır.'**
  String get tgErrNotPublished;

  /// No description provided for @tgErrNotEligible.
  ///
  /// In tr, this message translates to:
  /// **'Sosyal özellikler bu hesapta açık değil.'**
  String get tgErrNotEligible;

  /// No description provided for @tgErrUsernameTaken.
  ///
  /// In tr, this message translates to:
  /// **'Bu kullanıcı adı alınmış.'**
  String get tgErrUsernameTaken;

  /// No description provided for @tgErrPartnerTaken.
  ///
  /// In tr, this message translates to:
  /// **'Birinizin zaten partneri var; önce o partnerlik bitmeli.'**
  String get tgErrPartnerTaken;

  /// No description provided for @tgErrAlready.
  ///
  /// In tr, this message translates to:
  /// **'Bu zaten yapılmış.'**
  String get tgErrAlready;

  /// No description provided for @tgErrInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgi geçerli değil.'**
  String get tgErrInvalid;

  /// No description provided for @tgIncoming.
  ///
  /// In tr, this message translates to:
  /// **'Gelen istekler'**
  String get tgIncoming;

  /// No description provided for @tgWantsToBeFriends.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaş olmak istiyor'**
  String get tgWantsToBeFriends;

  /// No description provided for @tgPartnerPending.
  ///
  /// In tr, this message translates to:
  /// **'Partner isteği bekliyor'**
  String get tgPartnerPending;

  /// No description provided for @tgOutgoing.
  ///
  /// In tr, this message translates to:
  /// **'Gönderdiğin istekler'**
  String get tgOutgoing;

  /// No description provided for @tgRequestSent.
  ///
  /// In tr, this message translates to:
  /// **'İstek gönderildi'**
  String get tgRequestSent;

  /// No description provided for @tgWithdraw.
  ///
  /// In tr, this message translates to:
  /// **'Geri al'**
  String get tgWithdraw;

  /// No description provided for @tgBlocked.
  ///
  /// In tr, this message translates to:
  /// **'Engellediklerin'**
  String get tgBlocked;

  /// No description provided for @tgUnblock.
  ///
  /// In tr, this message translates to:
  /// **'Engeli kaldır'**
  String get tgUnblock;

  /// No description provided for @tgUnblocked.
  ///
  /// In tr, this message translates to:
  /// **'Engel kaldırıldı. Yeniden arkadaş olmak için yeni bir davet gerekir.'**
  String get tgUnblocked;

  /// No description provided for @tgNotFriendTitle.
  ///
  /// In tr, this message translates to:
  /// **'Artık arkadaş değilsiniz'**
  String get tgNotFriendTitle;

  /// No description provided for @tgNotFriendBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu kişiyle ilgili hiçbir şey görüntülenemiyor.'**
  String get tgNotFriendBody;

  /// No description provided for @tgSendMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj gönder'**
  String get tgSendMessage;

  /// No description provided for @tgSeePlan.
  ///
  /// In tr, this message translates to:
  /// **'Planını gör'**
  String get tgSeePlan;

  /// No description provided for @tgCompareBrains.
  ///
  /// In tr, this message translates to:
  /// **'Beyinleri karşılaştır'**
  String get tgCompareBrains;

  /// No description provided for @tgEndPartner.
  ///
  /// In tr, this message translates to:
  /// **'Partnerliği bitir'**
  String get tgEndPartner;

  /// No description provided for @tgEndPartnerBody.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlığınız sürer; partnere özel görünürlük biter.'**
  String get tgEndPartnerBody;

  /// No description provided for @tgAskPartner.
  ///
  /// In tr, this message translates to:
  /// **'Partnerim olsun'**
  String get tgAskPartner;

  /// No description provided for @tgAskPartnerBody.
  ///
  /// In tr, this message translates to:
  /// **'Karşı taraf onaylayınca partner olursunuz.'**
  String get tgAskPartnerBody;

  /// No description provided for @tgAskPartnerBlocked.
  ///
  /// In tr, this message translates to:
  /// **'Önce şu anki partnerliğini bitirmelisin.'**
  String get tgAskPartnerBlocked;

  /// No description provided for @tgPartnerRequested.
  ///
  /// In tr, this message translates to:
  /// **'Partner isteği gönderildi.'**
  String get tgPartnerRequested;

  /// No description provided for @tgShowFull.
  ///
  /// In tr, this message translates to:
  /// **'Planımı bu kişiye tam göster'**
  String get tgShowFull;

  /// No description provided for @tgShowFullBody.
  ///
  /// In tr, this message translates to:
  /// **'Başlık, saat, kategori ve notlar. Bu istisna kategori kurallarının önüne geçer.'**
  String get tgShowFullBody;

  /// No description provided for @tgSafety.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get tgSafety;

  /// No description provided for @tgRemoveFriend.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlıktan çıkar'**
  String get tgRemoveFriend;

  /// No description provided for @tgRemoveFriendBody.
  ///
  /// In tr, this message translates to:
  /// **'{name} artık planını, mesajlarını ve beynini göremez. Yeniden arkadaş olmak için yeni bir davet gerekir.'**
  String tgRemoveFriendBody(String name);

  /// No description provided for @tgBlock.
  ///
  /// In tr, this message translates to:
  /// **'Engelle'**
  String get tgBlock;

  /// No description provided for @tgBlockTitle.
  ///
  /// In tr, this message translates to:
  /// **'{name} engellensin mi?'**
  String tgBlockTitle(String name);

  /// No description provided for @tgBlockBody.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlık ve partnerlik biter, sohbet ikiniz için de kapanır. Seni bulamaz, davet gönderemez ve engellendiğini görmez.'**
  String get tgBlockBody;

  /// No description provided for @tgBlocked1.
  ///
  /// In tr, this message translates to:
  /// **'Engellendi.'**
  String get tgBlocked1;

  /// No description provided for @tgReport.
  ///
  /// In tr, this message translates to:
  /// **'Şikâyet et'**
  String get tgReport;

  /// No description provided for @tgInviteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodun'**
  String get tgInviteTitle;

  /// No description provided for @tgInviteBody.
  ///
  /// In tr, this message translates to:
  /// **'Kod 7 gün geçerli ve tek kullanımlık. Yalnız güvendiğin kişiyle paylaş.'**
  String get tgInviteBody;

  /// No description provided for @tgKindFriend.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaş daveti'**
  String get tgKindFriend;

  /// No description provided for @tgKindPartner.
  ///
  /// In tr, this message translates to:
  /// **'Partner daveti'**
  String get tgKindPartner;

  /// No description provided for @tgCreateCode.
  ///
  /// In tr, this message translates to:
  /// **'Kod oluştur'**
  String get tgCreateCode;

  /// No description provided for @tgQrLabel.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodunun QR görüntüsü: {code}'**
  String tgQrLabel(String code);

  /// No description provided for @tgExpires.
  ///
  /// In tr, this message translates to:
  /// **'{date} tarihine kadar geçerli'**
  String tgExpires(String date);

  /// No description provided for @tgCopy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get tgCopy;

  /// No description provided for @tgCopied.
  ///
  /// In tr, this message translates to:
  /// **'Kopyalandı.'**
  String get tgCopied;

  /// No description provided for @tgRevoke.
  ///
  /// In tr, this message translates to:
  /// **'İptal et'**
  String get tgRevoke;

  /// No description provided for @tgHaveCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodun mu var?'**
  String get tgHaveCode;

  /// No description provided for @tgCode.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu'**
  String get tgCode;

  /// No description provided for @tgScan.
  ///
  /// In tr, this message translates to:
  /// **'QR kodu tara'**
  String get tgScan;

  /// No description provided for @tgUseCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodu kullan'**
  String get tgUseCode;

  /// No description provided for @tgCodeRule.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu 10 karakterdir.'**
  String get tgCodeRule;

  /// No description provided for @tgRedeemed.
  ///
  /// In tr, this message translates to:
  /// **'{name} ile artık arkadaşsınız.'**
  String tgRedeemed(String name);

  /// No description provided for @tgRedeemedPartner.
  ///
  /// In tr, this message translates to:
  /// **'{name} ile artık partnersiniz.'**
  String tgRedeemedPartner(String name);

  /// No description provided for @tgByUsername.
  ///
  /// In tr, this message translates to:
  /// **'Tam kullanıcı adıyla'**
  String get tgByUsername;

  /// No description provided for @tgByUsernameBody.
  ///
  /// In tr, this message translates to:
  /// **'Yalnız bulunabilirliği açık hesaplara istek gider. Arama ya da öneri yoktur.'**
  String get tgByUsernameBody;

  /// No description provided for @tgUsername.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı adı'**
  String get tgUsername;

  /// No description provided for @tgSendRequest.
  ///
  /// In tr, this message translates to:
  /// **'İstek gönder'**
  String get tgSendRequest;

  /// No description provided for @tgCameraTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kamera açılamadı'**
  String get tgCameraTitle;

  /// No description provided for @tgCameraBody.
  ///
  /// In tr, this message translates to:
  /// **'Kamera izni verilmedi ya da kamera yok. Kodu elle de yazabilirsin.'**
  String get tgCameraBody;

  /// No description provided for @tgScanHint.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşının ekranındaki QR kodu çerçeveye getir.'**
  String get tgScanHint;

  /// No description provided for @tgPlanOf.
  ///
  /// In tr, this message translates to:
  /// **'{name}: plan'**
  String tgPlanOf(String name);

  /// No description provided for @tgWeek.
  ///
  /// In tr, this message translates to:
  /// **'Hafta'**
  String get tgWeek;

  /// No description provided for @tgPlanEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşılan bir şey yok'**
  String get tgPlanEmptyTitle;

  /// No description provided for @tgPlanEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'{name} bu günlerde bir şey paylaşmıyor ya da planı boş. Neyin görüneceğine {name} karar verir.'**
  String tgPlanEmptyBody(String name);

  /// No description provided for @tgBusy.
  ///
  /// In tr, this message translates to:
  /// **'Meşgul'**
  String get tgBusy;

  /// No description provided for @tgPlanReadOnly.
  ///
  /// In tr, this message translates to:
  /// **'Salt okunur. Görünürlüğü planın sahibi seçer.'**
  String get tgPlanReadOnly;

  /// No description provided for @tgLevelFull.
  ///
  /// In tr, this message translates to:
  /// **'Tam (başlık, saat, not)'**
  String get tgLevelFull;

  /// No description provided for @tgLevelTitleTime.
  ///
  /// In tr, this message translates to:
  /// **'Başlık ve saat'**
  String get tgLevelTitleTime;

  /// No description provided for @tgLevelBusy.
  ///
  /// In tr, this message translates to:
  /// **'Sadece \"meşgul\"'**
  String get tgLevelBusy;

  /// No description provided for @tgLevelHidden.
  ///
  /// In tr, this message translates to:
  /// **'Gizli'**
  String get tgLevelHidden;

  /// No description provided for @tgLevelDefault.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan'**
  String get tgLevelDefault;

  /// No description provided for @tgLevelFullBody.
  ///
  /// In tr, this message translates to:
  /// **'Başlık, saat, kategori ve notlar görünür.'**
  String get tgLevelFullBody;

  /// No description provided for @tgLevelTitleTimeBody.
  ///
  /// In tr, this message translates to:
  /// **'Başlık ve saat görünür; not ve kategori görünmez.'**
  String get tgLevelTitleTimeBody;

  /// No description provided for @tgLevelBusyBody.
  ///
  /// In tr, this message translates to:
  /// **'Yalnız o saatte meşgul olduğun görünür.'**
  String get tgLevelBusyBody;

  /// No description provided for @tgLevelHiddenBody.
  ///
  /// In tr, this message translates to:
  /// **'Hiç görünmez.'**
  String get tgLevelHiddenBody;

  /// No description provided for @tgLevelDefaultBody.
  ///
  /// In tr, this message translates to:
  /// **'Partnere başlık ve saat, diğer arkadaşlara \"meşgul\".'**
  String get tgLevelDefaultBody;

  /// No description provided for @tgSecProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get tgSecProfile;

  /// No description provided for @tgDiscoverable.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı adımla bulunabilirim'**
  String get tgDiscoverable;

  /// No description provided for @tgDiscoverableBody.
  ///
  /// In tr, this message translates to:
  /// **'Tam olarak @{username} yazan biri istek gönderebilir.'**
  String tgDiscoverableBody(String username);

  /// No description provided for @tgDiscoverableNoUsername.
  ///
  /// In tr, this message translates to:
  /// **'Önce bir kullanıcı adı gerekir.'**
  String get tgDiscoverableNoUsername;

  /// No description provided for @tgGlobalBoard.
  ///
  /// In tr, this message translates to:
  /// **'Genel sıralamaya katıl'**
  String get tgGlobalBoard;

  /// No description provided for @tgGlobalBoardBody.
  ///
  /// In tr, this message translates to:
  /// **'Takma adınla, haftalık odak dakikası ve süreklilikle.'**
  String get tgGlobalBoardBody;

  /// No description provided for @tgGlobalBoardMinor.
  ///
  /// In tr, this message translates to:
  /// **'18 yaşından küçüklerde genel sıralama kapalıdır.'**
  String get tgGlobalBoardMinor;

  /// No description provided for @tgShareBrain.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlarım beynimi görebilsin'**
  String get tgShareBrain;

  /// No description provided for @tgShareBrainBody.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırma için; sunucu beyni oturum kayıtlarından hesaplar.'**
  String get tgShareBrainBody;

  /// No description provided for @tgSecPlanVisibility.
  ///
  /// In tr, this message translates to:
  /// **'Plan görünürlüğü'**
  String get tgSecPlanVisibility;

  /// No description provided for @tgPlanVisibilityBody.
  ///
  /// In tr, this message translates to:
  /// **'Her kategori için seç. Alt kategori kuralı yoksa üst kategoriye bakılır. Kurallar veritabanında uygulanır.'**
  String get tgPlanVisibilityBody;

  /// No description provided for @tgAllCategories.
  ///
  /// In tr, this message translates to:
  /// **'Bütün kategoriler'**
  String get tgAllCategories;

  /// No description provided for @tgVisibilityFootnote.
  ///
  /// In tr, this message translates to:
  /// **'Ortak boş zaman aramasında yalnız boş aralıklar paylaşılır; gizli işlerin de \"dolu\" sayılır ama içerikleri hiç gönderilmez.'**
  String get tgVisibilityFootnote;

  /// No description provided for @tgNoMessagesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz mesaj yok'**
  String get tgNoMessagesTitle;

  /// No description provided for @tgNoMessagesBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir arkadaşının sayfasından sohbet başlat.'**
  String get tgNoMessagesBody;

  /// No description provided for @tgNoMessagesYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz mesaj yok'**
  String get tgNoMessagesYet;

  /// No description provided for @tgMessageDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj silindi'**
  String get tgMessageDeleted;

  /// No description provided for @tgYou.
  ///
  /// In tr, this message translates to:
  /// **'Sen'**
  String get tgYou;

  /// No description provided for @tgMuted.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler kapalı'**
  String get tgMuted;

  /// No description provided for @tgReactWith.
  ///
  /// In tr, this message translates to:
  /// **'{emoji} ile tepki ver'**
  String tgReactWith(String emoji);

  /// No description provided for @tgReportMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesajı şikâyet et'**
  String get tgReportMessage;

  /// No description provided for @tgMore.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get tgMore;

  /// No description provided for @tgMute.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri kapat'**
  String get tgMute;

  /// No description provided for @tgUnmute.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri aç'**
  String get tgUnmute;

  /// No description provided for @tgChatEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'{name} ile sohbet'**
  String tgChatEmptyTitle(String name);

  /// No description provided for @tgChatEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar yalnız ikinize görünür. Uygunsuz kelimeler yıldızlanır.'**
  String get tgChatEmptyBody;

  /// No description provided for @tgMessageHint.
  ///
  /// In tr, this message translates to:
  /// **'Tepki, kopyala ya da şikâyet için dokun'**
  String get tgMessageHint;

  /// No description provided for @tgWriteMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj yaz'**
  String get tgWriteMessage;

  /// No description provided for @tgSend.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get tgSend;

  /// No description provided for @tgReasonHarassment.
  ///
  /// In tr, this message translates to:
  /// **'Taciz ya da zorbalık'**
  String get tgReasonHarassment;

  /// No description provided for @tgReasonInappropriate.
  ///
  /// In tr, this message translates to:
  /// **'Uygunsuz içerik'**
  String get tgReasonInappropriate;

  /// No description provided for @tgReasonSpam.
  ///
  /// In tr, this message translates to:
  /// **'Spam'**
  String get tgReasonSpam;

  /// No description provided for @tgReasonChildSafety.
  ///
  /// In tr, this message translates to:
  /// **'Çocuk güvenliği'**
  String get tgReasonChildSafety;

  /// No description provided for @tgReasonOther.
  ///
  /// In tr, this message translates to:
  /// **'Başka bir şey'**
  String get tgReasonOther;

  /// No description provided for @tgReportBody.
  ///
  /// In tr, this message translates to:
  /// **'Ne oldu? Şikâyetin incelenir; şikâyet ettiğin kişiye adın söylenmez. Mesaj şikâyetinde mesajın bir kopyası saklanır.'**
  String get tgReportBody;

  /// No description provided for @tgReportDetails.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama (isteğe bağlı)'**
  String get tgReportDetails;

  /// No description provided for @tgReportSend.
  ///
  /// In tr, this message translates to:
  /// **'Şikâyeti gönder'**
  String get tgReportSend;

  /// No description provided for @tgReportThanks.
  ///
  /// In tr, this message translates to:
  /// **'Şikâyetin alındı. İstersen bu kişiyi engelleyebilirsin.'**
  String get tgReportThanks;

  /// No description provided for @tgReportUrgent.
  ///
  /// In tr, this message translates to:
  /// **'Biri seni ya da başkasını hemen tehlikeye atıyorsa 112\'yi ara.'**
  String get tgReportUrgent;

  /// No description provided for @tgGlobal.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get tgGlobal;

  /// No description provided for @tgMetricFocus.
  ///
  /// In tr, this message translates to:
  /// **'Odak dakikası'**
  String get tgMetricFocus;

  /// No description provided for @tgMetricStreak.
  ///
  /// In tr, this message translates to:
  /// **'Süreklilik'**
  String get tgMetricStreak;

  /// No description provided for @tgBoardNote.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık, pazartesi sıfırlanır. Yalnız sunucuda doğrulanan oturumlar sayılır: çakışan ya da gerçek süreden uzun oturum girmez.'**
  String get tgBoardNote;

  /// No description provided for @tgGlobalNotJoined.
  ///
  /// In tr, this message translates to:
  /// **'Genel sıralamaya katılmadın.'**
  String get tgGlobalNotJoined;

  /// No description provided for @tgBoardEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta henüz tamamlanan oturum yok.'**
  String get tgBoardEmpty;

  /// No description provided for @tgDays.
  ///
  /// In tr, this message translates to:
  /// **'{n} gün'**
  String tgDays(int n);

  /// No description provided for @tgSharedNew.
  ///
  /// In tr, this message translates to:
  /// **'Ortak etkinlik öner'**
  String get tgSharedNew;

  /// No description provided for @tgSharedEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ortak etkinlik yok'**
  String get tgSharedEmptyTitle;

  /// No description provided for @tgSharedEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir etkinlik ya da proje öner; arkadaşın kabul edince ikinizin planına da düşer.'**
  String get tgSharedEmptyBody;

  /// No description provided for @tgProgress.
  ///
  /// In tr, this message translates to:
  /// **'{done} / {total}'**
  String tgProgress(String done, String total);

  /// No description provided for @tgWith.
  ///
  /// In tr, this message translates to:
  /// **'Birlikte: {names}'**
  String tgWith(String names);

  /// No description provided for @tgStatusConfirmed.
  ///
  /// In tr, this message translates to:
  /// **'Onaylandı'**
  String get tgStatusConfirmed;

  /// No description provided for @tgStatusCancelled.
  ///
  /// In tr, this message translates to:
  /// **'İptal edildi'**
  String get tgStatusCancelled;

  /// No description provided for @tgStatusProposed.
  ///
  /// In tr, this message translates to:
  /// **'Yanıt bekleniyor'**
  String get tgStatusProposed;

  /// No description provided for @tgChangeProposed.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklik önerildi: {text}'**
  String tgChangeProposed(String text);

  /// No description provided for @tgChangeWaiting.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekleyen değişiklik: {text}'**
  String tgChangeWaiting(String text);

  /// No description provided for @tgSharedAccepted.
  ///
  /// In tr, this message translates to:
  /// **'Planına eklendi.'**
  String get tgSharedAccepted;

  /// No description provided for @tgSharedCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal et'**
  String get tgSharedCancel;

  /// No description provided for @tgSharedCancelBody.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik herkesin planından kalkar.'**
  String get tgSharedCancelBody;

  /// No description provided for @tgSharedLeave.
  ///
  /// In tr, this message translates to:
  /// **'Ayrıl'**
  String get tgSharedLeave;

  /// No description provided for @tgSharedLeaveBody.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik senin planından kalkar; diğerleri için sürer.'**
  String get tgSharedLeaveBody;

  /// No description provided for @tgSuggestChange.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklik öner'**
  String get tgSuggestChange;

  /// No description provided for @tgPatchTitle.
  ///
  /// In tr, this message translates to:
  /// **'ad \"{title}\"'**
  String tgPatchTitle(String title);

  /// No description provided for @tgSharedKindTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ne planlıyorsunuz?'**
  String get tgSharedKindTitle;

  /// No description provided for @tgKindActivity.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik'**
  String get tgKindActivity;

  /// No description provided for @tgKindActivityBody.
  ///
  /// In tr, this message translates to:
  /// **'Belli bir gün ve saatte birlikte.'**
  String get tgKindActivityBody;

  /// No description provided for @tgKindProject.
  ///
  /// In tr, this message translates to:
  /// **'Proje'**
  String get tgKindProject;

  /// No description provided for @tgKindProjectBody.
  ///
  /// In tr, this message translates to:
  /// **'Toplam süre ve son tarih; ilerleme paylaşılır.'**
  String get tgKindProjectBody;

  /// No description provided for @tgSharedNameTitle.
  ///
  /// In tr, this message translates to:
  /// **'Adı ne olsun?'**
  String get tgSharedNameTitle;

  /// No description provided for @tgSharedName.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get tgSharedName;

  /// No description provided for @tgSharedNotes.
  ///
  /// In tr, this message translates to:
  /// **'Not (isteğe bağlı)'**
  String get tgSharedNotes;

  /// No description provided for @tgSharedWithTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kiminle?'**
  String get tgSharedWithTitle;

  /// No description provided for @tgSharedWhenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ne zaman?'**
  String get tgSharedWhenTitle;

  /// No description provided for @tgSharedDeadlineTitle.
  ///
  /// In tr, this message translates to:
  /// **'Son tarih ve toplam süre'**
  String get tgSharedDeadlineTitle;

  /// No description provided for @tgSharedTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam: {duration}'**
  String tgSharedTotal(String duration);

  /// No description provided for @tgFrom.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get tgFrom;

  /// No description provided for @tgTo.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş'**
  String get tgTo;

  /// No description provided for @tgEndAfterStart.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş başlangıçtan sonra olmalı.'**
  String get tgEndAfterStart;

  /// No description provided for @tgSharedRootTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hangi kök kategori?'**
  String get tgSharedRootTitle;

  /// No description provided for @tgSharedRootBody.
  ///
  /// In tr, this message translates to:
  /// **'Odak oturumların beyinde bu kategoriye göre büyür.'**
  String get tgSharedRootBody;

  /// No description provided for @tgNoCategory.
  ///
  /// In tr, this message translates to:
  /// **'Kategori yok'**
  String get tgNoCategory;

  /// No description provided for @tgSharedConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gönderilsin mi?'**
  String get tgSharedConfirmTitle;

  /// No description provided for @tgSharedConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Kabul eden herkesin planına sabit iş olarak düşer. Sonraki değişiklikler karşı tarafın onayına gider.'**
  String get tgSharedConfirmBody;

  /// No description provided for @tgSharedSend.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get tgSharedSend;

  /// No description provided for @tgSharedSent.
  ///
  /// In tr, this message translates to:
  /// **'Öneri gönderildi.'**
  String get tgSharedSent;

  /// No description provided for @tgChangeBody.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklik diğer katılımcıların onayına gider; hepsi onaylayınca uygulanır.'**
  String get tgChangeBody;

  /// No description provided for @tgSendChange.
  ///
  /// In tr, this message translates to:
  /// **'Onaya gönder'**
  String get tgSendChange;

  /// No description provided for @tgChangeSent.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklik onaya gönderildi.'**
  String get tgChangeSent;

  /// No description provided for @tgFreeTimeBody.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğin arkadaşlarla önümüzdeki 7 günde herkesin boş olduğu saatleri bulur. Kimin ne yaptığı gösterilmez.'**
  String get tgFreeTimeBody;

  /// No description provided for @tgFreeTimeLength.
  ///
  /// In tr, this message translates to:
  /// **'En az ne kadar?'**
  String get tgFreeTimeLength;

  /// No description provided for @tgFreeTimeFind.
  ///
  /// In tr, this message translates to:
  /// **'Boş zaman bul'**
  String get tgFreeTimeFind;

  /// No description provided for @tgFreeTimeNone.
  ///
  /// In tr, this message translates to:
  /// **'Herkesin boş olduğu bir aralık bulunamadı. Süreyi kısaltmayı dene.'**
  String get tgFreeTimeNone;

  /// No description provided for @tgPlanHere.
  ///
  /// In tr, this message translates to:
  /// **'Burada planla'**
  String get tgPlanHere;

  /// No description provided for @tgCompareTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sen ve {name}'**
  String tgCompareTitle(String name);

  /// No description provided for @tgCompareNote.
  ///
  /// In tr, this message translates to:
  /// **'Beyin bir metafordur, ölçüm değildir. Arkadaşının beyni sunucuda oturum kayıtlarından hesaplanır.'**
  String get tgCompareNote;

  /// No description provided for @tgLeftYou.
  ///
  /// In tr, this message translates to:
  /// **'Solda sen'**
  String get tgLeftYou;

  /// No description provided for @tgRightFriend.
  ///
  /// In tr, this message translates to:
  /// **'Sağda {name}'**
  String tgRightFriend(String name);

  /// No description provided for @tgNeurons.
  ///
  /// In tr, this message translates to:
  /// **'{n} nöron'**
  String tgNeurons(int n);

  /// No description provided for @tgCofocus.
  ///
  /// In tr, this message translates to:
  /// **'Ortak odak'**
  String get tgCofocus;

  /// No description provided for @tgCofocusIntro.
  ///
  /// In tr, this message translates to:
  /// **'Aynı anda başlarsınız; herkes kendi işini ve modunu seçer. Biri planı bozarsa diğerleri sakin bir notla görür. Birlikte tamamlanan oturum küçük bir ortak bağlantı kazandırır.'**
  String get tgCofocusIntro;

  /// No description provided for @tgCofocusWho.
  ///
  /// In tr, this message translates to:
  /// **'Kimler'**
  String get tgCofocusWho;

  /// No description provided for @tgVoice.
  ///
  /// In tr, this message translates to:
  /// **'Sesli sohbet'**
  String get tgVoice;

  /// No description provided for @tgVoiceBody.
  ///
  /// In tr, this message translates to:
  /// **'İsteğe bağlı. Mikrofon kapalı başlar, kayıt yapılmaz.'**
  String get tgVoiceBody;

  /// No description provided for @tgCofocusInviteAction.
  ///
  /// In tr, this message translates to:
  /// **'Davet et'**
  String get tgCofocusInviteAction;

  /// No description provided for @tgCofocusEnded.
  ///
  /// In tr, this message translates to:
  /// **'Bu ortak oturum bitti.'**
  String get tgCofocusEnded;

  /// No description provided for @tgCofocusLive.
  ///
  /// In tr, this message translates to:
  /// **'Oturum başladı. İşini seçip katıl.'**
  String get tgCofocusLive;

  /// No description provided for @tgCofocusHostHint.
  ///
  /// In tr, this message translates to:
  /// **'Herkes işini seçince başlat; sayaçlar aynı anda başlar.'**
  String get tgCofocusHostHint;

  /// No description provided for @tgCofocusGuestHint.
  ///
  /// In tr, this message translates to:
  /// **'Başlatan başlatınca sayacın kendiliğinden başlar.'**
  String get tgCofocusGuestHint;

  /// No description provided for @tgCofocusMine.
  ///
  /// In tr, this message translates to:
  /// **'Senin işin'**
  String get tgCofocusMine;

  /// No description provided for @tgCofocusNoTasks.
  ///
  /// In tr, this message translates to:
  /// **'Bugün planında bekleyen iş yok. Önce bir iş ekle.'**
  String get tgCofocusNoTasks;

  /// No description provided for @tgCofocusStart.
  ///
  /// In tr, this message translates to:
  /// **'Herkesi başlat'**
  String get tgCofocusStart;

  /// No description provided for @tgCofocusJoinNow.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi katıl'**
  String get tgCofocusJoinNow;

  /// No description provided for @tgCofocusLeave.
  ///
  /// In tr, this message translates to:
  /// **'Ayrıl'**
  String get tgCofocusLeave;

  /// No description provided for @tgPhaseDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamamladı'**
  String get tgPhaseDone;

  /// No description provided for @tgPhaseBroken.
  ///
  /// In tr, this message translates to:
  /// **'Oturumdan çıktı'**
  String get tgPhaseBroken;

  /// No description provided for @tgPhaseLeft.
  ///
  /// In tr, this message translates to:
  /// **'Ayrıldı'**
  String get tgPhaseLeft;

  /// No description provided for @tgPhaseInvited.
  ///
  /// In tr, this message translates to:
  /// **'Davet edildi'**
  String get tgPhaseInvited;

  /// No description provided for @tgPhaseFocus.
  ///
  /// In tr, this message translates to:
  /// **'Odakta'**
  String get tgPhaseFocus;

  /// No description provided for @tgPhaseBreak.
  ///
  /// In tr, this message translates to:
  /// **'Molada'**
  String get tgPhaseBreak;

  /// No description provided for @tgPhasePaused.
  ///
  /// In tr, this message translates to:
  /// **'Duraklattı'**
  String get tgPhasePaused;

  /// No description provided for @tgPhaseAway.
  ///
  /// In tr, this message translates to:
  /// **'Bağlı değil'**
  String get tgPhaseAway;

  /// No description provided for @tgPhaseLobby.
  ///
  /// In tr, this message translates to:
  /// **'Lobide'**
  String get tgPhaseLobby;

  /// No description provided for @tgSpeaking.
  ///
  /// In tr, this message translates to:
  /// **'konuşuyor'**
  String get tgSpeaking;

  /// No description provided for @tgMutePerson.
  ///
  /// In tr, this message translates to:
  /// **'{name} sesini kapat'**
  String tgMutePerson(String name);

  /// No description provided for @tgUnmutePerson.
  ///
  /// In tr, this message translates to:
  /// **'{name} sesini aç'**
  String tgUnmutePerson(String name);

  /// No description provided for @tgVoiceNoRecording.
  ///
  /// In tr, this message translates to:
  /// **'Ses kaydedilmez. Birini sessize almak yalnız senin duymanı etkiler.'**
  String get tgVoiceNoRecording;

  /// No description provided for @tgVoiceConnect.
  ///
  /// In tr, this message translates to:
  /// **'Sese bağlan'**
  String get tgVoiceConnect;

  /// No description provided for @tgVoiceErrPermission.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon izni gerekli. Ayarlardan izin verebilirsin.'**
  String get tgVoiceErrPermission;

  /// No description provided for @tgVoiceErrUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Sesli sohbet şu an kullanılamıyor.'**
  String get tgVoiceErrUnavailable;

  /// No description provided for @tgMicOn.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofonu aç'**
  String get tgMicOn;

  /// No description provided for @tgMicOff.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofonu kapat'**
  String get tgMicOff;

  /// No description provided for @tgNoticeBroken.
  ///
  /// In tr, this message translates to:
  /// **'{name} oturumdan çıktı. Sen devam edebilirsin.'**
  String tgNoticeBroken(String name);

  /// No description provided for @tgNoticeCompleted.
  ///
  /// In tr, this message translates to:
  /// **'{name} oturumunu tamamladı.'**
  String tgNoticeCompleted(String name);

  /// No description provided for @tgNoticeLeft.
  ///
  /// In tr, this message translates to:
  /// **'{name} ayrıldı.'**
  String tgNoticeLeft(String name);

  /// No description provided for @tgNoticeMessagesTitle.
  ///
  /// In tr, this message translates to:
  /// **'NöroPlan'**
  String get tgNoticeMessagesTitle;

  /// No description provided for @tgNoticeMessagesChannel.
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar'**
  String get tgNoticeMessagesChannel;

  /// No description provided for @tgNoticeMessagesBody.
  ///
  /// In tr, this message translates to:
  /// **'{count} yeni mesaj'**
  String tgNoticeMessagesBody(int count);

  /// No description provided for @tgPickMax.
  ///
  /// In tr, this message translates to:
  /// **'En çok {n} kişi seçebilirsin.'**
  String tgPickMax(int n);

  /// No description provided for @tgCofocusChooseFirst.
  ///
  /// In tr, this message translates to:
  /// **'Başlamak için önce işini seç.'**
  String get tgCofocusChooseFirst;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get settingTheme;

  /// No description provided for @settingSleepGoal.
  ///
  /// In tr, this message translates to:
  /// **'Uyku hedefi'**
  String get settingSleepGoal;

  /// No description provided for @secData.
  ///
  /// In tr, this message translates to:
  /// **'Veri ve kaynaklar'**
  String get secData;

  /// No description provided for @exportTitle.
  ///
  /// In tr, this message translates to:
  /// **'Verilerimi dışa aktar'**
  String get exportTitle;

  /// No description provided for @exportSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bütün verilerin tek bir JSON dosyası olarak; internet gerekmez.'**
  String get exportSubtitle;

  /// No description provided for @exportError.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Dosyayı hazırlayamadık, bir daha deneyelim.} young{Dosya hazırlanamadı, tekrar dene!} coder{Dışa aktarma başarısız. Tekrar dene.} calm{Dosya hazırlanamadı. Biraz sonra tekrar deneyebilirsin.} other{Dosya hazırlanamadı. Tekrar dene.}}'**
  String exportError(String tone);

  /// No description provided for @sourcesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bilimsel kaynaklar'**
  String get sourcesTitle;

  /// No description provided for @sourcesSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamadaki bilimsel ifadelerin dayandığı çalışmalar'**
  String get sourcesSubtitle;

  /// No description provided for @sourcesIntro.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamadaki her bilimsel ifade bu listedeki hakemli bir kaynağa dayanır. Kanıt düzeyleri bölge sayfalarında yazar.'**
  String get sourcesIntro;

  /// No description provided for @sourcesCopy.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantıyı kopyala'**
  String get sourcesCopy;

  /// No description provided for @themeSerious.
  ///
  /// In tr, this message translates to:
  /// **'Ciddi'**
  String get themeSerious;

  /// No description provided for @themeSeriousBody.
  ///
  /// In tr, this message translates to:
  /// **'Sakin otorite, önce okunabilirlik'**
  String get themeSeriousBody;

  /// No description provided for @themePlayful.
  ///
  /// In tr, this message translates to:
  /// **'Eğlenceli'**
  String get themePlayful;

  /// No description provided for @themePlayfulBody.
  ///
  /// In tr, this message translates to:
  /// **'Yuvarlak hatlar, sıcak renkler'**
  String get themePlayfulBody;

  /// No description provided for @themeYoung.
  ///
  /// In tr, this message translates to:
  /// **'Genç'**
  String get themeYoung;

  /// No description provided for @themeYoungBody.
  ///
  /// In tr, this message translates to:
  /// **'Enerjik ve rahat okunur'**
  String get themeYoungBody;

  /// No description provided for @themeCoder.
  ///
  /// In tr, this message translates to:
  /// **'Kodcu'**
  String get themeCoder;

  /// No description provided for @themeCoderBody.
  ///
  /// In tr, this message translates to:
  /// **'Terminal hissi; sayılar eş aralıklı'**
  String get themeCoderBody;

  /// No description provided for @themeCalm.
  ///
  /// In tr, this message translates to:
  /// **'Sakin'**
  String get themeCalm;

  /// No description provided for @themeCalmBody.
  ///
  /// In tr, this message translates to:
  /// **'Düşük doygunluk, akşam için'**
  String get themeCalmBody;

  /// No description provided for @themeHighContrast.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek kontrast'**
  String get themeHighContrast;

  /// No description provided for @themeHighContrastBody.
  ///
  /// In tr, this message translates to:
  /// **'En yüksek kontrast, kalın çerçeveler'**
  String get themeHighContrastBody;

  /// No description provided for @themeMinimal.
  ///
  /// In tr, this message translates to:
  /// **'Minimal'**
  String get themeMinimal;

  /// No description provided for @themeMinimalBody.
  ///
  /// In tr, this message translates to:
  /// **'Gri yüzeyler, tek vurgu rengi'**
  String get themeMinimalBody;

  /// No description provided for @themePaper.
  ///
  /// In tr, this message translates to:
  /// **'Kâğıt'**
  String get themePaper;

  /// No description provided for @themePaperBody.
  ///
  /// In tr, this message translates to:
  /// **'Kâğıt ve mürekkep, geçişsiz; uzun okuma ve ders için'**
  String get themePaperBody;

  /// No description provided for @themeNature.
  ///
  /// In tr, this message translates to:
  /// **'Doğa'**
  String get themeNature;

  /// No description provided for @themeNatureBody.
  ///
  /// In tr, this message translates to:
  /// **'Topraksı sıcak renkler, yumuşak hatlar'**
  String get themeNatureBody;

  /// No description provided for @themeNight.
  ///
  /// In tr, this message translates to:
  /// **'Gece'**
  String get themeNight;

  /// No description provided for @themeNightBody.
  ///
  /// In tr, this message translates to:
  /// **'Gerçek siyah zemin, az ışık; gece ve OLED ekran için'**
  String get themeNightBody;

  /// No description provided for @themeScreenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm ve tema'**
  String get themeScreenTitle;

  /// No description provided for @themePreviewBody.
  ///
  /// In tr, this message translates to:
  /// **'Sıradaki iş 15 dk sonra · 25 dk odak'**
  String get themePreviewBody;

  /// No description provided for @themeRowValue.
  ///
  /// In tr, this message translates to:
  /// **'{theme} · {mode}'**
  String themeRowValue(String theme, String mode);

  /// No description provided for @featureOffTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölüm şu an kapalı'**
  String get featureOffTitle;

  /// No description provided for @featureOffBody.
  ///
  /// In tr, this message translates to:
  /// **'Bakım ya da düzenleme için geçici olarak kapattık. Verilerin yerinde; bölüm açılınca kaldığın yerden devam edersin.'**
  String get featureOffBody;

  /// No description provided for @settingCrashReports.
  ///
  /// In tr, this message translates to:
  /// **'Çökme raporları gönder'**
  String get settingCrashReports;

  /// No description provided for @settingCrashReportsBody.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama çökerse kimliksiz hata ayrıntısı Firebase Crashlytics\'e gider. Planların, notların ve adın gitmez.'**
  String get settingCrashReportsBody;

  /// No description provided for @pfAnalyses.
  ///
  /// In tr, this message translates to:
  /// **'Analizler'**
  String get pfAnalyses;

  /// No description provided for @pfWeekFocus.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta odak'**
  String get pfWeekFocus;

  /// No description provided for @pfLastWeek.
  ///
  /// In tr, this message translates to:
  /// **'Geçen hafta {time}'**
  String pfLastWeek(String time);

  /// No description provided for @pfAdherence.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta plana uyum'**
  String get pfAdherence;

  /// No description provided for @pfNoPlanYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz planlı iş yok'**
  String get pfNoPlanYet;

  /// No description provided for @pfStreak.
  ///
  /// In tr, this message translates to:
  /// **'Seri'**
  String get pfStreak;

  /// No description provided for @pfLongest.
  ///
  /// In tr, this message translates to:
  /// **'En uzun: {n} gün'**
  String pfLongest(int n);

  /// No description provided for @pfStrongest.
  ///
  /// In tr, this message translates to:
  /// **'En güçlü bölge'**
  String get pfStrongest;

  /// No description provided for @pfStrongestEmpty.
  ///
  /// In tr, this message translates to:
  /// **'İlk odak oturumunla başlar'**
  String get pfStrongestEmpty;

  /// No description provided for @stQTime.
  ///
  /// In tr, this message translates to:
  /// **'Zamanım nereye gidiyor?'**
  String get stQTime;

  /// No description provided for @stQAdherence.
  ///
  /// In tr, this message translates to:
  /// **'Plana ne kadar uyuyorum?'**
  String get stQAdherence;

  /// No description provided for @stQBestHours.
  ///
  /// In tr, this message translates to:
  /// **'Ne zaman en iyi odaklanıyorum?'**
  String get stQBestHours;

  /// No description provided for @stQConsistency.
  ///
  /// In tr, this message translates to:
  /// **'Tutarlı mıyım?'**
  String get stQConsistency;

  /// No description provided for @stQQuality.
  ///
  /// In tr, this message translates to:
  /// **'Odak kalitem nasıl değişiyor?'**
  String get stQQuality;

  /// No description provided for @stQInterruptions.
  ///
  /// In tr, this message translates to:
  /// **'Ne beni bölüyor?'**
  String get stQInterruptions;

  /// No description provided for @stQModes.
  ///
  /// In tr, this message translates to:
  /// **'Pomodoro mu derin çalışma mı bana daha iyi geliyor?'**
  String get stQModes;

  /// No description provided for @stQBrain.
  ///
  /// In tr, this message translates to:
  /// **'Beynim nasıl gelişiyor?'**
  String get stQBrain;

  /// No description provided for @stQProjects.
  ///
  /// In tr, this message translates to:
  /// **'Projelerim yetişecek mi?'**
  String get stQProjects;

  /// No description provided for @stQSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uykum yeterli mi?'**
  String get stQSleep;

  /// No description provided for @stQBalance.
  ///
  /// In tr, this message translates to:
  /// **'Dengeli miyim?'**
  String get stQBalance;

  /// No description provided for @stQWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık rapor'**
  String get stQWeekly;

  /// No description provided for @stPeriodWeek.
  ///
  /// In tr, this message translates to:
  /// **'Hafta'**
  String get stPeriodWeek;

  /// No description provided for @stPeriodMonth.
  ///
  /// In tr, this message translates to:
  /// **'Ay'**
  String get stPeriodMonth;

  /// No description provided for @stPeriodQuarter.
  ///
  /// In tr, this message translates to:
  /// **'3 ay'**
  String get stPeriodQuarter;

  /// No description provided for @stPeriodYear.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get stPeriodYear;

  /// No description provided for @stPeriodAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get stPeriodAll;

  /// No description provided for @stShowList.
  ///
  /// In tr, this message translates to:
  /// **'Liste olarak göster'**
  String get stShowList;

  /// No description provided for @stLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get stLoading;

  /// No description provided for @stEmptyFocus.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Burası henüz boş. İlk odak oturumunu başlat, grafikler renklenmeye başlasın.} young{Henüz veri yok. Bir odak oturumu başlat, burası dolsun!} coder{Veri kümesi boş. İlk odak oturumu ilk satırı yazar.} calm{Henüz veri yok. İlk odak oturumundan sonra burası yavaşça dolmaya başlar.} other{Henüz veri yok. İlk odak oturumunu başlat, burası dolmaya başlar.}}'**
  String stEmptyFocus(String tone);

  /// No description provided for @stEmptyFocusAction.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Haydi, ilk odak oturumu} young{Odak oturumu başlat} coder{Odak oturumu başlat} calm{İlk odak oturumunu başlat} other{İlk odak oturumunu başlat}}'**
  String stEmptyFocusAction(String tone);

  /// No description provided for @stEmptyRated.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Puan verdiğin oturum yok. Oturum bitince odak ve yorgunluğunu puanla, burası şenlensin.} young{Puanlı oturum yok. Oturum sonunda puan ver, burada görünsün.} coder{Puanlı kayıt yok. Oturum sonunda odak ve yorgunluk puanı gir.} calm{Henüz puan verdiğin bir oturum yok. Oturum bitince odak ve yorgunluğunu puanladığında burada görünür.} other{Henüz puan verdiğin bir odak oturumu yok. Oturum bitince odak ve yorgunluk puanını verdiğinde burada görünür.}}'**
  String stEmptyRated(String tone);

  /// No description provided for @stEmptyPlan.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Bu dönemde planlı iş yok. Bir rutin ekle, uyumu ertesi gün ölçmeye başlarız.} young{Bu dönemde plan yok. Rutin ekle, uyum yarından itibaren ölçülsün.} coder{Bu aralıkta planlı kayıt yok. Uyum ertesi günden itibaren hesaplanır.} calm{Bu dönemde planlanmış iş yok. Bir rutin eklediğinde uyum ertesi günden itibaren ölçülür.} other{Bu dönemde planlanmış iş yok. Bir rutin ya da iş ekle; uyum ertesi günden itibaren ölçülür.}}'**
  String stEmptyPlan(String tone);

  /// No description provided for @stEmptyPlanAction.
  ///
  /// In tr, this message translates to:
  /// **'İş ekle'**
  String get stEmptyPlanAction;

  /// No description provided for @stEmptyProjects.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Proje yok. Son tarihli bir proje ekle, kalan işi birlikte izleyelim.} young{Henüz proje yok. Bir proje ekle, kalan işi takip et.} coder{Proje tablosu boş. Toplam süre ve son tarihle bir proje ekle.} calm{Henüz proje yok. Son tarihi ve toplam süresi olan bir proje eklediğinde kalan işi burada izlersin.} other{Henüz proje yok. Son tarihi ve toplam süresi olan bir proje ekle, kalan işi burada izle.}}'**
  String stEmptyProjects(String tone);

  /// No description provided for @stEmptyProjectsAction.
  ///
  /// In tr, this message translates to:
  /// **'Proje ekle'**
  String get stEmptyProjectsAction;

  /// No description provided for @stEmptySleep.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Uyku pencereni henüz söylemedin. Ayarla, uykunu burada görelim.} young{Uyku pencereni ayarla, uykun burada görünsün.} coder{Uyku penceresi tanımsız. Ayarlardan tanımla.} calm{Uyku pencereni henüz ayarlamadın. Ayarladığında planlanan uykun burada görünür.} other{Uyku pencereni henüz ayarlamadın. Ayarladığında planlanan uykun burada görünür.}}'**
  String stEmptySleep(String tone);

  /// No description provided for @stEmptySleepAction.
  ///
  /// In tr, this message translates to:
  /// **'Uyku penceresini ayarla'**
  String get stEmptySleepAction;

  /// No description provided for @stEmptyWeekly.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Bu iki haftada odak oturumu yok. İlk oturumdan sonra raporun hazır.} young{İki haftadır oturum yok. İlk oturumdan sonra rapor hazır!} coder{Son iki haftada kayıt yok; rapor üretilemedi.} calm{Bu hafta ve geçen hafta odak oturumu yok. İlk oturumdan sonra rapor hazır olur.} other{Bu hafta ve geçen hafta odak oturumu yok. İlk oturumdan sonra rapor hazır olur.}}'**
  String stEmptyWeekly(String tone);

  /// No description provided for @stNoSessionsHere.
  ///
  /// In tr, this message translates to:
  /// **'Burada odak oturumu yok.'**
  String get stNoSessionsHere;

  /// No description provided for @stMoreSessions.
  ///
  /// In tr, this message translates to:
  /// **'ve {n} oturum daha'**
  String stMoreSessions(int n);

  /// No description provided for @stFreeSession.
  ///
  /// In tr, this message translates to:
  /// **'Serbest odak'**
  String get stFreeSession;

  /// No description provided for @stBroken.
  ///
  /// In tr, this message translates to:
  /// **'bozuldu'**
  String get stBroken;

  /// No description provided for @stFocusScoreShort.
  ///
  /// In tr, this message translates to:
  /// **'odak {n}/5'**
  String stFocusScoreShort(int n);

  /// No description provided for @stPercent.
  ///
  /// In tr, this message translates to:
  /// **'%{n}'**
  String stPercent(int n);

  /// No description provided for @stDays.
  ///
  /// In tr, this message translates to:
  /// **'{n} gün'**
  String stDays(int n);

  /// No description provided for @stNeurons.
  ///
  /// In tr, this message translates to:
  /// **'{n} nöron'**
  String stNeurons(int n);

  /// No description provided for @stNeuronsGained.
  ///
  /// In tr, this message translates to:
  /// **'+{n} nöron'**
  String stNeuronsGained(int n);

  /// No description provided for @stPoints.
  ///
  /// In tr, this message translates to:
  /// **'{n} puan'**
  String stPoints(int n);

  /// No description provided for @stNoCategory.
  ///
  /// In tr, this message translates to:
  /// **'Kategorisiz'**
  String get stNoCategory;

  /// No description provided for @stUncategorized.
  ///
  /// In tr, this message translates to:
  /// **'Alt kategorisiz'**
  String get stUncategorized;

  /// No description provided for @stDirectly.
  ///
  /// In tr, this message translates to:
  /// **'Doğrudan bu kategori'**
  String get stDirectly;

  /// No description provided for @stUpLevel.
  ///
  /// In tr, this message translates to:
  /// **'Bir üst düzey'**
  String get stUpLevel;

  /// No description provided for @stNone.
  ///
  /// In tr, this message translates to:
  /// **'yok'**
  String get stNone;

  /// No description provided for @stTimeInsight.
  ///
  /// In tr, this message translates to:
  /// **'En çok zamanı {name} alanına ayırdın: {time} (%{pct}).'**
  String stTimeInsight(String name, String time, int pct);

  /// No description provided for @stTimeTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam odak: {time}. Bozulan oturumlardaki odak süresi de sayılır.'**
  String stTimeTotal(String time);

  /// No description provided for @stPlanned.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan'**
  String get stPlanned;

  /// No description provided for @stDone.
  ///
  /// In tr, this message translates to:
  /// **'Yapılan'**
  String get stDone;

  /// No description provided for @stAdherence.
  ///
  /// In tr, this message translates to:
  /// **'Plana uyum'**
  String get stAdherence;

  /// No description provided for @stDoneOf.
  ///
  /// In tr, this message translates to:
  /// **'{done} / {planned} iş'**
  String stDoneOf(int done, int planned);

  /// No description provided for @stAdherenceInsight.
  ///
  /// In tr, this message translates to:
  /// **'Planladığın {planned} işin {done} tanesini yaptın (%{pct}).'**
  String stAdherenceInsight(int done, int planned, int pct);

  /// No description provided for @stDailyAdherence.
  ///
  /// In tr, this message translates to:
  /// **'Günlük uyum'**
  String get stDailyAdherence;

  /// No description provided for @stBestInsight.
  ///
  /// In tr, this message translates to:
  /// **'En iyi odak saatin {from}–{to} (ortalama odak puanı {score}).'**
  String stBestInsight(String from, String to, String score);

  /// No description provided for @stBestNeedMore.
  ///
  /// In tr, this message translates to:
  /// **'En iyi saatini bulmak için aynı saat dilimlerinde en az 3 puanlı oturum gerekiyor.'**
  String get stBestNeedMore;

  /// No description provided for @stHeatCaption.
  ///
  /// In tr, this message translates to:
  /// **'Her hücre o gün ve saatte başlayan oturumların ortalama odak puanı (1–5). Gri: oturum yok.'**
  String get stHeatCaption;

  /// No description provided for @stScoreCount.
  ///
  /// In tr, this message translates to:
  /// **'{score} · {n} oturum'**
  String stScoreCount(String score, int n);

  /// No description provided for @stNoRating.
  ///
  /// In tr, this message translates to:
  /// **'Puan yok'**
  String get stNoRating;

  /// No description provided for @stStreakInsight.
  ///
  /// In tr, this message translates to:
  /// **'Güncel serin {current} gün, en uzun serin {longest} gün.'**
  String stStreakInsight(int current, int longest);

  /// No description provided for @stStreakCurrent.
  ///
  /// In tr, this message translates to:
  /// **'Güncel seri'**
  String get stStreakCurrent;

  /// No description provided for @stStreakLongest.
  ///
  /// In tr, this message translates to:
  /// **'En uzun seri'**
  String get stStreakLongest;

  /// No description provided for @stCalendarCaption.
  ///
  /// In tr, this message translates to:
  /// **'Son bir yılda {n} gün en az bir odak oturumu tamamladın.'**
  String stCalendarCaption(int n);

  /// No description provided for @stLess.
  ///
  /// In tr, this message translates to:
  /// **'Az'**
  String get stLess;

  /// No description provided for @stMore.
  ///
  /// In tr, this message translates to:
  /// **'Çok'**
  String get stMore;

  /// No description provided for @stFocusScore.
  ///
  /// In tr, this message translates to:
  /// **'Odak puanı'**
  String get stFocusScore;

  /// No description provided for @stFatigueScore.
  ///
  /// In tr, this message translates to:
  /// **'Yorgunluk puanı'**
  String get stFatigueScore;

  /// No description provided for @stFocusFatigue.
  ///
  /// In tr, this message translates to:
  /// **'Odak {focus} · Yorgunluk {fatigue}'**
  String stFocusFatigue(String focus, String fatigue);

  /// No description provided for @stQualityUp.
  ///
  /// In tr, this message translates to:
  /// **'Odak puanın dönemin ikinci yarısında {d} puan yükseldi.'**
  String stQualityUp(String d);

  /// No description provided for @stQualityDown.
  ///
  /// In tr, this message translates to:
  /// **'Odak puanın dönemin ikinci yarısında {d} puan düştü.'**
  String stQualityDown(String d);

  /// No description provided for @stQualityStable.
  ///
  /// In tr, this message translates to:
  /// **'Odak puanın bu dönemde yaklaşık aynı kaldı.'**
  String get stQualityStable;

  /// No description provided for @stQualityNeedMore.
  ///
  /// In tr, this message translates to:
  /// **'Eğilim için en az iki farklı zamanda puanlı oturum gerekiyor.'**
  String get stQualityNeedMore;

  /// No description provided for @stQualityCaption.
  ///
  /// In tr, this message translates to:
  /// **'Puanlar oturum sonunda senin verdiğin değerlerdir (1–5).'**
  String get stQualityCaption;

  /// No description provided for @stInterruptions.
  ///
  /// In tr, this message translates to:
  /// **'Kesinti'**
  String get stInterruptions;

  /// No description provided for @stPerSession.
  ///
  /// In tr, this message translates to:
  /// **'Oturum başına'**
  String get stPerSession;

  /// No description provided for @stByReason.
  ///
  /// In tr, this message translates to:
  /// **'Sebebe göre'**
  String get stByReason;

  /// No description provided for @stByHour.
  ///
  /// In tr, this message translates to:
  /// **'Günün saatine göre'**
  String get stByHour;

  /// No description provided for @stInterruptInsight.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönemde {n} kesinti oldu; en sık sebep: {reason}, en çok {hour} civarında.'**
  String stInterruptInsight(String reason, String hour, int n);

  /// No description provided for @stNoInterruptions.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Bu dönemde hiç bölünmedin, tertemiz!} young{Bu dönemde hiç kesinti yok!} coder{Kesinti sayısı: 0.} calm{Bu dönemde odak oturumlarında hiç kesinti olmadı.} other{Bu dönemde odak oturumlarında hiç kesinti olmadı.}}'**
  String stNoInterruptions(String tone);

  /// No description provided for @stReasonAppLeft.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamadan çıkış'**
  String get stReasonAppLeft;

  /// No description provided for @stReasonShade.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim paneli'**
  String get stReasonShade;

  /// No description provided for @stReasonScreenOff.
  ///
  /// In tr, this message translates to:
  /// **'Ekran kapandı'**
  String get stReasonScreenOff;

  /// No description provided for @stReasonCall.
  ///
  /// In tr, this message translates to:
  /// **'Telefon araması'**
  String get stReasonCall;

  /// No description provided for @stReasonAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Alarm'**
  String get stReasonAlarm;

  /// No description provided for @stReasonOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get stReasonOther;

  /// No description provided for @stModesNeedMore.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırma için Pomodoro\'dan {pomodoro}, derin çalışmadan {deep} oturum daha gerekiyor.'**
  String stModesNeedMore(int pomodoro, int deep);

  /// No description provided for @stModeProgress.
  ///
  /// In tr, this message translates to:
  /// **'{mode}: {n} / 5 oturum'**
  String stModeProgress(String mode, int n);

  /// No description provided for @stModesHow.
  ///
  /// In tr, this message translates to:
  /// **'Odak oturumunu başlatırken modu seç; her iki moddan en az 5 oturum olunca kendi verinle karşılaştırırız.'**
  String get stModesHow;

  /// No description provided for @stModesPomodoroHigher.
  ///
  /// In tr, this message translates to:
  /// **'Senin verinde Pomodoro\'da odak puanın daha yüksek ({a} – {b}).'**
  String stModesPomodoroHigher(String a, String b);

  /// No description provided for @stModesDeepHigher.
  ///
  /// In tr, this message translates to:
  /// **'Senin verinde derin çalışmada odak puanın daha yüksek ({a} – {b}).'**
  String stModesDeepHigher(String a, String b);

  /// No description provided for @stModesClose.
  ///
  /// In tr, this message translates to:
  /// **'Senin verinde iki modda odak puanın birbirine yakın.'**
  String get stModesClose;

  /// No description provided for @stModesScience.
  ///
  /// In tr, this message translates to:
  /// **'Araştırmalarda iki yöntemin birbirinden genel olarak daha iyi olduğuna dair tutarlı bir kanıt yok; bu kıyas yalnız senin verindir.'**
  String get stModesScience;

  /// No description provided for @stCompletion.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanma oranı'**
  String get stCompletion;

  /// No description provided for @stAvgLength.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama süre'**
  String get stAvgLength;

  /// No description provided for @stSessions.
  ///
  /// In tr, this message translates to:
  /// **'Oturum'**
  String get stSessions;

  /// No description provided for @stModeSessions.
  ///
  /// In tr, this message translates to:
  /// **'{mode} oturumları'**
  String stModeSessions(String mode);

  /// No description provided for @stBrainInsight.
  ///
  /// In tr, this message translates to:
  /// **'Beyin haritanda bu dönemde en çok {region} bölgesine nöron eklendi ({n}).'**
  String stBrainInsight(String region, int n);

  /// No description provided for @stBrainNoGrowth.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönemde beyin haritana nöron eklenmedi.'**
  String get stBrainNoGrowth;

  /// No description provided for @stBrainCaption.
  ///
  /// In tr, this message translates to:
  /// **'Çizgiler en çok nöron eklenen üç bölgenin toplamı. Bu dönemde bağlantı gücü: +{n}.'**
  String stBrainCaption(int n);

  /// No description provided for @stFadingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sönen bölgeler'**
  String get stFadingTitle;

  /// No description provided for @stFadingNone.
  ///
  /// In tr, this message translates to:
  /// **'Şu an sönen bölge yok.'**
  String get stFadingNone;

  /// No description provided for @stFadingBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölgelerle ilişkili etkinliklere bir süredir zaman ayrılmadı. Nöronlar silinmez; yeniden çalışınca canlanır.'**
  String get stFadingBody;

  /// No description provided for @stBrightness.
  ///
  /// In tr, this message translates to:
  /// **'Parlaklık %{n}'**
  String stBrightness(int n);

  /// No description provided for @stBrainMetaphor.
  ///
  /// In tr, this message translates to:
  /// **'Beyin haritası bir metafordur, beyninin ölçümü değildir.'**
  String get stBrainMetaphor;

  /// No description provided for @stOpenProject.
  ///
  /// In tr, this message translates to:
  /// **'Projeyi aç'**
  String get stOpenProject;

  /// No description provided for @stProjectNoTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam süre girilmemiş; kalan işi hesaplamak için projeye toplam süre ekle.'**
  String get stProjectNoTotal;

  /// No description provided for @stRemaining.
  ///
  /// In tr, this message translates to:
  /// **'Kalan'**
  String get stRemaining;

  /// No description provided for @stRemainingOf.
  ///
  /// In tr, this message translates to:
  /// **'Kalan {left} / {total}'**
  String stRemainingOf(String left, String total);

  /// No description provided for @stProjectDone.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Proje tamam! Eline sağlık.} young{Proje bitti, süper!} coder{Proje: tamamlandı (exit 0).} calm{Proje tamamlandı.} other{Proje tamamlandı.}}'**
  String stProjectDone(String tone);

  /// No description provided for @stProjectNoForecast.
  ///
  /// In tr, this message translates to:
  /// **'Tahmin için yakın zamanda çalışma ya da planlı parça yok.'**
  String get stProjectNoForecast;

  /// No description provided for @stProjectFinishPlan.
  ///
  /// In tr, this message translates to:
  /// **'Plana göre tahmini bitiş: {date}'**
  String stProjectFinishPlan(String date);

  /// No description provided for @stProjectFinishPace.
  ///
  /// In tr, this message translates to:
  /// **'Son 14 günün temposuyla tahmini bitiş: {date}'**
  String stProjectFinishPace(String date);

  /// No description provided for @stProjectOnTime.
  ///
  /// In tr, this message translates to:
  /// **'son tarih {date}, yetişiyor'**
  String stProjectOnTime(String date);

  /// No description provided for @stProjectLate.
  ///
  /// In tr, this message translates to:
  /// **'son tarih {date}, bu tempoyla yetişmiyor'**
  String stProjectLate(String date);

  /// No description provided for @stSleepPlanned.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan uyku'**
  String get stSleepPlanned;

  /// No description provided for @stSleepInsight.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan uykun ortalama {avg}; {diff}.'**
  String stSleepInsight(String avg, String diff);

  /// No description provided for @stSleepOnGoal.
  ///
  /// In tr, this message translates to:
  /// **'hedefinle aynı'**
  String get stSleepOnGoal;

  /// No description provided for @stSleepAbove.
  ///
  /// In tr, this message translates to:
  /// **'hedefinden {d} fazla'**
  String stSleepAbove(String d);

  /// No description provided for @stSleepBelow.
  ///
  /// In tr, this message translates to:
  /// **'hedefinden {d} az'**
  String stSleepBelow(String d);

  /// No description provided for @stSleepNotice.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan uykun 7 saatin altında. İstersen uyku pencereni gözden geçirebilirsin.'**
  String get stSleepNotice;

  /// No description provided for @stSleepGoalLine.
  ///
  /// In tr, this message translates to:
  /// **'Yatay çizgi uyku hedefin: {goal}. Değerler planlanan penceredir, ölçülen uyku değil.'**
  String stSleepGoalLine(String goal);

  /// No description provided for @stBalanceAll.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Her alana biraz zaman ayırdın, rengârenk bir dönem!} young{Her alana zaman ayırdın, harika denge!} coder{Bütün kökler > 0 dk.} calm{Bu dönemde bütün alanlara zaman ayırdın.} other{Bu dönemde bütün alanlara zaman ayırdın.}}'**
  String stBalanceAll(String tone);

  /// No description provided for @stBalanceNeglected.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönemde {n} alana odak zamanı ayrılmadı: {names}.'**
  String stBalanceNeglected(int n, String names);

  /// No description provided for @stBalanceCaption.
  ///
  /// In tr, this message translates to:
  /// **'Odak oturumlarının kök kategorilere göre dağılımı. Dinlenme ve Uyku odakla ölçülmediği için ihmal sayılmaz.'**
  String get stBalanceCaption;

  /// No description provided for @stShareImage.
  ///
  /// In tr, this message translates to:
  /// **'Görsel olarak paylaş'**
  String get stShareImage;

  /// No description provided for @stShareError.
  ///
  /// In tr, this message translates to:
  /// **'{tone, select, playful{Görseli hazırlayamadık, bir daha deneyelim.} young{Görsel olmadı, tekrar dene!} coder{Görsel üretilemedi. Tekrar dene.} calm{Görsel hazırlanamadı. Biraz sonra tekrar deneyebilirsin.} other{Görsel hazırlanamadı. Tekrar dene.}}'**
  String stShareError(String tone);

  /// No description provided for @stWeekFocus.
  ///
  /// In tr, this message translates to:
  /// **'Odak süresi'**
  String get stWeekFocus;

  /// No description provided for @stWeekSessions.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan oturum'**
  String get stWeekSessions;

  /// No description provided for @stWeekActiveDays.
  ///
  /// In tr, this message translates to:
  /// **'Aktif gün'**
  String get stWeekActiveDays;

  /// No description provided for @stSameAsLastWeek.
  ///
  /// In tr, this message translates to:
  /// **'geçen haftayla aynı'**
  String get stSameAsLastWeek;

  /// No description provided for @stUpBy.
  ///
  /// In tr, this message translates to:
  /// **'geçen haftadan {d} fazla'**
  String stUpBy(String d);

  /// No description provided for @stDownBy.
  ///
  /// In tr, this message translates to:
  /// **'geçen haftadan {d} az'**
  String stDownBy(String d);

  /// No description provided for @stWeekTop.
  ///
  /// In tr, this message translates to:
  /// **'En çok zaman: {name}'**
  String stWeekTop(String name);
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'tr':
      return L10nTr();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
