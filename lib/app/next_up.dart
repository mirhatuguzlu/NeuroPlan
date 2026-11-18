import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/repositories/prefs_repository.dart';
import '../l10n/app_localizations.dart';
import '../ui/core/format.dart';
import 'providers.dart';

/// Bildirim tercihleri (cihaza özel, D27).
final notifyLeadProvider = StreamProvider<int?>(
  (ref) => ref
      .watch(prefsRepositoryProvider)
      .watch(PrefsRepository.notifyLead)
      .map((v) => v == null ? null : int.tryParse(v)),
);
final exactAlarmsProvider = StreamProvider<bool>(
  (ref) => ref
      .watch(prefsRepositoryProvider)
      .watch(PrefsRepository.exactAlarms)
      .map((v) => v == '1'),
);

final nextUpProvider = Provider((ref) => NextUp());

/// "Sıradaki iş" bildirimleri ve ana ekran widget'ı. Plan değiştikçe önümüzdeki 7 günün
/// saatli işleri için en çok 50 bildirim yeniden kurulur.
// shortcut: uygulama 7 gün açılmazsa bildirimler biter; gerekirse WorkManager ile tazele.
class NextUp {
  final _plugin = FlutterLocalNotificationsPlugin();
  var _ready = false;
  String? _last;

  static const _widget = 'NextUpWidgetProvider';
  static const _channel = 'next_up';

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<void> _init() async {
    if (_ready) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  /// Android 13+ bildirim izni; ayar açılınca istenir, açılışta değil.
  Future<bool> requestPermission() async {
    await _init();
    return await _android?.requestNotificationsPermission() ?? true;
  }

  /// Sistem ayarını açar; dönüşte izin durumunu bildirir.
  Future<bool> requestExact() async {
    await _init();
    await _android?.requestExactAlarmsPermission();
    return await _android?.canScheduleExactNotifications() ?? false;
  }

  Future<void> sync(
    PlanView view,
    L10n l, {
    required int? lead,
    required bool exact,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android || kIsWeb) return;
    final now = view.nowMinute;
    final upcoming = [
      for (final i in view.output.instances)
        if (i.isTimed &&
            i.status == InstanceStatus.planned &&
            i.start! > now - 1 &&
            i.start! < now + 7 * 1440)
          i,
    ]..sort((a, b) => a.start!.compareTo(b.start!));
    final signature = [
      for (final i in upcoming.take(50)) '${i.id}@${i.start}',
      lead,
      exact,
      l.localeName,
    ].join('|');
    if (signature == _last) return;
    _last = signature;
    try {
      await _syncWidget(view, upcoming, l);
      await _syncNotifications(view, upcoming, l, lead, exact);
    } on Object catch (e) {
      _last = null; // bir sonraki değişiklikte yeniden denenir
      debugPrint('Sıradaki iş eşitlenemedi: $e');
    }
  }

  String _title(PlanView v, PlannedInstance i) =>
      v.data.activities[i.activityId]?.title ?? '';

  String _clock(PlanView v, int minute, String locale) {
    final m = v.calendar.minuteOfDay(minute);
    return clockOfDayLocale(locale, m);
  }

  Future<void> _syncWidget(
    PlanView view,
    List<PlannedInstance> upcoming,
    L10n l,
  ) async {
    // Kotlin tarafı göreli süreyi ("15 dk sonra") kendisi hesaplar; kalıplar ARB'den gelir.
    String pattern(String s, Map<String, String> marks) {
      marks.forEach((k, v) => s = s.replaceAll(k, v));
      return s;
    }

    await Future.wait([
      HomeWidget.saveWidgetData(
        'next_items',
        jsonEncode([
          for (final i in upcoming.take(8))
            {
              'title': _title(view, i),
              'start': i.start! * 60000,
              'clock': _clock(view, i.start!, l.localeName),
            },
        ]),
      ),
      HomeWidget.saveWidgetData('fmt_next', l.widgetNext('%1\$s')),
      HomeWidget.saveWidgetData('label_none', l.widgetNone),
      HomeWidget.saveWidgetData('label_now', l.widgetNow),
      HomeWidget.saveWidgetData('fmt_in', l.inDuration('%1\$s')),
      HomeWidget.saveWidgetData(
        'fmt_min',
        pattern(l.minutesShort(9001), {'9001': '%1\$d'}),
      ),
      HomeWidget.saveWidgetData(
        'fmt_h',
        pattern(l.hoursShort(9001), {'9001': '%1\$d'}),
      ),
      HomeWidget.saveWidgetData(
        'fmt_hm',
        pattern(l.hoursMinutes(9001, 9002), {'9001': '%1\$d', '9002': '%2\$d'}),
      ),
    ]);
    await HomeWidget.updateWidget(androidName: _widget);
    // Göreli süre tazelensin: 24 saat boyunca 15 dakikada bir ve her işin başlangıcında.
    final now = view.now;
    await HomeWidget.scheduleWidgetUpdates(
      [
        for (var m = 15; m <= 24 * 60; m += 15) now.add(Duration(minutes: m)),
        for (final i in upcoming.take(20)) utcOf(i.start!),
      ]..sort(),
      androidName: _widget,
    );
  }

  Future<void> _syncNotifications(
    PlanView view,
    List<PlannedInstance> upcoming,
    L10n l,
    int? lead,
    bool exact,
  ) async {
    await _init();
    await _plugin.cancelAll();
    if (lead == null) return;
    final canExact =
        exact && (await _android?.canScheduleExactNotifications() ?? false);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel,
        l.notifChannel,
        channelDescription: l.notifChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
      ),
    );
    var id = 0;
    for (final i in upcoming.take(50)) {
      final at = i.start! - lead;
      if (at <= view.nowMinute) continue;
      await _plugin.zonedSchedule(
        id: id++,
        scheduledDate: tz.TZDateTime.from(utcOf(at), tz.UTC),
        notificationDetails: details,
        androidScheduleMode: canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        title: _title(view, i),
        body: l.notifBody(
          _clock(view, i.start!, l.localeName),
          l.inDuration(durationText(l, lead)),
        ),
      );
    }
  }
}

/// Plan, dil ya da bildirim tercihi değişince [NextUp]'ı eşitler (uygulama kökünde dinlenir).
void listenNextUp(WidgetRef ref) {
  void run() {
    final view = ref.read(horizonProvider).value;
    if (view == null) return;
    final profileLocale = ref.read(profileProvider).value?.locale;
    final device = WidgetsBinding.instance.platformDispatcher.locale;
    final locale = profileLocale != null
        ? Locale(profileLocale)
        : L10n.supportedLocales.any(
            (s) => s.languageCode == device.languageCode,
          )
        ? Locale(device.languageCode)
        : const Locale('en');
    ref
        .read(nextUpProvider)
        .sync(
          view,
          lookupL10n(locale),
          lead: ref.read(notifyLeadProvider).value,
          exact: ref.read(exactAlarmsProvider).value ?? false,
        );
  }

  ref.listen(horizonProvider, (_, _) => run());
  ref.listen(notifyLeadProvider, (_, _) => run());
  ref.listen(exactAlarmsProvider, (_, _) => run());
  ref.listen(profileProvider, (_, _) => run());
}
