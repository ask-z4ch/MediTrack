import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/profile/screens/profile_setup_screen.dart';
import '../../features/vitals/screens/vitals_log_screen.dart';
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
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const Center(child: Text('Home - Coming soon'));
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
            return const Center(child: Text('Medicines - Coming soon'));
          },
        ),
        GoRoute(
          path: '/reports',
          builder: (BuildContext context, GoRouterState state) {
            return const Center(child: Text('Reports - Coming soon'));
          },
        ),
      ],
    ),
  ],
);
