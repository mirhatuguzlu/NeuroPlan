import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/next_up.dart';
import '../../../app/notifications.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/prefs_repository.dart';
import '../../../data/repositories/sleep_window.dart';
import '../../core/format.dart';
import '../../core/location.dart';
import '../../core/prayer_fields.dart';
import '../../core/states.dart';
import '../../core/theme_choice.dart';
import '../../core/wizard.dart';
import '../together/together_screen.dart' show BirthYearField, minAgeOf;

/// İlk kurulum: dil → yaş → görünüm → uyku → konum → namaz vakitleri → kök kategoriler →
/// bildirim izni → ilk rutin. Her adım ayrı ekrandır, atlanabilir ve sonucunu hemen kaydeder.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _locale;
  var _mode = 'system';
  String? _theme;
  var _bed = 23 * 60;
  var _wake = 7 * 60;
  LocateResult? _located;
  var _locating = false;
  String? _method;
  var _madhab = 'shafi';
  int? _birthYear;
  var _birthYearSaved = false;
  bool? _notify;

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileProvider).value;
    _birthYear = p?.birthYear;
    _birthYearSaved = p?.birthYear != null;
    _locale = p?.locale;
    _mode = p?.themeMode ?? 'system';
    _theme = p?.theme;
    _method = p?.prayerMethod;
    _madhab = p?.prayerMadhab ?? 'shafi';
    if (p?.locationLat != null) _located = LocateResult.saved;
  }

  Future<void> _update(ProfilesCompanion c) =>
      ref.read(profileRepositoryProvider).update(c);

  Future<void> _saveSleep() async {
    final data = await ref.read(planDataProvider.future);
    if (data == null || !mounted) return;
    await SleepWindow.save(
      db: ref.read(databaseProvider),
      activities: ref.read(activityRepositoryProvider),
      existing: SleepWindow.find(data),
      title: context.l10n.sleepActivityTitle,
      today: data.calendar
          .dayOf(DateTime.now().millisecondsSinceEpoch ~/ 60000)
          .iso,
      bed: _bed,
      wake: _wake,
    );
  }

  /// İzin verilince sıradaki iş bildirimi de açılır (kapalıysa 10 dk önce).
  Future<void> _allowNotifications() async {
    final granted = await ref.read(notificationsProvider).request();
    if (granted && ref.read(notifyLeadProvider).value == null) {
      await ref
          .read(prefsRepositoryProvider)
          .set(PrefsRepository.notifyLead, '10');
    }
    if (mounted) setState(() => _notify = granted);
  }

  Future<void> _complete({required bool addFirst}) async {
    final router = ref.read(routerProvider);
    await _update(
      ProfilesCompanion(onboardingCompletedAt: Value(DateTime.now().toUtc())),
    );
    router.go('/today');
    if (addFirst) router.push('/add');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hasLocation = _located == LocateResult.saved;
    return WizardScaffold(
      onFinish: () async {},
      steps: [
        WizardStep(
          id: 'lang',
          title: l.onbLanguageTitle,
          optional: true,
          body: ChoiceList<String?>(
            value: _locale,
            options: [
              (null, l.langSystem, null),
              ('tr', l.langTurkish, null),
              ('en', l.langEnglish, null),
            ],
            onChanged: (v) {
              setState(() => _locale = v);
              _update(ProfilesCompanion(locale: Value(v)));
            },
          ),
        ),
        // AUTH-2: 13 yaş altı devam edemez; yalnız doğum yılı tutulur, en düşük olası yaş
        // kullanılır. Kaydedilen yıl sonradan küçültülemez (sunucu da reddeder).
        WizardStep(
          id: 'age',
          title: l.onbAgeTitle,
          subtitle: l.onbAgeBody,
          canNext: _birthYear != null && minAgeOf(_birthYear!) >= 13,
          onNext: _birthYearSaved
              ? null
              : () async {
                  await _update(
                    ProfilesCompanion(birthYear: Value(_birthYear)),
                  );
                  _birthYearSaved = true;
                },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_birthYearSaved)
                Text('', style: Theme.of(context).textTheme.headlineSmall)
              else
                BirthYearField(
                  value: _birthYear,
                  onChanged: (v) => setState(() => _birthYear = v),
                ),
              if (_birthYear != null && minAgeOf(_birthYear!) < 13) ...[
                const SizedBox(height: Gap.l),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    l.onbAgeTooYoung,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        WizardStep(
          id: 'mode',
          title: l.onbAppearanceTitle,
          subtitle: l.onbAppearanceBody,
          optional: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ChoiceList<String>(
                value: _mode,
                options: [
                  ('system', l.modeSystem, null),
                  ('light', l.modeLight, null),
                  ('dark', l.modeDark, null),
                ],
                onChanged: (v) {
                  setState(() => _mode = v);
                  _update(ProfilesCompanion(themeMode: Value(v)));
                },
              ),
              const Divider(height: Gap.xl),
              Text(
                l.settingTheme,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              ThemeChoice(
                value: _theme,
                onChanged: (v) {
                  setState(() => _theme = v);
                  _update(ProfilesCompanion(theme: Value(v)));
                },
              ),
            ],
          ),
        ),
        WizardStep(
          id: 'sleep',
          title: l.onbSleepTitle,
          subtitle: l.onbSleepBody,
          optional: true,
          onNext: _saveSleep,
          body: Column(
            children: [
              TimeTile(
                label: l.sleepBedtime,
                minuteOfDay: _bed,
                onChanged: (v) => setState(() => _bed = v),
              ),
              TimeTile(
                label: l.sleepWake,
                minuteOfDay: _wake,
                onChanged: (v) => setState(() => _wake = v),
              ),
            ],
          ),
        ),
        WizardStep(
          id: 'location',
          title: l.onbLocationTitle,
          subtitle: l.onbLocationBody,
          optional: !hasLocation,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BusyButton(
                tonal: true,
                label: l.locationAllow,
                onPressed: _locating
                    ? null
                    : () async {
                        setState(() => _locating = true);
                        final r = await locateAndSave(
                          ref.read(profileRepositoryProvider),
                        );
                        if (mounted) {
                          setState(() {
                            _locating = false;
                            _located = r;
                          });
                        }
                      },
              ),
              if (_located != null) ...[
                const SizedBox(height: Gap.l),
                Semantics(
                  liveRegion: true,
                  child: Row(
                    children: [
                      Icon(
                        hasLocation
                            ? Symbols.check_circle_rounded
                            : Symbols.warning_rounded,
                        color: hasLocation
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: Gap.s),
                      Expanded(
                        child: Text(switch (_located!) {
                          LocateResult.saved => l.locationSaved,
                          LocateResult.denied => l.locationDenied,
                          LocateResult.failed => l.locationError,
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        WizardStep(
          id: 'prayer',
          title: l.onbPrayerTitle,
          subtitle: l.onbPrayerBody,
          optional: true,
          onNext: () => _update(
            ProfilesCompanion(
              prayerMethod: Value(_method),
              prayerMadhab: Value(_method == null ? null : _madhab),
            ),
          ),
          body: PrayerFields(
            method: _method,
            madhab: _madhab,
            hasLocation: hasLocation,
            onChanged: (m, h) => setState(() {
              _method = m;
              _madhab = h;
            }),
          ),
        ),
        WizardStep(
          id: 'roots',
          title: l.onbCategoriesTitle,
          subtitle: l.onbCategoriesBody,
          optional: true,
          body: const _RootList(),
        ),
        WizardStep(
          id: 'notify',
          title: l.onbNotifyTitle,
          subtitle: l.onbNotifyBody,
          optional: _notify != true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BusyButton(
                tonal: true,
                label: l.notifyAllow,
                onPressed: _notify == true ? null : _allowNotifications,
              ),
              if (_notify != null) ...[
                const SizedBox(height: Gap.l),
                Semantics(
                  liveRegion: true,
                  child: Row(
                    children: [
                      Icon(
                        _notify!
                            ? Symbols.check_circle_rounded
                            : Symbols.warning_rounded,
                        color: _notify!
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: Gap.s),
                      Expanded(
                        child: Text(
                          _notify! ? l.notifyGranted : l.notifPermissionDenied,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        WizardStep(
          id: 'first',
          title: l.onbFirstTitle,
          subtitle: l.onbFirstBody,
          optional: true,
          nextLabel: l.onbFirstAction,
          onNext: () => _complete(addFirst: true),
          onSkip: () => _complete(addFirst: false),
          body: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _RootList extends ConsumerWidget {
  const _RootList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roots = ref.watch(rootCategoriesProvider);
    return AsyncView(
      value: roots,
      onRetry: () => ref.invalidate(rootCategoriesProvider),
      data: (list) => Column(
        children: [
          for (final r in list)
            MergeSemantics(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: RootBadge(icon: r.icon, color: r.color),
                title: Text(r.name(context)),
                subtitle: Text(r.description(context)),
              ),
            ),
        ],
      ),
    );
  }
}
