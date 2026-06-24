import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/vitals')) return 1;
    if (location.startsWith('/medicines')) return 2;
    if (location.startsWith('/reports')) return 3;
    return 0;
  }

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/vitals');
      case 2:
        context.go('/medicines');
      case 3:
        context.go('/reports');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (int index) => _onTap(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: 'Vitals'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Medicines'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Reports'),
        ],
      ),
    );
  }
}
