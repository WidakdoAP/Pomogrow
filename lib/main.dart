import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomogrow/core/.secrets/supabase_key.dart';
import 'package:pomogrow/features/auth/presentation/screens/authgate.dart';
import 'package:pomogrow/features/auth/presentation/screens/email_auth_screen.dart';
import 'package:pomogrow/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:pomogrow/features/chatbot/presentation/screens/chat_screen.dart';
import 'package:pomogrow/features/field/presentation/screens/fields_screen.dart';
import 'package:pomogrow/features/home/presentation/screens/entry_screen.dart';
import 'package:pomogrow/features/market/presentation/screens/market_screen.dart';
import 'package:pomogrow/features/notes/presentation/screens/notes_page_screen.dart';
import 'package:pomogrow/features/profile/presentation/screens/profile_screen.dart';
import 'package:pomogrow/features/splash/presentation/screens/splash.dart';
import 'package:pomogrow/features/timer/presentation/screens/timer_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:pomogrow/core/theme/theme.dart';
import 'package:pomogrow/features/auth/presentation/screens/signin_screen.dart';
import 'package:pomogrow/features/auth/presentation/screens/signup_screen.dart';

import 'features/auth/presentation/providers/auth_provider.dart';

// This is to access Supabase Database.
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
final navKey = GlobalKey<NavigatorState>();
late final StreamSubscription _authSub;

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        ref.read(isRecoveringPasswordProvider.notifier).state = true;
      }

      if (data.event == AuthChangeEvent.signedOut) {
        ref.read(isRecoveringPasswordProvider.notifier).state = false;
      }
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
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
          final args = ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?;

          return TimerScreen(
            timeIntMinutes: args?['minutes'] ?? 0,
            selectedIndex: args?['index'] ?? 0,
          );
        },
        '/notes': (context) => const NotesPageScreen(),
        '/chatbot': (context) => const ChatScreen(),
      },
      title: 'Pomogrow',
      // Global Theme.
      theme: AppTheme.lightThemeMode.copyWith(
        textTheme: AppTheme.fontTheme.textTheme,
        pageTransitionsTheme: AppTheme.navigatorTheme.pageTransitionsTheme,
      ),
      // The first activity, changed it to AuthGate activity.
      home: SplashScreen(),
    );
  }
}
