import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/focus_platform.dart';
import '../../../app/next_up.dart' show l10nFor;
import '../../../app/providers.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/prefs_repository.dart';
import '../../../l10n/app_localizations.dart';

/// Normal duraklatmada çıkma kuralı sürer; acil durumda çıkmak serbesttir (D34).
enum PauseKind { normal, emergency }

const emergencyPerDay = 3;

/// Testte sabitlenen saat.
final focusNowProvider = Provider<DateTime Function()>((_) => DateTime.now);

final focusControllerProvider = NotifierProvider<FocusController, FocusState>(
  FocusController.new,
);

class FocusState {
  const FocusState({
    this.session,
    this.clock,
    this.title = '',
    this.pause,
    this.absence,
    this.needsPardon = false,
    this.emergencyLeft = emergencyPerDay,
    this.ended,
  });

  /// Süren oturum.
  final FocusSession? session;
  final FocusClock? clock;
  final String title;
  final PauseKind? pause;

  /// Uygulama dışında / bildirim paneli açık: 10 sn geri sayımı.
  final Absence? absence;

  /// "Aramadaymışsın, cezayı kaldırayım mı?"
  final bool needsPardon;
  final int emergencyLeft;

  /// Biten oturum; ekran sonucu gösterip [FocusController.acknowledge] diyene kadar durur.
  final ({String id, String outcome})? ended;

  bool get active => session != null;
}

/// Odak oturumunu yürütür: zaman damgalı sayaç, 10 sn kuralı, kurtarma, kalıcı bildirim,
/// Rahatsız Etmeyin (DECISIONS D31–D35). Uygulama kökünde canlı tutulur.
class FocusController extends Notifier<FocusState> {
  FocusSession? _session;
  FocusClock? _clock;
  var _guard = EscapeGuard();
  PauseKind? _pause;
  var _title = '';
  ({String id, String outcome})? _ended;
  var _needsPardon = false;
  var _emergencyUsed = 0;
  Timer? _boundary;
  Timer? _deadline;
  Timer? _debounce;
  Timer? _endTimer;

  /// İşin planlanan bitişi: oturum burada kendiliğinden "tamamlandı" olur (D63).
  DateTime? _plannedEnd;
  DateTime? _alerted;
  var _pinned = false;

  /// Sabitleme onay penceresi pencere odağını alır; bu süre içindeki odak kaybı kaçış
  /// değildir. Pencere odağı dönünce ya da süre dolunca biter.
  // shortcut: onay penceresi hiç açılmazsa (zaten sabitli) 30 sn boyunca panel çekme
  // sayılmaz; sabitliyken panel zaten kapalı olduğu için kabul edildi.
  DateTime? _promptUntil;
  Future<void> _queue = Future.value();

  FocusPlatform get _platform => ref.read(focusPlatformProvider);
  PrefsRepository get _prefs => ref.read(prefsRepositoryProvider);
  DateTime _now() => ref.read(focusNowProvider)().toUtc();
  L10n get _l => l10nFor(ref.read(profileProvider).value?.locale);
  int get _emergencyLeft =>
      (emergencyPerDay - _emergencyUsed).clamp(0, emergencyPerDay);

  @override
  FocusState build() {
    final lifecycle = AppLifecycleListener(onStateChange: _onLifecycle);
    final signals = _platform.signals.listen(_onSignal);
    final actions = _platform.actions.listen(_onAction);
    ref.onDispose(() {
      lifecycle.dispose();
      signals.cancel();
      actions.cancel();
      _boundary?.cancel();
      _deadline?.cancel();
      _debounce?.cancel();
      _endTimer?.cancel();
    });
    _run(_recover);
    return const FocusState();
  }

