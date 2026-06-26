import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/charts/screens/charts_screen.dart';
import '../../features/doctor_visits/screens/add_doctor_visit_screen.dart';
import '../../features/doctor_visits/screens/doctor_visit_list_screen.dart';
import '../../features/doctor_visits/screens/prescription_viewer_screen.dart';
import '../../features/medicines/screens/add_medicine_screen.dart';
import '../../features/reports/screens/report_generator_screen.dart';
import '../../features/medicines/screens/medicine_list_screen.dart';
import '../../features/profile/screens/profile_setup_screen.dart';
import '../../features/sos/screens/emergency_contact_setup_screen.dart';
import '../../features/vitals/screens/vitals_log_screen.dart';
import '../../home/screens/home_page.dart';
import '../../home/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final hasProfile = prefs.getBool('has_completed_profile') ?? false;
    final isOnProfileSetup = state.matchedLocation == '/profile-setup';

    if (!hasProfile && !isOnProfileSetup) return '/profile-setup';
    if (hasProfile && isOnProfileSetup) return '/';
    return null;
  },
  routes: [
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
      builder: (context, state) => const EmergencyContactSetupScreen(),
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
