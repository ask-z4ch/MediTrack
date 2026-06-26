import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (!mounted) return;
    context.go('/profile-setup');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  children: [
                    _Page(
                      illustration: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.monitor_heart_outlined, size: 56, color: AppColors.primary),
                      ),
                      headline: 'Your health diary, always with you.',
                      body: 'Log your blood pressure, blood sugar, temperature, and more — with reminders that work even offline.',
                    ),
                    _Page(
                      illustration: Lottie.asset(
                        'assets/lottie/vita_thriving.json',
                        width: 120,
                        height: 120,
                      ),
                      headline: 'VITA grows with your health.',
                      body: 'Your companion reflects your real health data — not just your mood. Log consistently, and watch VITA thrive.',
                    ),
                    _Page(
                      illustration: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.lock_outline, size: 56, color: AppColors.primary),
                      ),
                      headline: 'Your data stays yours.',
                      body: 'Everything is stored on your device first. Cloud sync is optional and end-to-end authenticated.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    if (_page < 2)
                      TextButton(
                        onPressed: _finish,
                        child: const Text('Skip'),
                      )
                    else
                      const SizedBox(width: 0),
                    const Spacer(),
                    Row(
                      children: List.generate(3, (i) => _dot(i)),
                    ),
                    const Spacer(),
                    if (_page < 2)
                      FilledButton(
                        onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                        child: const Text('Next'),
                      )
                    else
                      FilledButton(
                        onPressed: _finish,
                        child: const Text('Get Started'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(int index) {
    final isActive = index == _page;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final Widget illustration;
  final String headline;
  final String body;

  const _Page({
    required this.illustration,
    required this.headline,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          illustration,
          const SizedBox(height: 32),
          Text(
            headline,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
