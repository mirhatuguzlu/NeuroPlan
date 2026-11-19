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
  /// **'Bir şeyler ters gitti'**
  String get errorTitle;

  /// No description provided for @errorBody.
  ///
  /// In tr, this message translates to:
  /// **'Verilerin cihazında güvende. Tekrar deneyebilirsin.'**
  String get errorBody;

  /// No description provided for @saveError.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilemedi. Tekrar dene.'**
  String get saveError;

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
  /// **'Açık, koyu ya da cihazınla aynı. İstediğin zaman Profil\'den değiştirebilirsin.'**
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
  /// **'İlk rutinini ekleyelim'**
  String get onbFirstTitle;

  /// No description provided for @onbFirstBody.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama senin hayatın hakkında hiçbir şey varsaymaz. Hazır örnek yok; ilk işini sen eklersin.'**
  String get onbFirstBody;

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
  /// **'Planın henüz boş'**
  String get todayEmptyTitle;

  /// No description provided for @todayEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Rutinlerini ve işlerini ekledikçe günün burada belirir; boş zamanın da hesaplanır.'**
  String get todayEmptyBody;

  /// No description provided for @todayEmptyAction.
  ///
  /// In tr, this message translates to:
  /// **'İlk rutinini ekle'**
  String get todayEmptyAction;

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
  /// **'Henüz alt kategori ya da iş yok.'**
  String get catEmpty;

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
  /// **'Profil ve ayarlar'**
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
  /// **'Oturum bozuldu'**
  String get focusBrokenHeading;

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
  /// **'Olabilir. Hazır olduğunda yeniden başlayabilirsin.'**
  String get focusBrokenAgain;

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
  /// **'Bu oturumun karşılığı'**
  String get focusGainTitle;

  /// No description provided for @focusGainBody.
  ///
  /// In tr, this message translates to:
  /// **'{root} ile ilişkilendirilen bölgelere {minutes} dk ayırdın.'**
  String focusGainBody(String root, int minutes);

  /// No description provided for @focusGainNone.
  ///
  /// In tr, this message translates to:
  /// **'Bir dakikadan kısa sürdü; beyne eklenecek süre birikmedi.'**
  String get focusGainNone;

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
  /// **'Henüz yanan nöron yok'**
  String get brainEmptyTitle;

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
