import 'dart:convert';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/app/focus_platform.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/repositories/prefs_repository.dart';
import 'package:neuroplan/ui/features/focus/focus_controller.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../data/test_support.dart';
import '../support/fake_focus_platform.dart';

final t0 = DateTime.utc(2026, 11, 19, 9);

/// Bellek içi veritabanı + sahte cihaz + elle ilerleyen saat. Denetleyici gerçek
/// zamanlayıcı kullanır; 10 sn ve faz sınırları saat ileri alınıp dönüşte değerlendirilir.
class Rig {
  Rig._();

  static Future<Rig> create() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final rig = Rig._();
    await rig._open();
    return rig;
  }

  final db = AppDatabase(NativeDatabase.memory(), systemData: systemData);
  var platform = FakeFocusPlatform();
  late ProviderContainer container;
  DateTime now = t0;

  Future<void> _open() async {
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        focusPlatformProvider.overrideWithValue(platform),
        focusNowProvider.overrideWithValue(() => now),
      ],
    );
    container.listen(focusControllerProvider, (_, _) {});
    await settle(300); // açılışta kurtarma
  }

  /// Süreç öldü: bellekteki her şey gider, veritabanı ve tercihler kalır; [at]'te açılır.
  Future<void> reopen(DateTime at) async {
    container.dispose();
    platform = FakeFocusPlatform();
    now = at;
    await _open();
  }

  FocusController get c => container.read(focusControllerProvider.notifier);
  FocusState get s => container.read(focusControllerProvider);
  PrefsRepository get prefs => container.read(prefsRepositoryProvider);

  /// Olay kuyruğu ve 750 ms cihaz sorgusu biter.
  Future<void> settle([int ms = 30]) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  void lifecycle(AppLifecycleState state) =>
      WidgetsBinding.instance.handleAppLifecycleStateChanged(state);

  Future<void> leave() async {
    lifecycle(AppLifecycleState.inactive);
    lifecycle(AppLifecycleState.hidden);
    await settle(900);
  }

  Future<void> back() async {
    lifecycle(AppLifecycleState.inactive);
    lifecycle(AppLifecycleState.resumed);
    await settle();
  }

  Future<PlannedInstance> activityInstance() async {
    final a = await container
        .read(activityRepositoryProvider)
        .create(
          ActivitiesCompanion.insert(
            id: newId(),
            kind: 'task',
            title: 'Matematik',
            rootCategoryKey: const Value('planning_problem_solving'),
          ),
        );
    return PlannedInstance(
      id: newId(),
      activityId: a.id,
      date: '2026-11-19',
      status: InstanceStatus.planned,
      source: InstanceSource.rule,
      flexibility: Flexibility.shiftable,
    );
  }

  Future<void> start(FocusSettings settings) async =>
      c.start(instance: await activityInstance(), settings: settings);

  Future<FocusSession> session(String id) async =>
      (await container.read(focusRepositoryProvider).find(id))!;

  Future<List<FocusInterruption>> interruptions() =>
      db.select(db.focusInterruptions).get();

  Future<void> dispose() async {
    container.dispose();
    await db.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Rig r;

  setUp(() async {
    WidgetsBinding.instance.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    r = await Rig.create();
  });
  tearDown(() => r.dispose());

  test('başlatma: segment açılır, kalıcı bildirim ve DND', () async {
    r.platform.dndAccess = true;
    await r.prefs.set(PrefsRepository.focusDnd, '1');
    await r.start(const FocusSettings(FocusMode.pomodoro));
    expect(r.s.active, isTrue);
    expect(r.s.clock!.phase, FocusPhase.working);
    expect(
      r.platform.ongoing?.countdownTo,
      t0.add(const Duration(minutes: 25)),
    );
    expect(r.platform.dndOn, isTrue);
    final row = await r.session(r.s.session!.id);
    expect(row.segments, hasLength(1));
    expect(row.rootCategoryKey, 'planning_problem_solving');
  });

  test(
    '10 sn içinde dönüş: kesinti, süre odaktan düşülür, uyarı kalkar',
    () async {
      await r.start(const FocusSettings(FocusMode.free));
      r.now = t0.add(const Duration(minutes: 5));
      await r.leave();
      expect(r.platform.alertDeadline, r.now.add(escapeGrace));
      r.now = r.now.add(const Duration(seconds: 4));
      await r.back();
      expect(r.platform.alertDeadline, isNull);
      expect(r.s.active, isTrue);
      final i = (await r.interruptions()).single;
      expect((i.reason, i.recovered, i.counted), ('app_left', true, true));
      expect(r.s.clock!.focused(r.now), const Duration(minutes: 5));
    },
  );

  test(
    '10 sn geçince bozulur: ceza olayları, bildirim ve DND kapanır',
    () async {
      r.platform.dndAccess = true;
      await r.prefs.set(PrefsRepository.focusDnd, '1');
      await r.start(const FocusSettings(FocusMode.free));
      r.now = t0.add(const Duration(minutes: 12));
      await r.leave();
      r.now = r.now.add(const Duration(seconds: 30));
      await r.back();
      expect(r.s.active, isFalse);
      expect(r.s.ended?.outcome, 'broken');
      final s = await r.session(r.s.ended!.id);
      expect(s.outcome, 'broken');
      expect(s.focusedSeconds, 12 * 60);
      expect(s.endedAt, t0.add(const Duration(minutes: 12, seconds: 10)));
      final events = await r.db.select(r.db.brainEvents).get();
      expect(events.map((e) => e.type).toSet(), {'penalty'});
      expect(events.fold(0, (a, e) => a + e.amount), 12 * 1000);
      expect(r.platform.ongoing, isNull);
      expect(r.platform.dndOn, isFalse);
    },
  );

  test('ekran kapandı: kaçış değil, odak süresi işler', () async {
    await r.start(const FocusSettings(FocusMode.free));
    r.platform.device = const DeviceState(interactive: false);
    await r.leave();
    expect(r.platform.alertDeadline, isNull);
    r.now = t0.add(const Duration(minutes: 30));
    await r.back();
    expect(r.s.active, isTrue);
    expect(r.s.clock!.focused(r.now), const Duration(minutes: 30));
    expect((await r.interruptions()).single.counted, isFalse);
  });

  test('izinli arama: cezasız; arama süresi odaktan düşülür', () async {
    await r.start(const FocusSettings(FocusMode.free));
    r.platform.signalsCtl.add(FocusSignal.callActive);
    await r.settle();
    r.now = t0.add(const Duration(minutes: 1));
    await r.leave();
    r.now = t0.add(const Duration(minutes: 6));
    r.platform.signalsCtl.add(FocusSignal.callIdle);
    await r.settle();
    r.now = r.now.add(const Duration(seconds: 3));
    await r.back();
    expect(r.s.active, isTrue);
    final i = (await r.interruptions()).single;
    expect((i.reason, i.counted), ('phone_call', false));
    expect(r.s.clock!.focused(r.now), const Duration(minutes: 1));
  });

  test(
    'izinsiz arama şüphesi: dönüşte sorulur, kabul edilirse sürer',
    () async {
      await r.start(const FocusSettings(FocusMode.free));
      r.platform.device = const DeviceState(audioCall: true);
      await r.leave();
      expect(r.platform.alertDeadline, isNull, reason: 'aramada uyarı çalmaz');
      r.now = t0.add(const Duration(minutes: 4));
      await r.back();
      expect(r.s.needsPardon, isTrue);
      await r.c.pardon();
      expect(r.s.active, isTrue);
      expect(r.s.needsPardon, isFalse);
    },
  );

  test(
    'Pomodoro: mola başlayınca çıkmak serbest, mola bitince bekler',
    () async {
      await r.start(const FocusSettings(FocusMode.pomodoro, work: 1, rest: 5));
      r.now = t0.add(const Duration(seconds: 90));
      await r.back(); // geciken zamanlayıcı dönüşte yetişir
      expect(r.s.clock!.phase, FocusPhase.onBreak);
      await r.leave();
      expect(r.platform.alertDeadline, isNull);
      r.now = t0.add(const Duration(minutes: 20));
      await r.back();
      expect(r.s.active, isTrue);
      expect(r.s.clock!.phase, FocusPhase.breakOver);
      expect(await r.interruptions(), isEmpty);
      await r.c.resume();
      expect(r.s.clock!.phase, FocusPhase.working);
      expect(r.s.clock!.focused(r.now), const Duration(minutes: 1));
    },
  );

  test('acil durumda çıkmak serbest; günde 3 kez', () async {
    await r.start(const FocusSettings(FocusMode.free));
    expect(await r.c.emergency(), isTrue);
    await r.leave();
    expect(r.platform.alertDeadline, isNull);
    r.now = t0.add(const Duration(hours: 1));
    await r.back();
    expect(r.s.active, isTrue);
    await r.c.resume();
    for (var i = 0; i < 2; i++) {
      expect(await r.c.emergency(), isTrue);
      await r.c.resume();
    }
    expect(await r.c.emergency(), isFalse);
    expect(r.s.emergencyLeft, 0);
  });

  test('normal duraklatmada kural sürer', () async {
    await r.start(const FocusSettings(FocusMode.free));
    await r.c.pause();
    await r.leave();
    expect(r.platform.alertDeadline, isNotNull);
  });

  group('uygulama sabitleme (D36)', () {
    test(
      'odakta sabitli; molada ve acil durumda kalkar; bitince kalkar',
      () async {
        await r.start(const FocusSettings(FocusMode.deep));
        expect(r.platform.pinned, isTrue);
        await r.c.pause();
        expect(
          r.platform.pinned,
          isTrue,
          reason: 'normal duraklatma kuralı korur',
        );
        await r.c.resume();
        await r.c.takeBreak();
        expect(r.platform.pinned, isFalse, reason: 'molada çıkmak serbest');
        await r.c.resume();
        expect(r.platform.pinned, isTrue);
        await r.c.emergency();
        expect(
          r.platform.pinned,
          isFalse,
          reason: 'acil durumda çıkmak serbest',
        );
        await r.c.resume();
        await r.c.finish();
        expect(r.platform.pinned, isFalse);
      },
    );

    test('molada "mola bitti" uyarısı mola sonuna kurulur; erken dönüş ve bitiş siler', () async {
      await r.start(const FocusSettings(FocusMode.deep));
      expect(r.platform.breakOverAt, isNull);
      await r.c.takeBreak();
      await r.settle();
      expect(r.platform.breakOverAt, r.s.clock!.nextBoundary(r.now));
      await r.c.resume();
      await r.settle();
      expect(r.platform.breakOverAt, isNull);
      await r.c.takeBreak();
      await r.settle();
      expect(r.platform.breakOverAt, isNotNull);
      await r.c.finish();
      expect(r.platform.breakOverAt, isNull);
    });

    test('sabitleme onayı pencere odağını alır; kaçış sayılmaz', () async {
      await r.start(const FocusSettings(FocusMode.free));
      r.platform.signalsCtl.add(FocusSignal.windowFocusLost);
      await r.settle(900);
      expect(r.s.absence, isNull);
      expect(r.platform.alertDeadline, isNull);
      r.platform.signalsCtl.add(FocusSignal.windowFocusGained);
      await r.settle();
      // Onaydan sonra panel çekmek (sabitleme kaldırıldıysa) yine kaçıştır.
      r.platform.signalsCtl.add(FocusSignal.windowFocusLost);
      await r.settle(900);
      expect(r.s.absence?.reason, AwayReason.notificationShade);
    });

    test('sabitlemeden PIN ile çıkış (kilit ekranı) kaçış değil', () async {
      await r.start(const FocusSettings(FocusMode.free));
      r.platform.signalsCtl.add(FocusSignal.windowFocusGained); // onay kapandı
      r.platform.device = const DeviceState(locked: true);
      await r.leave();
      expect(r.platform.alertDeadline, isNull);
      r.now = t0.add(const Duration(minutes: 2));
      r.platform.signalsCtl.add(FocusSignal.unlocked);
      await r.back();
      expect(r.s.active, isTrue);
    });

    test('açılışta oturum sürüyorsa yeniden sabitlenir', () async {
      await r.start(const FocusSettings(FocusMode.free));
      await r.reopen(t0.add(const Duration(seconds: 5)));
      expect(r.platform.pinned, isTrue);
    });
  });

  group('uygulama yeniden açılınca kurtarma', () {
    test('süren oturum kaldığı yerden devam eder', () async {
      await r.start(const FocusSettings(FocusMode.free));
      final id = r.s.session!.id;
      await r.c.pause();
      r.now = t0.add(const Duration(minutes: 3));
      await r.c.resume();
      await r.reopen(t0.add(const Duration(minutes: 10)));
      expect(r.s.session?.id, id);
      expect(r.s.clock!.focused(r.now), const Duration(minutes: 7));
      expect(r.platform.ongoing, isNotNull, reason: 'kalıcı bildirim yeniden');
    });

    test('çıkıp dönmeden öldüyse açılışta bozulur', () async {
      await r.start(const FocusSettings(FocusMode.free));
      final id = r.s.session!.id;
      r.now = t0.add(const Duration(minutes: 8));
      await r.leave();
      await r.reopen(t0.add(const Duration(minutes: 30)));
      expect(r.s.active, isFalse);
      expect(r.s.ended, (id: id, outcome: 'broken'));
      expect((await r.session(id)).focusedSeconds, 8 * 60);
    });

    test('ekran kapalıyken öldüyse sürer', () async {
      await r.start(const FocusSettings(FocusMode.free));
      r.platform.device = const DeviceState(interactive: false);
      await r.leave();
      await r.reopen(t0.add(const Duration(minutes: 45)));
      expect(r.s.active, isTrue);
      expect(r.s.clock!.focused(r.now), const Duration(minutes: 45));
    });

    test('Pomodoro: saatler sonra açılışta mola bitmiş, bekliyor', () async {
      await r.start(const FocusSettings(FocusMode.pomodoro));
      await r.reopen(t0.add(const Duration(hours: 3)));
      expect(r.s.active, isTrue);
      expect(r.s.clock!.phase, FocusPhase.breakOver);
      expect(r.s.clock!.focused(r.now), const Duration(minutes: 25));
    });

    test('çıkış son tarihten önce mola başladıysa bozulmaz', () async {
      await r.start(const FocusSettings(FocusMode.pomodoro));
      r.now = t0.add(const Duration(minutes: 24, seconds: 55));
      await r.leave();
      await r.reopen(t0.add(const Duration(minutes: 28)));
      expect(r.s.active, isTrue);
      expect(r.s.clock!.phase, FocusPhase.onBreak);
    });
  });
  test('bitir: kazanç olayları, sonuç ekranına geçilir', () async {
    await r.start(const FocusSettings(FocusMode.deep));
    r.now = t0.add(const Duration(minutes: 40));
    await r.c.finish();
    expect(r.s.ended?.outcome, 'completed');
    final events = await r.db.select(r.db.brainEvents).get();
    // Derin çalışma: kazanç + en uzun kesintisiz süreye göre bağlantı (D39).
    expect(events.map((e) => e.type).toSet(), {
      'neuron_gain',
      'connection_gain',
    });
    final gain = events.where((e) => e.type == 'neuron_gain');
    expect(gain.fold(0, (a, e) => a + e.amount), 40 * 1000);
    expect(
      jsonDecode((await r.prefs.get(PrefsRepository.focusRuntime)) ?? 'null'),
      isNull,
    );
  });

  group('planlanan bitiş (D63)', () {
    final m0 = t0.millisecondsSinceEpoch ~/ 60000;
    Future<PlannedInstance> timed({int minutes = 30}) async {
      final i = await r.activityInstance();
      return PlannedInstance(
        id: i.id,
        activityId: i.activityId,
        date: i.date,
        status: i.status,
        source: i.source,
        flexibility: i.flexibility,
        start: m0,
        end: m0 + minutes,
      );
    }

    final end = t0.add(const Duration(minutes: 30));

    test('bitiş saatinde kendiliğinden tamamlanır', () async {
      r.now = end.subtract(const Duration(milliseconds: 200));
      await r.c.start(
        instance: await timed(),
        settings: const FocusSettings(FocusMode.pomodoro),
      );
      expect(r.s.active, isTrue);
      await r.settle(500);
      expect(r.s.ended?.outcome, 'completed');
      final row = await r.session(r.s.ended!.id);
      expect(row.endedAt, end);
    });

    test(
      'uygulama kapalıyken bitiş geçtiyse açılışta bitişte tamamlanır',
      () async {
        await r.c.start(
          instance: await timed(),
          settings: const FocusSettings(FocusMode.deep),
        );
        final id = r.s.session!.id;
        await r.reopen(t0.add(const Duration(minutes: 50)));
        expect(r.s.active, isFalse);
        expect(r.s.ended?.outcome, 'completed');
        final row = await r.session(id);
        expect(row.endedAt, end);
        expect(row.focusedSeconds, 30 * 60);
      },
    );

    test(
      'kendi süresi kadar: başlangıçtan o kadar sonra biter, hedef o olur',
      () async {
        await r.prefs.set(PrefsRepository.autoRun, '0');
        await r.c.start(
          instance: await timed(),
          settings: const FocusSettings(FocusMode.deep),
          ownMinutes: 5,
        );
        final id = r.s.session!.id;
        expect(r.s.clock!.settings.target, 5);
        await r.reopen(t0.add(const Duration(minutes: 20)));
        expect(r.s.ended?.outcome, 'completed');
        final row = await r.session(id);
        expect(row.endedAt, t0.add(const Duration(minutes: 5)));
        // Kayıtlı derin çalışma hedefi bir işin süresiyle ezilmez.
        final saved = await savedFocusSettings(r.prefs);
        expect(saved[FocusMode.deep]!.target, 90);
        await r.prefs.set(PrefsRepository.autoRun, null);
      },
    );

    test('anahtar kapalıysa, süresiz işte ya da ortak odakta bitmez', () async {
      await r.prefs.set(PrefsRepository.autoRun, '0');
      await r.c.start(
        instance: await timed(),
        settings: const FocusSettings(FocusMode.free),
      );
      await r.reopen(t0.add(const Duration(minutes: 50)));
      expect(r.s.active, isTrue);
      await r.c.finish();
      await r.prefs.set(PrefsRepository.autoRun, null);
      await r.c.start(
        instance: await timed(minutes: 0),
        settings: const FocusSettings(FocusMode.free),
      );
      await r.reopen(t0.add(const Duration(hours: 2)));
      expect(r.s.active, isTrue);
      await r.c.finish();
      r.now = t0;
      await r.c.start(
        instance: await timed(),
        settings: const FocusSettings(FocusMode.free),
        startAt: t0,
      );
      await r.reopen(t0.add(const Duration(minutes: 50)));
      expect(r.s.active, isTrue);
    });
  });
}
