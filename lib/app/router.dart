import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../data/local/app_database.dart';
import '../ui/core/app_shell.dart';
import '../ui/features/activity_wizard/activity_wizard_screen.dart';
import '../ui/features/brain/brain_list_screen.dart';
import '../ui/features/brain/brain_screen.dart';
import '../ui/features/brain/region_info.dart';
import '../ui/features/categories/category_tree_screen.dart';
import '../ui/features/categories/move_screen.dart';
import '../ui/features/focus/focus_controller.dart';
import '../ui/features/focus/focus_result_screens.dart';
import '../ui/features/focus/focus_screen.dart';
import '../ui/features/focus/focus_start_screen.dart';
import '../ui/features/onboarding/onboarding_screen.dart';
import '../ui/features/plan/plan_screen.dart';
import '../ui/features/profile/about_screen.dart';
import '../ui/features/profile/profile_screen.dart';
import '../ui/features/project/project_screen.dart';
import '../ui/features/today/today_screen.dart';
import 'providers.dart';
import 'transitions.dart';

final _rootKey = GlobalKey<NavigatorState>();

NoTransitionPage<void> _tab(GoRouterState s, Widget child) =>
    NoTransitionPage(key: s.pageKey, child: child);

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(profileProvider, (_, _) => refresh.value++);
  ref.listen(
    focusControllerProvider.select((s) => (s.active, s.ended)),
    (_, _) => refresh.value++,
  );
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/today',
    refreshListenable: refresh,
    redirect: (context, state) {
      // İlk kurulum bitmeden yalnız kurulum ve onun açtığı ilk iş sihirbazı görünür.
      final profile = ref.read(profileProvider);
      if (profile is! AsyncData<Profile?>) return null;
      final done = profile.value?.onboardingCompletedAt != null;
      final loc = state.matchedLocation;
      if (!done && loc != '/onboarding' && loc != '/add') return '/onboarding';
      if (done && loc == '/onboarding') return '/today';
      // Süren oturum varken tek ekran odaktır; biten oturumun sonucu gösterilir.
      final focus = ref.read(focusControllerProvider);
      if (focus.active) return loc == '/focus' ? null : '/focus';
      if (focus.ended case (:final id, :final outcome)) {
        final to = outcome == 'broken'
            ? '/focus/broken/$id'
            : '/focus/done/$id';
        return loc == to ? null : to;
      }
      if (loc == '/focus') return '/today';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        pageBuilder: (_, s) => _tab(s, const OnboardingScreen()),
      ),
      GoRoute(
        path: '/add',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(s, const ActivityWizardScreen()),
      ),
      GoRoute(
        path: '/project/:id',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(
          s,
          ProjectScreen(activityId: s.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/move/:kind/:id',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(
          s,
          MoveScreen(
            isCategory: s.pathParameters['kind'] == 'category',
            id: s.pathParameters['id']!,
          ),
        ),
      ),
      GoRoute(
        path: '/brain/list',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(s, const BrainListScreen()),
      ),
      GoRoute(
        path: '/brain/categories',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(s, const CategoryTreeScreen()),
      ),
      GoRoute(
        path: '/brain/region/:key',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(
          s,
          RegionScreen(regionKey: s.pathParameters['key']!),
        ),
      ),
      GoRoute(
        path: '/profile/about',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(s, const AboutScreen()),
      ),
      GoRoute(
        path: '/focus',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(s, const FocusScreen()),
      ),
      // Kardeş yollar: odak ekranı bunların altında kurulmasın (immersive açmasın).
      GoRoute(
        path: '/focus/new/:instance',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(
          s,
          FocusStartScreen(instanceId: s.pathParameters['instance']!),
        ),
      ),
      GoRoute(
        path: '/focus/broken/:id',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(
          s,
          FocusBrokenScreen(sessionId: s.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/focus/done/:id',
        parentNavigatorKey: _rootKey,
        pageBuilder: (_, s) => sharedAxisPage(
          s,
          FocusFinishScreen(sessionId: s.pathParameters['id']!),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
                pageBuilder: (_, s) => _tab(s, const TodayScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/plan',
                pageBuilder: (_, s) => _tab(s, const PlanScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/brain',
                pageBuilder: (_, s) => _tab(s, const BrainScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (_, s) => _tab(s, const ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
