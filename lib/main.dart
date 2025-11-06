import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomogrow/features/home/presentation/screens/home_screen.dart';
import 'package:pomogrow/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:pomogrow/features/splash/presentation/screens/splash.dart';

import 'package:pomogrow/core/theme/theme.dart';

import 'package:pomogrow/features/auth/presentation/screens/signin_screen.dart';
import 'package:pomogrow/features/auth/presentation/screens/signup_screen.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/signin': (context) => const SigninScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
      title: 'Pomogrow',
      theme: AppTheme.lightThemeMode.copyWith(
        textTheme: AppTheme.fontTheme.textTheme,
      ),
      home: SplashScreen(),
    );
  }
}