  /// Olaylar sırayla işlenir; hata kuyruğu durdurmaz, çağırana iletilir.
  Future<T> _run<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then(
      (_) {},
      onError: (Object e, StackTrace st) => debugPrint('Odak: $e\n$st'),
    );
    return result;
  }

  /// Platform çağrısı başarısız olsa da oturum mantığı sürer.
  Future<void> _safe(Future<void> Function() call) async {
    try {
      await call();
    } on Object catch (e) {
      debugPrint('Odak platform: $e');
    }
  }

  void _emit() => state = FocusState(
    session: _session,
    clock: _clock,
    title: _title,
    pause: _pause,
    absence: _guard.absence,
    needsPardon: _needsPardon,
    emergencyLeft: _emergencyLeft,
    ended: _ended,
  );

  // ---------------------------------------------------------------- kurtarma

  Future<void> _recover() async {
    _emergencyUsed = await _readEmergency();
    final s = await ref.read(focusRepositoryProvider).watchActive().first;
    if (s == null) {
      // Önceki oturum native tarafta bozulduysa DND zaten geri yüklendi; değilse şimdi.
      await _safe(_platform.restoreDnd);
      _emit();
      return;
    }
    final settings = FocusSettings.fromJson(
      FocusMode.fromJson(s.mode),
      s.settings,
    );
    _session = s;
    _clock = FocusClock(settings, FocusClock.segmentsFromJson(s.segments));
    _title = await _titleOf(s.activityId);
    final raw = await _prefs.get(PrefsRepository.focusRuntime);
    final runtime = raw == null ? null : jsonDecode(raw) as Map;
    if (runtime?['session'] == s.id) {
      _pause = PauseKind.values.asNameMap()[runtime!['pause']];
      _guard = EscapeGuard.fromJson((runtime['guard'] as Map).cast());
      final end = runtime['end'] as String?;
      _plannedEnd = end == null ? null : DateTime.parse(end);
    }
    // Uygulama kapalıyken bitiş geçtiyse oturum bitiş anında tamamlanmış sayılır.
    if (_plannedEnd case final end? when !end.isAfter(_now())) {
      return _complete(end);
    }
    await _comeBack(_now());
    if (_session == null) return;
    if (_clock!.targetReachedAt(_now()) case final at?) return _complete(at);
    // Sabitleme süreç ölünce gitmiş olabilir; DND faza göre yeniden kurulur.
    await _syncArm(_now());
    await _showOngoing();
    _schedule();
    _scheduleEnd();
    _emit();
  }

  Future<String> _titleOf(String? activityId) async {
    if (activityId == null) return '';
    final db = ref.read(databaseProvider);
    return (await ref.read(writerProvider).find(db.activities, activityId))
            ?.title ??
        '';
  }

  // ---------------------------------------------------------------- eylemler

  /// Bugün ekranındaki işten oturum başlatır.
  /// [startAt]: ortak odakta sunucunun başlangıç anı (cihaz saatine çevrilmiş); sayaçlar
  /// senkron başlar. En çok 2 dk geriye alınır, ileri tarih yok sayılır.
  /// [ownMinutes]: "kendi süresi kadar" — oturum başlangıçtan bu kadar sonra kendiliğinden
  /// tamamlanır; derin çalışma hedefi de bu süre olur (kayıtlı hedef değişmez). Blok
  /// planlı derin çalışmada süre saf odaktır: oturum hedefe ulaşınca biter (D66).
  Future<void> start({
    required PlannedInstance instance,
    required FocusSettings settings,
    DateTime? startAt,
    int? ownMinutes,
  }) => _run(() async {
    if (_session != null) return;
    // Uyarı bildirimi için izin, gerektiği anda istenir (D27 ile aynı ilke).
    await _safe(() => _platform.requestNotificationPermission());
    final real = _now();
    final now =
        startAt != null &&
            !startAt.isAfter(real) &&
            real.difference(startAt) < const Duration(minutes: 2)
        ? startAt.toUtc()
        : real;
    // focus_sessions → plan_instances yabancı anahtarı: oluşum satırı şimdi yazılır (D22).
    await ref
        .read(planRepositoryProvider)
        .touch(instance, const PlanInstancesCompanion());
    final run =
        ownMinutes != null &&
            (settings.mode == FocusMode.deep || settings.planned)
        ? settings.copyWith(target: ownMinutes)
        : settings;
    final clock = FocusClock.start(run, now);
    _session = await ref
        .read(focusRepositoryProvider)
        .start(
          mode: settings.mode.name,
          planInstanceId: instance.id,
          activityId: instance.activityId,
          settings: run.toJson(),
          plannedMinutes: instance.isTimed
              ? instance.end! - instance.start!
              : null,
          startedAt: now,
          segments: clock.toJson(),
        );
    _clock = clock;
    _pause = null;
    _guard = EscapeGuard();
    _ended = null;
    _needsPardon = false;
    _title = await _titleOf(instance.activityId);
    // Ortak odağın kendi bitişi var; süresiz ya da bitişi geçmiş işte otomatik bitiş yok.
    final end = instance.isTimed && instance.end! > instance.start!
        ? DateTime.fromMillisecondsSinceEpoch(
            instance.end! * 60000,
            isUtc: true,
          )
        : null;
    // Blok planlı derin çalışma hedefte biter (molalar süreyi uzatır); öbürleri sürede.
    _plannedEnd =
        startAt == null && ownMinutes != null && ownMinutes > 0 && !run.blocked
        ? now.add(Duration(minutes: ownMinutes))
        : startAt == null &&
              end != null &&
              end.isAfter(now) &&
              await _prefs.get(PrefsRepository.autoRun) != '0'
        ? end
        : null;
    await _saveRuntime();
    await _saveSettings(settings.defaults);
    _syncPin(want: true);
    await _syncDnd(want: true);
    await _showOngoing();
    _schedule();
    _scheduleEnd();
    _emit();
  });

  /// Sayaç durur, çıkma kuralı sürer.
  Future<void> pause() => _run(() async {
    if (_clock?.phase != FocusPhase.working) return;
    _clock = _clock!.close(_now());
    _pause = PauseKind.normal;
    await _changed();
  });

  /// Duraklatmadan, acil durumdan ya da moladan odak bloğuna döner.
  Future<void> resume() => _run(() async {
    final c = _clock;
    if (c == null || c.phase == FocusPhase.working) return;
    _clock = c.resumeWork(_now());
    _pause = null;
    await _changed();
  });

  /// Cezasız duraklatma; günde [emergencyPerDay] kez. Hak yoksa false.
  Future<bool> emergency() => _run(() async {
    final c = _clock;
    if (c == null || _emergencyLeft <= 0) return false;
    if (c.phase != FocusPhase.working && c.phase != FocusPhase.paused) {
      return false;
    }
    _clock = c.close(_now());
    _pause = PauseKind.emergency;
    _emergencyUsed++;
    await _prefs.set(
      PrefsRepository.focusEmergency,
      '${_today()}:$_emergencyUsed',
    );
    await _changed();
    return true;
  });

  /// İsteğe bağlı mola (derin çalışma); uzunluk önceki odak süresinden önerilir.
  Future<void> takeBreak() => _run(() async {
    if (_clock?.phase != FocusPhase.working) return;
    _clock = _clock!.startBreak(_now());
    await _changed();
  });

  /// Hedefe kalan süre: blok planlı oturumda saf odak, planlı bitişte duvar saati
  /// (hangisi kısaysa); hedefsiz oturumda null.
  Duration? leftToGoal(DateTime now) {
    final c = _clock;
    if (c == null) return null;
    Duration? left;
    if (c.settings.blocked) {
      left = Duration(minutes: c.settings.target) - c.focused(now);
    }
    if (_plannedEnd case final end?) {
      final wall = end.difference(now);
      if (left == null || wall < left) left = wall;
    }
    return left;
  }

  /// "Bitir"in sonucu (D69): son 5 dk'da ya da hedefsiz oturumda iş biter; molada
  /// yapılan sayılır ve kalan bekler; odak sürerken oturum bozulur.
  FinishKind finishKind() {
    final left = leftToGoal(_now());
    if (left == null || left <= const Duration(minutes: 5)) {
      return FinishKind.complete;
    }
    return switch (_clock!.phase) {
      FocusPhase.onBreak || FocusPhase.breakOver => FinishKind.remainder,
      _ => FinishKind.broken,
    };
  }

  /// Molada bitirilirse bekleyecek kalan saf odak (dakika, yukarı yuvarlanır).
  int remainderMinutes() {
    final c = _clock;
    if (c == null) return 0;
    final now = _now();
    final left = c.settings.blocked
        ? Duration(minutes: c.settings.target) - c.focused(now)
        : leftToGoal(now) ?? Duration.zero;
    return left.isNegative ? 0 : (left.inSeconds / 60).ceil();
  }

  /// [rest]: molada bitirince kalan saf odağın nerede bekleyeceği.
  Future<void> finish({RemainderPlace rest = RemainderPlace.untimed}) =>
      _run(() async {
        final s = _session;
        if (s == null) return;
        final now = _now();
        switch (finishKind()) {
          case FinishKind.complete:
            await _complete(now);
          case FinishKind.broken:
            await _breakEarly(now);
          case FinishKind.remainder:
            final minutes = remainderMinutes();
            // Kalan en erken süren molanın bitişinde başlar; hemen yeni oturum açılmasın.
            final breakEnd = _clock!.nextBoundary(now);
            final from = breakEnd != null && breakEnd.isAfter(now)
                ? breakEnd
                : now;
            await _complete(now);
            if (rest != RemainderPlace.drop && minutes > 0) {
              await _addRemainder(s, minutes, rest, from);
            }
        }
      });

  /// Hedefe 5 dk'dan çok varken odakta Bitir: oturum bozulur; çalışılan süre analiz
  /// için yazılır, beyni beslemez (bozulma cezası işler, D31).
  Future<void> _breakEarly(DateTime now) async {
    final s = _session!;
    final clock = _clock!.advance(now).close(now);
    _clock = clock;
    await ref
        .read(focusRepositoryProvider)
        .finish(
          s.id,
          outcome: 'broken',
          focusedSeconds: clock.focused(now).inSeconds,
          segments: clock.toJson(),
          endedAt: now,
        );
    await _brainEvents(s);
    await _end(s.id, 'broken');
  }

  /// Kalan kısım aynı işin ayrı satırı olur (D69): bugünün ilk boşluğu, yarının ilk
  /// boşluğu ya da saatsiz. Boşluk yoksa o gün saatsiz bekler.
  Future<void> _addRemainder(
    FocusSession s,
    int minutes,
    RemainderPlace rest,
    DateTime from,
  ) async {
    final view = ref.read(horizonProvider).value;
    final parent = s.planInstanceId;
    final activity = s.activityId;
    if (view == null || parent == null || activity == null) return;
    final length = view.data.focusBlocks(activity)?.span(minutes) ?? minutes;
    final today = Day.parse(view.today);
    final (date, earliest) = switch (rest) {
      RemainderPlace.tomorrow => (
        today.add(1),
        view.calendar.dayStart(today.add(1)),
      ),
      _ => (today, (from.millisecondsSinceEpoch + 59999) ~/ 60000),
    };
    final at = rest == RemainderPlace.untimed
        ? null
        : view.firstFree(date.iso, earliest, length);
    DateTime? utc(int? m) => m == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(m * 60000, isUtc: true);
    await ref
        .read(planRepositoryProvider)
        .addRemainder(
          activityId: activity,
          parentId: parent,
          date: date.iso,
          minutes: minutes,
          start: utc(at),
          end: utc(at == null ? null : at + length),
        );
  }

  /// Sayaçtaki "Atla" (D66): oturum bozulmuş sayılır, odak süresi yazılmaz, iş atlanır.
  Future<void> skip() => _run(() async {
    final s = _session;
    if (s == null) return;
    final now = _now();
    final clock = _clock!.advance(now).close(now);
    _clock = clock;
    await ref
        .read(focusRepositoryProvider)
        .finish(
          s.id,
          outcome: 'broken',
          focusedSeconds: 0,
          segments: clock.toJson(),
          endedAt: now,
        );
    if (s.planInstanceId case final id?) {
      await ref.read(planRepositoryProvider).setStatus(id, 'skipped');
    }
    await _brainEvents(s);
    await _end(s.id, 'broken');
  });

  void _scheduleEnd() {
    _endTimer?.cancel();
    final end = _plannedEnd;
    if (end == null) return;
    final wait = end.difference(_now());
    _endTimer = Timer(wait.isNegative ? Duration.zero : wait, () {
      _run(() async {
        // Bu arada oturum bittiyse ya da yenisi başladıysa dokunma.
        if (_session != null && _plannedEnd == end) await _complete(end);
      });
    });
  }

  Future<void> _complete(DateTime now) async {
    final s = _session;
    if (s == null) return;
    final clock = _clock!.advance(now).close(now);
    _clock = clock;
    final focused = clock.focused(now).inSeconds;
    await ref
        .read(focusRepositoryProvider)
        .finish(
          s.id,
          outcome: 'completed',
          focusedSeconds: focused,
          segments: clock.toJson(),
          endedAt: now,
        );
    // Plandaki iş bitti; gerçek başlangıç ve bitişiyle yerinde kalır (D69).
    if (s.planInstanceId case final id?) {
      await ref.read(planRepositoryProvider).markDone(id, s.startedAt, now);
    }
    await _brainEvents(s);
    await _end(s.id, 'completed');
  }

  /// Arama şüphesinde kullanıcı "evet, aramadaydım" dedi.
  Future<void> pardon() => _run(() async {
    if (!_needsPardon) return;
    _needsPardon = false;
    final now = _now();
    await _resolve(_guard.pardon(now));
    await _advance(now);
    await _showOngoing();
    _schedule();
    _emit();
  });

  Future<void> refuse() => _run(() async {
    if (!_needsPardon) return;
    _needsPardon = false;
    await _break(_guard.refuse());
  });

  /// Sonuç ekranı gösterildi.
  void acknowledge() {
    _ended = null;
    _emit();
  }

  /// Faz, duraklatma ya da kural değişti: kaydet, bildirimi ve zamanlayıcıyı tazele.
  Future<void> _changed() async {
    await _syncArm(_now());
    await _saveSegments();
    await _saveRuntime();
    await _showOngoing();
    _schedule();
    _emit();
  }

  // ---------------------------------------------------------------- algılama

  void _onLifecycle(AppLifecycleState s) {
    if (_session == null) return;
    switch (s) {
      case AppLifecycleState.hidden || AppLifecycleState.paused:
        _left(shade: false);
      case AppLifecycleState.resumed:
        _returned();
      case AppLifecycleState.inactive || AppLifecycleState.detached:
        break;
    }
  }

  void _onSignal(FocusSignal signal) {
    if (_session == null) return;
    switch (signal) {
      case FocusSignal.windowFocusLost:
        final prompt = _promptUntil;
        if (prompt == null || !_now().isBefore(prompt)) _left(shade: true);
      case FocusSignal.windowFocusGained:
        _promptUntil = null;
        _returned();
      case FocusSignal.screenOff:
        _guardEvent(() => _guard.screenOff(_now()));
      case FocusSignal.unlocked:
        _guardEvent(() => _guard.unlocked(_now()), later: true);
      case FocusSignal.callActive:
        _guardEvent(() => _guard.callStarted(_now()));
      case FocusSignal.callIdle:
        _guardEvent(() => _guard.callEnded(_now()), later: true);
      case FocusSignal.screenOn:
        break;
    }
  }

  void _onAction(FocusAction action) => switch (action) {
    FocusAction.pause => pause(),
    FocusAction.resume => resume(),
    FocusAction.finish => finish(),
  };

  void _left({required bool shade}) => _run(() async {
    final had = _guard.absence != null;
    _guard.left(_now(), shade: shade);
    if (_guard.absence == null) return; // molada ya da acil durumda serbest
    await _saveRuntime();
    _emit();
    if (!had) _checkLater();
  });

  /// Sayaç başlatan değişiklik (kilit açıldı, arama bitti) hemen uyarı göndermez: çoğu
  /// zaman uygulama hemen öne gelir.
  void _guardEvent(void Function() apply, {bool later = false}) =>
      _run(() async {
        apply();
        await _saveRuntime();
        later ? _checkLater() : _syncAlert();
        _emit();
      });

  /// Çıkıştan 750 ms sonra cihaza sorulur: ekran kapanıyorsa ya da arama varsa uyarı yok.
  void _checkLater() {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 750),
      () => _run(() async {
        if (_guard.absence == null) return;
        try {
          final d = await _platform.deviceState();
          _guard.deviceChecked(
            interactive: d.interactive,
            locked: d.locked,
            inCall: d.inCall,
            audioCall: d.audioCall,
          );
        } on Object catch (e) {
          debugPrint('Odak cihaz durumu: $e');
        }
        await _saveRuntime();
        _syncAlert();
        _emit();
      }),
    );
  }

  void _returned() => _run(() async {
    _debounce?.cancel();
    await _comeBack(_now());
    if (_session != null) {
      await _showOngoing();
      _schedule();
    }
    _emit();
  });

  /// Dönüş ya da açılış: dışarıdayken mola son tarihten önce başladıysa çıkmak
  /// serbestti; sonra 10 sn kuralı değerlendirilir ve geciken faz sınırları işlenir.
  Future<void> _comeBack(DateTime now) async {
    if (_guard.absence?.deadline case final deadline?) {
      final phase = _clock!.advance(deadline).phase;
      if (phase == FocusPhase.onBreak || phase == FocusPhase.breakOver) {
        final r = _guard.disarm(deadline);
        if (r != null) await _record(r);
      }
    }
    final r = _guard.returned(now);
    _syncAlert();
    await _resolve(r);
    if (_session != null) await _advance(now);
  }

  Future<void> _resolve(GuardResult? r) async {
    switch (r) {
      case null:
        break;
      case Recovered(:final record, :final gapTo):
        await _record(record);
        if (gapTo != null) {
          _clock = _clock!.gap(record.leftAt, gapTo);
          await _saveSegments();
        }
      case Broken():
        await _break(r);
        return;
      case NeedsPardon():
        _needsPardon = true;
    }
    await _saveRuntime();
  }

  /// Native uyarıyı guard'ın son tarihiyle eşitler; son tarihte Dart da bozar.
  void _syncAlert() {
    final a = _guard.absence;
    final d = a == null || a.callHint ? null : a.deadline;
    if (d == _alerted) return;
    _alerted = d;
    _deadline?.cancel();
    if (d == null) {
      _safe(_platform.clearEscapeAlert);
      return;
    }
    final l = _l;
    _safe(
      () => _platform.escapeAlert(
        d,
        AlertTexts(
          channelName: l.focusAlertChannel,
          title: l.focusAlertTitle,
          body: l.focusAlertBody,
          brokenTitle: l.focusBrokenTitle,
          brokenBody: l.focusBrokenBody,
        ),
      ),
    );
    final wait = d.difference(_now());
    _deadline = Timer(
      wait.isNegative ? Duration.zero : wait,
      () => _run(() async {
        final b = _guard.check(_now());
        if (b != null) await _break(b);
      }),
    );
  }

  /// Kural yalnız odakta ve normal duraklatmada işler.
  Future<void> _syncArm(DateTime now) async {
    final phase = _clock!.phase;
    final want =
        phase == FocusPhase.working ||
        (phase == FocusPhase.paused && _pause != PauseKind.emergency);
    if (want && !_guard.armed) _guard.arm(now);
    if (!want && _guard.armed) {
      final r = _guard.disarm(now);
      if (r != null) await _record(r);
    }
    _syncPin(want: want);
    await _syncDnd(want: want);
    _syncAlert();
  }

  var _dndOn = false;

  /// Rahatsız Etmeyin (ayarda açıksa) yalnız kural işlerken açık; molada ve acil durumda
  /// telefon serbest olsun diye önceki filtreye döner (D68). Geri yükleme her seferinde
  /// denenir: süreç ölüp açıldığında DND native tarafta açık kalmış olabilir.
  Future<void> _syncDnd({required bool want}) async {
    if (!want) {
      _dndOn = false;
      return _safe(_platform.restoreDnd);
    }
    if (_dndOn || await _prefs.get(PrefsRepository.focusDnd) != '1') return;
    _dndOn = true;
    await _safe(_platform.enableDnd);
  }

  /// Uygulama kural işlerken sabitlenir; molada ve acil durumda çıkmak serbest olsun diye
  /// sabitleme kalkar (D36).
  void _syncPin({required bool want}) {
    if (want == _pinned) return;
    _pinned = want;
    if (want) {
      _promptUntil = _now().add(const Duration(seconds: 30));
      _safe(_platform.pin);
    } else {
      _safe(_platform.unpin);
    }
  }

  // ---------------------------------------------------------------- faz

  void _schedule() {
    _boundary?.cancel();
    final now = _now();
    final at = _clock?.nextBoundary(now);
    // Mola bitişi sistem alarmıyla; "bitti"de dokunulmaz ki yeni gelen uyarı silinmesin.
    switch (_clock?.phase) {
      case FocusPhase.onBreak:
        final l = _l;
        unawaited(
          _safe(
            () => _platform.scheduleBreakOver(
              at!,
              l.focusBreakOverTitle,
              l.focusBreakOverBody,
              channelName: l.focusAlertChannel,
            ),
          ),
        );
      case FocusPhase.breakOver:
        break;
      case _:
        unawaited(_safe(_platform.cancelBreakOver));
    }
    if (at == null) return;
    final wait = at.difference(now);
    _boundary = Timer(
      (wait.isNegative ? Duration.zero : wait) +
          const Duration(milliseconds: 20),
      _onBoundary,
    );
  }

  void _onBoundary() => _run(() async {
    if (_session == null) return;
    final now = _now();
    final broken = _guard.check(now);
    if (broken != null) return _break(broken);
    final before = _clock!;
    await _advance(now);
    // Blok planlı derin çalışma hedefe ulaşınca kendiliğinden tamamlanır (D66).
    if (_clock!.targetReachedAt(now) case final at?) return _complete(at);
    final after = _clock!.phase;
    final l = _l;
    final (title, body) = switch ((before.phase, after)) {
      (FocusPhase.working, FocusPhase.onBreak) => (
        l.focusBreakTitle,
        l.focusBreakBody(_clock!.breakLength(now).inMinutes),
      ),
      (FocusPhase.working, FocusPhase.working)
          when before.settings.mode == FocusMode.deep =>
        (l.focusTargetTitle, l.focusTargetBody(before.settings.target)),
      _ => (null, null),
    };
    if (title != null) {
      await _safe(
        () => _platform.phaseAlert(
          title,
          body!,
          channelName: l.focusAlertChannel,
        ),
      );
    }
    await _showOngoing();
    _schedule();
    _emit();
  });

  Future<void> _advance(DateTime now) async {
    final next = _clock!.advance(now);
    if (listEquals(next.segments, _clock!.segments)) return;
    _clock = next;
    await _syncArm(now);
    await _saveSegments();
    await _saveRuntime();
  }

  // ---------------------------------------------------------------- bitiş

  Future<void> _break(Broken b) async {
    final s = _session;
    if (s == null) return;
    final left = b.record.leftAt;
    final clock = _clock!.advance(left).close(left);
    _clock = clock;
    final focused = clock.focused(b.at).inSeconds;
    await ref
        .read(focusRepositoryProvider)
        .finish(
          s.id,
          outcome: 'broken',
          focusedSeconds: focused,
          segments: clock.toJson(),
          endedAt: b.at,
        );
    await _record(b.record);
    await _brainEvents(s);
    await _end(s.id, 'broken');
  }

  Future<void> _end(String id, String outcome) async {
    _boundary?.cancel();
    _deadline?.cancel();
    _debounce?.cancel();
    _endTimer?.cancel();
    _plannedEnd = null;
    _alerted = null;
    await _safe(_platform.stopOngoing);
    await _safe(_platform.cancelBreakOver);
    _syncPin(want: false);
    await _syncDnd(want: false);
    // Bozulmada native uyarı "Odak bozuldu"ya dönüştü; o bildirim kalır.
    if (outcome != 'broken') await _safe(_platform.clearEscapeAlert);
    _session = null;
    _clock = null;
    _pause = null;
    _guard = EscapeGuard();
    _needsPardon = false;
    _ended = (id: id, outcome: outcome);
    await _prefs.set(PrefsRepository.focusRuntime, null);
    _emit();
  }

  /// Kazanç, bağlantı ya da ceza olayları (D31, D39); oturum kaydedildikten sonra
  /// veritabanındaki oturumdan ve geçmişinden türetilir.
  Future<void> _brainEvents(FocusSession s) =>
      ref.read(brainRepositoryProvider).deriveFor(s.id);

  // ---------------------------------------------------------------- kayıt

  Future<void> _record(Interruption r) => ref
      .read(focusRepositoryProvider)
      .recordInterruption(
        FocusInterruptionsCompanion.insert(
          id: newId(),
          sessionId: _session!.id,
          leftAt: r.leftAt,
          awayMs: r.away.inMilliseconds,
          reason: r.reason.json,
          recovered: r.recovered,
          counted: r.counted,
        ),
      );

  Future<void> _saveSegments() async {
    final s = _session;
    if (s == null) return;
    _session = await ref
        .read(focusRepositoryProvider)
        .updateSegments(s.id, _clock!.toJson());
  }

  Future<void> _saveRuntime() async {
    final s = _session;
    if (s == null) return;
    await _prefs.set(
      PrefsRepository.focusRuntime,
      jsonEncode({
        'session': s.id,
        'pause': _pause?.name,
        'guard': _guard.toJson(),
        'end': _plannedEnd?.toIso8601String(),
      }),
    );
  }

  Future<void> _saveSettings(FocusSettings s) async {
    if (s.mode == FocusMode.free) return;
    final all = await savedFocusSettings(_prefs);
    await _prefs.set(
      PrefsRepository.focusSettings,
      jsonEncode({
        for (final m in all.entries)
          if (m.key != FocusMode.free) m.key.name: m.value.toJson(),
        s.mode.name: s.toJson(),
      }),
    );
  }

  String _today() {
    final d = _now().toLocal();
    return '${d.year}-${d.month}-${d.day}';
  }

  Future<int> _readEmergency() async {
    final v = await _prefs.get(PrefsRepository.focusEmergency);
    final parts = v?.split(':');
    if (parts == null || parts.length != 2 || parts[0] != _today()) return 0;
    return int.tryParse(parts[1]) ?? 0;
  }

  // ---------------------------------------------------------------- bildirim

  Future<void> _showOngoing() async {
    final c = _clock;
    if (c == null) return;
    final l = _l;
    final now = _now();
    final phase = c.phase;
    final body = switch (phase) {
      FocusPhase.working => switch (c.settings.mode) {
        FocusMode.pomodoro => l.focusPhaseCycle(c.cycle),
        FocusMode.deep => l.modeDeep,
        FocusMode.free => l.modeFree,
      },
      FocusPhase.onBreak => l.focusPhaseBreak,
      FocusPhase.breakOver => l.focusPhaseBreakOver,
      FocusPhase.paused =>
        _pause == PauseKind.emergency
            ? l.focusPhaseEmergency
            : l.focusPhasePaused,
    };
    final boundary = c.nextBoundary(now);
    await _safe(
      () => _platform.showOngoing(
        OngoingNotice(
          title: _title,
          body: body,
          channelName: l.focusOngoingChannel,
          pauseLabel: l.focusPause,
          resumeLabel: l.focusResume,
          finishLabel: l.focusFinish,
          countdownTo: boundary,
          countUpFrom: boundary == null && phase == FocusPhase.working
              ? now.subtract(c.focused(now))
              : null,
          paused: phase != FocusPhase.working,
        ),
      ),
    );
  }
}

/// "Bitir"in sonucu (D69).
enum FinishKind {
  /// Hedefsiz oturum ya da hedefe en çok 5 dk kaldı: iş bitti.
  complete,

  /// Molada: yapılan sayılır, kalan bekler.
  remainder,

  /// Odak sürerken hedefe 5 dk'dan çok var: oturum bozulur, beyni beslemez.
  broken,
}

/// Molada bitirilen işin kalanı nerede bekler (D69).
enum RemainderPlace { today, untimed, tomorrow, drop }

/// Son kullanılan Pomodoro / derin çalışma ayarları (cihaza özel).
Future<Map<FocusMode, FocusSettings>> savedFocusSettings(
  PrefsRepository prefs,
) async {
  final raw = await prefs.get(PrefsRepository.focusSettings);
  Map? json;
  try {
    json = raw == null ? null : jsonDecode(raw) as Map?;
  } on FormatException {
    json = null;
  }
  return {
    for (final m in FocusMode.values)
      m: FocusSettings.fromJson(m, (json?[m.name] as Map?)?.cast()),
  };
}
