import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/features/onboarding/data/onboarding_local_data.dart';
import 'dart:async';

import 'package:pomogrow/features/splash/presentation/widgets/app_logo_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final bool alwaysShowOnboarding = true; // debug mode
  final repo = OnboardingLocalData();

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    // final showOnboarding = !(await repo.isOnboardingCompleted());
    final showOnboarding = alwaysShowOnboarding
        ? true
        : !(await repo.isOnboardingCompleted()); // For debugging.
    // TODO: Don't forget to change this code when releasing to the play store.
    if (!mounted) return;
    if (showOnboarding) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [AppPalette.gradient1, AppPalette.backgroundColor],
            center: Alignment.center,
            radius: 3.14,
          ),
        ),

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SplashIcon(asset: 'assets/icons/pomogrow.svg'),
              SizedBox(height: 10),
              SplashIcon(asset: 'assets/icons/title.svg'),
            ],
          ),
        ),
      ),
    );
  }
}
