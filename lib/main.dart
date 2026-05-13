import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomogrow/core/.secrets/supabase_key.dart';
import 'package:pomogrow/features/auth/presentation/screens/authgate.dart';
import 'package:pomogrow/features/auth/presentation/screens/email_auth_screen.dart';
import 'package:pomogrow/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:pomogrow/features/field/presentation/screens/fields_screen.dart';
import 'package:pomogrow/features/home/presentation/screens/entry_screen.dart';
import 'package:pomogrow/features/market/presentation/screens/market_screen.dart';
import 'package:pomogrow/features/profile/presentation/screens/profile_screen.dart';
import 'package:pomogrow/features/timer/presentation/screens/timer_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:pomogrow/core/theme/theme.dart';
import 'package:pomogrow/features/auth/presentation/screens/signin_screen.dart';
import 'package:pomogrow/features/auth/presentation/screens/signup_screen.dart';

// This is to access Supabase Database.
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

// Main Function
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable orientation changes
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseKey.SUPABASE_URL,
    anonKey: SupabaseKey.SUPABASE_KEY,
  );
  // Enabling Riverpod
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
    // If user forgot password, they'll be redirected to this.
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
      // Path to each activity.
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/signin': (context) => const SigninScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const EntryScreen(),
        '/email_verf': (context) => const UserEmailScreen(),
        '/pass_reset': (context) => const ResetPasswordScreen(),
        '/auth_gate': (context) => const AuthGate(),
        '/profile': (context) => const ProfileScreen(),
        '/fields': (context) => const FieldsScreen(),
        '/marketplace': (context) => const MarketScreen(),
        '/timer': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int? ?? 0;
          return TimerScreen(timeIntMinutes: args);
        }
      },
      title: 'Pomogrow',
      // Global Theme.
      theme: AppTheme.lightThemeMode.copyWith(
        textTheme: AppTheme.fontTheme.textTheme,
        pageTransitionsTheme: AppTheme.navigatorTheme.pageTransitionsTheme,
      ),
      // The first activity, changed it to AuthGate activity.
      home: AuthGate(),
    );
  }
}
