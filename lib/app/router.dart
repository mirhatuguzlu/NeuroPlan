import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../data/local/app_database.dart';
import '../ui/core/app_shell.dart';
import '../ui/features/activity_wizard/activity_wizard_screen.dart';
import '../ui/features/categories/category_tree_screen.dart';
import '../ui/features/categories/move_screen.dart';
import '../ui/features/onboarding/onboarding_screen.dart';
import '../ui/features/plan/plan_screen.dart';
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
                pageBuilder: (_, s) => _tab(s, const CategoryTreeScreen()),
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
