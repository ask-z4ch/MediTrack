import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../home/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
            return const Center(child: Text('Vitals - Coming soon'));
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
