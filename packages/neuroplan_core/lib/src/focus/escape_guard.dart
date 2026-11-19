/// Planı bozma kuralı (FOCUS-2, DECISIONS D33): odak sırasında uygulamadan çıkılırsa
/// 10 saniyede dönülmeli. Saf durum makinesi; platform olaylarını denetleyici çevirir.
library;

const escapeGrace = Duration(seconds: 10);

/// Ekran kapanma olayı ile uygulamadan çıkış bu kadar yakınsa çıkış "ekran kapandı"dır.
const _screenOffTolerance = Duration(seconds: 2);

/// Bundan kısa dönüşler (pencere odağı titremesi) kayda geçmez.
const _minAway = Duration(seconds: 1);

/// `focus_interruptions.reason` (DB_SCHEMA §4.2).
enum AwayReason {
  appLeft('app_left'),
  notificationShade('notification_shade'),
  screenOff('screen_off'),
  phoneCall('phone_call');

  const AwayReason(this.json);
  final String json;

  /// Kaçış sayılır mı (FOCUS-6: ekran kapanması ve arama sayılmaz).
  bool get counted => this == appLeft || this == notificationShade;

  /// Odak süresinden düşülür mü: ekran kapalıyken süre işlemeye devam eder.
  bool get splitsWork => this != screenOff;

  static AwayReason fromJson(String v) => values.firstWhere((r) => r.json == v);
}

/// Süren bir dışarıda kalma. [graceFrom] null ise 10 sn sayacı askıdadır (ekran kapalı,
/// arama sürüyor).
final class Absence {
  const Absence({
    required this.leftAt,
    required this.reason,
    this.graceFrom,
    this.callHint = false,
  });

  factory Absence.fromJson(Map<String, Object?> j) => Absence(
    leftAt: DateTime.parse(j['left_at'] as String).toUtc(),
    reason: AwayReason.fromJson(j['reason'] as String),
    graceFrom: j['grace_from'] == null
        ? null
        : DateTime.parse(j['grace_from'] as String).toUtc(),
    callHint: j['call_hint'] == true,
  );

  final DateTime leftAt;
  final AwayReason reason;
  final DateTime? graceFrom;

  /// Telefon izni yok ama ses modu arama gösteriyor: son tarihte bozulmaz, dönüşte sorulur.
  final bool callHint;

  DateTime? get deadline => graceFrom?.add(escapeGrace);

  Absence copyWith({AwayReason? reason, DateTime? graceFrom, bool? callHint}) =>
      Absence(
        leftAt: leftAt,
        reason: reason ?? this.reason,
        graceFrom: graceFrom ?? this.graceFrom,
        callHint: callHint ?? this.callHint,
      );

  Map<String, Object?> toJson() => {
    'left_at': leftAt.toIso8601String(),
    'reason': reason.json,
    'grace_from': graceFrom?.toIso8601String(),
    'call_hint': callHint,
  };
}

/// `focus_interruptions` satırı.
final class Interruption {
  const Interruption({
    required this.reason,
    required this.leftAt,
    required this.away,
    required this.recovered,
    required this.counted,
  });

  final AwayReason reason;
  final DateTime leftAt;
  final Duration away;
  final bool recovered;
  final bool counted;
}

sealed class GuardResult {
  const GuardResult();
}

/// Zamanında dönüldü; oturum sürer. [gapTo] doluysa [record.leftAt]–[gapTo] odak
/// süresinden düşülür.
final class Recovered extends GuardResult {
  const Recovered(this.record, {this.gapTo});
  final Interruption record;
  final DateTime? gapTo;
}

/// 10 sn doldu; oturum [at] anında bozuldu.
final class Broken extends GuardResult {
  const Broken(this.at, this.record);
  final DateTime at;
  final Interruption record;
}

/// Süre doldu ama arama şüphesi var: "Aramadaymışsın, cezayı kaldırayım mı?"
/// Karar [EscapeGuard.pardon] ya da [EscapeGuard.refuse] ile verilir.
final class NeedsPardon extends GuardResult {
  const NeedsPardon(this.absence);
  final Absence absence;
}

final class EscapeGuard {
  EscapeGuard({this.armed = true, this.absence, this.inCall = false});

  factory EscapeGuard.fromJson(Map<String, Object?> j) => EscapeGuard(
    armed: j['armed'] != false,
    inCall: j['in_call'] == true,
    absence: j['absence'] == null
        ? null
        : Absence.fromJson((j['absence'] as Map).cast<String, Object?>()),
  );

  /// Kural işliyor mu: odakta ve normal duraklatmada evet; molada, mola sonunda ve acil
  /// durumda hayır (D34).
  bool armed;
  Absence? absence;

  /// İzinli arama durumu (telefon izni yoksa hep false).
  bool inCall;

  DateTime? _lastScreenOff;
  bool _visible = true;

  Map<String, Object?> toJson() => {
    'armed': armed,
    'in_call': inCall,
    'absence': absence?.toJson(),
  };

  bool _expired(Absence a, DateTime at) {
    final d = a.deadline;
    return d != null && !at.isBefore(d);
  }

