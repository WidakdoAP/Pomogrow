import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomogrow/core/.secrets/supabase_key.dart';
import 'package:pomogrow/features/auth/presentation/screens/authgate.dart';
import 'package:pomogrow/features/auth/presentation/screens/email_auth_screen.dart';
import 'package:pomogrow/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:pomogrow/features/home/presentation/screens/entry_screen.dart';
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

  await Supabase.initialize(
    url: SupabaseKey.SUPABASE_URL,
    anonKey: SupabaseKey.SUPABASE_KEY,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navKey.currentState?.pushReplacementNamed('/pass_reset');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/signin': (context) => const SigninScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/email_verf': (context) => const UserEmailScreen(),
        '/pass_reset': (context) => const ResetPasswordScreen(),
        '/auth_gate': (context) => const AuthGate(),
      },
      title: 'Pomogrow',
      theme: AppTheme.lightThemeMode.copyWith(
        textTheme: AppTheme.fontTheme.textTheme,
      ),
      home: EntryScreen(),
    );
  }
}
