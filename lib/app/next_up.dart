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
import 'focus_platform.dart';
import 'notifications.dart';
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

/// "Saatinde otomatik başlat ve bitir" (cihaza özel, varsayılan açık; D63).
final autoRunProvider = StreamProvider<bool>(
  (ref) => ref
      .watch(prefsRepositoryProvider)
      .watch(PrefsRepository.autoRun)
      .map((v) => v != '0'),
);

final nextUpProvider = Provider(
  (ref) => NextUp(ref.watch(notificationsProvider)),
);

/// "Sıradaki iş" bildirimleri ve ana ekran widget'ı. Plan değiştikçe önümüzdeki 7 günün
/// saatli işleri için en çok 50 bildirim yeniden kurulur.
// shortcut: uygulama 7 gün açılmazsa bildirimler biter; gerekirse WorkManager ile tazele.
class NextUp {
  NextUp(this._n);

  final Notifications _n;
  String? _last;

  static const _widget = 'NextUpWidgetProvider';
  static const _channel = 'next_up';

  FlutterLocalNotificationsPlugin get _plugin => _n.plugin;
  AndroidFlutterLocalNotificationsPlugin? get _android => _n.android;
  Future<void> _init() => _n.ensure();

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
    bool auto = false,
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
      auto,
      l.localeName,
    ].join('|');
    if (signature == _last) return;
    _last = signature;
    try {
      await _syncWidget(view, upcoming, l);
      await _syncNotifications(
        view,
        l,
        reminders(view, l, lead: lead, auto: auto),
        exact,
      );
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
    L10n l,
    List<Reminder> reminders,
    bool exact,
  ) async {
    await _init();
    // Yalnız zamanlanmışlar: gösterilen odak bildirimleri (kalıcı, uyarı) silinmesin.
    // Odak oturumunun zamanlanmış "mola bitti" uyarısı burada silinmez.
    for (final p in await _plugin.pendingNotificationRequests()) {
      if (p.id != AndroidFocusPlatform.breakOverId) {
        await _plugin.cancel(id: p.id);
      }
    }
    if (reminders.isEmpty) return;
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
    for (final r in reminders) {
      await _plugin.zonedSchedule(
        id: id++,
        scheduledDate: tz.TZDateTime.from(utcOf(r.at), tz.UTC),
        notificationDetails: details,
        androidScheduleMode: canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        title: r.title,
        body: r.body,
        payload: r.payload,
      );
    }
  }

  /// Önümüzdeki 7 günün bildirimleri, zamana göre, en çok 50 tane:
  /// [lead] dakika önce hatırlatma; [auto] açıksa başlangıçta "başla" ve odak gerektirmeyen
  /// işin bitişinde "yaptın mı?" (D63). Dokununca: `focus:<id>` odağı başlatır, `open:<id>`
  /// Bugün'de işi açar.
  @visibleForTesting
  List<Reminder> reminders(
    PlanView view,
    L10n l, {
    int? lead,
    bool auto = false,
  }) {
    final now = view.nowMinute;
    final out = <Reminder>[];
    for (final i in view.output.instances) {
      if (!i.isTimed || i.status != InstanceStatus.planned) continue;
      final s = i.start!, e = i.end!;
      if (s >= now + 7 * 1440 || e <= now) continue;
      final title = _title(view, i);
      final clock = _clock(view, s, l.localeName);
      // Başlangıçta zaten "başla" bildirimi varsa 0 dk önceki hatırlatma tekrar olur.
      if (lead != null && !(auto && lead == 0 && !i.suggested)) {
        out.add(
          Reminder(
            s - lead,
            title,
            l.notifBody(clock, l.inDuration(durationText(l, lead))),
            'open:${i.id}',
          ),
        );
      }
      if (!auto || i.suggested) continue;
      final focus = view.data.requiresFocus(i.activityId);
      out.add(
        Reminder(
          s,
          title,
          focus ? l.autoFocusBody : l.autoStartBody(clock),
          '${focus ? 'focus' : 'open'}:${i.id}',
        ),
      );
      // Odak oturumu bitişte kendisi kapanır; uyku ve serbest zaman için soru anlamsız.
      final kind = view.data.activities[i.activityId]?.kind;
      final sleep = view.data.rootOf(i.activityId) == 'rest_sleep';
      if (!focus && e > s && kind != 'free_time' && !sleep) {
        out.add(Reminder(e, title, l.autoDoneBody, 'open:${i.id}'));
      }
    }
    out.removeWhere((r) => r.at <= now);
    out.sort((a, b) => a.at.compareTo(b.at));
    return out.take(50).toList();
  }
}

/// Zamanlanmış tek bildirim; [at] UTC dakika.
class Reminder {
  const Reminder(this.at, this.title, this.body, this.payload);

  final int at;
  final String title;
  final String body;
  final String payload;

  @override
  String toString() => 'Reminder($at, $title, $body, $payload)';
}

/// Plan, dil ya da bildirim tercihi değişince [NextUp]'ı eşitler (uygulama kökünde dinlenir).
void listenNextUp(WidgetRef ref) {
  void run() {
    final view = ref.read(horizonProvider).value;
    if (view == null) return;
    ref
        .read(nextUpProvider)
        .sync(
          view,
          l10nFor(ref.read(profileProvider).value?.locale),
          lead: ref.read(notifyLeadProvider).value,
          exact: ref.read(exactAlarmsProvider).value ?? false,
          auto: ref.read(autoRunProvider).value ?? true,
        );
  }

  ref.listen(horizonProvider, (_, _) => run());
  ref.listen(autoRunProvider, (_, _) => run());
  ref.listen(notifyLeadProvider, (_, _) => run());
  ref.listen(exactAlarmsProvider, (_, _) => run());
  ref.listen(profileProvider, (_, _) => run());
}

/// Bildirim metinleri için dil: profil seçimi, yoksa desteklenen cihaz dili, yoksa İngilizce.
L10n l10nFor(String? profileLocale) {
  final device = WidgetsBinding.instance.platformDispatcher.locale;
  return lookupL10n(
    profileLocale != null
        ? Locale(profileLocale)
        : L10n.supportedLocales.any(
            (s) => s.languageCode == device.languageCode,
          )
        ? Locale(device.languageCode)
        : const Locale('en'),
  );
}
