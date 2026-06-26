import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/charts/screens/charts_screen.dart';
import '../../features/doctor_visits/screens/add_doctor_visit_screen.dart';
import '../../features/doctor_visits/screens/doctor_visit_list_screen.dart';
import '../../features/doctor_visits/screens/prescription_viewer_screen.dart';
import '../../features/medicines/screens/add_medicine_screen.dart';
import '../../features/medicines/screens/medicine_list_screen.dart';
import '../../features/profile/screens/profile_setup_screen.dart';
import '../../features/reports/screens/report_generator_screen.dart';
import '../../features/sos/screens/emergency_contact_screen.dart';
import '../../features/vitals/screens/vitals_log_screen.dart';
import '../../home/screens/home_page.dart';
import '../../home/screens/home_screen.dart';
import '../../onboarding/screens/onboarding_screen.dart';
import '../../settings/screens/settings_screen.dart';

final topLevelNavigatorKey = GlobalKey<NavigatorState>();

class AuthNotifier extends ChangeNotifier {
  bool _authenticated = AuthService.currentUser != null;
  bool get authenticated => _authenticated;

  void check() {
    final newVal = AuthService.currentUser != null;
    if (newVal != _authenticated) {
      _authenticated = newVal;
      notifyListeners();
    }
  }
}

final authNotifier = AuthNotifier();

final GoRouter appRouter = GoRouter(
  navigatorKey: topLevelNavigatorKey,
  refreshListenable: authNotifier,
  initialLocation: '/',
  redirect: (context, state) async {
    final location = state.matchedLocation;
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    final isOnOnboarding = location == '/onboarding';

    if (!hasSeenOnboarding && !isOnOnboarding) return '/onboarding';
    if (hasSeenOnboarding && isOnOnboarding) return '/login';

    final authenticated = AuthService.currentUser != null;
    final isOnLogin = location == '/login';

    if (!authenticated && !isOnLogin) return '/login';
    if (authenticated && isOnLogin) return '/';

    if (authenticated) {
      final hasProfile = prefs.getBool('has_completed_profile') ?? false;
      final isOnProfileSetup = location == '/profile-setup';

      if (!hasProfile && !isOnProfileSetup) return '/profile-setup';
      if (hasProfile && isOnProfileSetup) return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/add-medicine',
      builder: (context, state) => const AddMedicineScreen(),
    ),
    GoRoute(
      path: '/emergency-contact',
      builder: (context, state) => const EmergencyContactScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/add-doctor-visit',
      builder: (context, state) => const AddDoctorVisitScreen(),
    ),
    GoRoute(
      path: '/doctor-visits',
      builder: (context, state) => const DoctorVisitListScreen(),
    ),
    GoRoute(
      path: '/generate-report',
      builder: (context, state) => const ReportGeneratorScreen(),
    ),
    GoRoute(
      path: '/prescription-viewer',
      pageBuilder: (context, state) {
        final paths = state.extra as List<String>;
        return CustomTransitionPage(
          key: state.pageKey,
          child: PrescriptionViewerScreen(prescriptionPaths: paths),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/vitals',
          builder: (BuildContext context, GoRouterState state) {
            return const VitalsLogScreen();
          },
        ),
        GoRoute(
          path: '/medicines',
          builder: (BuildContext context, GoRouterState state) {
            return const MedicineListScreen();
          },
        ),
        GoRoute(
          path: '/reports',
          builder: (BuildContext context, GoRouterState state) {
            return const ChartsScreen();
          },
        ),
      ],
    ),
  ],
);