  /// Uygulama arka plana geçti ([shade]: yalnız pencere odağı gitti, bildirim paneli).
  void left(DateTime at, {bool shade = false}) {
    _visible = false;
    if (!armed) return;
    final a = absence;
    if (a != null) {
      // Panel çekilip başka uygulamaya geçildi: aynı çıkış, nedeni güncellenir.
      if (!shade && a.reason == AwayReason.notificationShade) {
        absence = a.copyWith(reason: AwayReason.appLeft);
      }
      return;
    }
    final off = _lastScreenOff;
    absence = inCall
        ? Absence(leftAt: at, reason: AwayReason.phoneCall)
        : off != null && at.difference(off).abs() <= _screenOffTolerance
        ? Absence(leftAt: at, reason: AwayReason.screenOff)
        : Absence(
            leftAt: at,
            reason: shade ? AwayReason.notificationShade : AwayReason.appLeft,
            graceFrom: at,
          );
  }

  /// Çıkıştan kısa süre sonra yapılan cihaz sorgusu: ekran açık mı, kilit ekranı mı
  /// (ör. sabitlemeden PIN ile çıkış), arama var mı ([inCall] null = telefon izni yok),
  /// ses modu arama gösteriyor mu. Kilit ekranı ekran kapanması gibi askıya alır.
  void deviceChecked({
    required bool interactive,
    bool locked = false,
    bool? inCall,
    bool audioCall = false,
  }) {
    final a = absence;
    if (a == null) return;
    if (inCall == true) {
      callStarted(a.leftAt);
    } else if (!interactive || locked) {
      screenOff(a.leftAt);
    }
    if (inCall == null && audioCall && absence != null) {
      absence = absence!.copyWith(callHint: true);
    }
  }

  void screenOff(DateTime at) {
    _lastScreenOff = at;
    final a = absence;
    if (a == null || a.reason == AwayReason.phoneCall || _expired(a, at)) {
      return;
    }
    if (at.difference(a.leftAt) <= _screenOffTolerance) {
      absence = Absence(leftAt: a.leftAt, reason: AwayReason.screenOff);
    }
  }

  /// Kilit açıldı: ekran kapalıyken askıda olan 10 sn başlar.
  void unlocked(DateTime at) {
    _lastScreenOff = null;
    final a = absence;
    if (a != null && a.reason == AwayReason.screenOff && a.graceFrom == null) {
      absence = a.copyWith(graceFrom: at);
    }
  }

  void callStarted(DateTime at) {
    inCall = true;
    final a = absence;
    if (a == null || _expired(a, at)) return;
    // Ekran kapalıyken gelen aramada odak süresi aramanın başına kadar işler.
    absence = Absence(
      leftAt: a.reason == AwayReason.screenOff ? at : a.leftAt,
      reason: AwayReason.phoneCall,
    );
  }

  /// Arama bitti: dönmek için 10 sn başlar.
  void callEnded(DateTime at) {
    inCall = false;
    final a = absence;
    if (a != null && a.reason == AwayReason.phoneCall && a.graceFrom == null) {
      absence = a.copyWith(graceFrom: at);
    }
  }

  /// Mola ya da acil durum başladı; süren dışarıda kalma kapanır.
  Interruption? disarm(DateTime at) {
    armed = false;
    final a = absence;
    absence = null;
    return a == null ? null : _record(a, at, recovered: true);
  }

  /// Odak yeniden başladı; uygulama o an dışarıdaysa 10 sn hemen başlar.
  void arm(DateTime at) {
    armed = true;
    if (!_visible && absence == null) {
      absence = Absence(leftAt: at, reason: AwayReason.appLeft, graceFrom: at);
    }
  }

  /// Zamanlayıcıdan: son tarih geçtiyse bozulma. Arama şüphesinde karar dönüşe kalır.
  Broken? check(DateTime now) {
    final a = absence;
    if (a == null || a.callHint || !_expired(a, now)) return null;
    absence = null;
    return _broken(a);
  }

  GuardResult? returned(DateTime at) {
    _visible = true;
    _lastScreenOff = null;
    final a = absence;
    if (a == null) return null;
    if (_expired(a, at)) {
      if (a.callHint) return NeedsPardon(a);
      absence = null;
      return _broken(a);
    }
    absence = null;
    if (at.difference(a.leftAt) < _minAway) return null;
    final record = _record(a, at, recovered: true);
    return Recovered(record, gapTo: record.reason.splitsWork ? at : null);
  }

  /// Kullanıcı aramada olduğunu söyledi: ceza yok, arama süresi odaktan düşülür.
  Recovered pardon(DateTime at) {
    final a = absence!;
    absence = null;
    return Recovered(
      Interruption(
        reason: AwayReason.phoneCall,
        leftAt: a.leftAt,
        away: at.difference(a.leftAt),
        recovered: true,
        counted: false,
      ),
      gapTo: at,
    );
  }

  Broken refuse() {
    final a = absence!;
    absence = null;
    return _broken(a);
  }

  Interruption _record(Absence a, DateTime at, {required bool recovered}) {
    // Arama şüphesiyle zamanında dönüş: kuşkudan yararlanır.
    final reason = a.callHint ? AwayReason.phoneCall : a.reason;
    return Interruption(
      reason: reason,
      leftAt: a.leftAt,
      away: at.difference(a.leftAt),
      recovered: recovered,
      counted: reason.counted,
    );
  }

  Broken _broken(Absence a) {
    final at = a.deadline!;
    // Askıdan sonra (kilit açıldı, arama bitti) dönülmediyse bu bir çıkıştır.
    final reason = a.reason.counted ? a.reason : AwayReason.appLeft;
    return Broken(
      at,
      Interruption(
        reason: reason,
        leftAt: a.leftAt,
        away: at.difference(a.leftAt),
        recovered: false,
        counted: true,
      ),
    );
  }
}
