import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user/auth_provider.dart';

import 'router_notifier.dart';
import '../../core/utils/role_helper.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/joueur/joueur_home_screen.dart';
import '../../screens/coach/coach_home_screen.dart';
import '../../screens/prep_physique/prep_home_screen.dart';
import '../../screens/medical/medical_home_screen.dart';
import '../../screens/admin/admin_home_screen.dart';

const String routeLogin = '/login';
const String routeAdminDashboard = '/admin/home';
const String routeCoachDashboard = '/coach/home';
const String routePrepDashboard = '/prep/home';
const String routeMedicalDashboard = '/medical/home';
const String routeJoueurDashboard = '/joueur/home';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: homeRouteForRole(authState.role),

    refreshListenable: notifier,
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final role = authState.role;
      final isOnLogin = state.matchedLocation == routeLogin;

      if (!isLoggedIn) return isOnLogin ? null : routeLogin;

      if (isLoggedIn && role != null) {
        return homeRouteForRole(role);
      }

      return null;
    },

    routes: [
      GoRoute(
        path: routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: routeAdminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: routeCoachDashboard,
        builder: (context, state) => const CoachDashboardScreen(),
      ),
      GoRoute(
        path: routePrepDashboard,
        builder: (context, state) => const PrepDashboardScreen(),
      ),
      GoRoute(
        path: routeMedicalDashboard,
        builder: (context, state) => const MedicalDashboardScreen(),
      ),
      GoRoute(
        path: routeJoueurDashboard,
        builder: (context, state) => const JoueurDashboardScreen(),
      ),
    ],
  );
});

String homeRouteForRole(UserRole? role) {
  switch (role) {
    case UserRole.coach:
      return routeCoachDashboard;
    case UserRole.prep:
      return routePrepDashboard;
    case UserRole.medical:
      return routeMedicalDashboard;
    case UserRole.joueur:
      return routeJoueurDashboard;
    case UserRole.admin:
      return routeAdminDashboard;
    default:
      return routeLogin;
  }
}
