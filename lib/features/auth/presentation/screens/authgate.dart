import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';
import 'package:pomogrow/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:pomogrow/features/auth/presentation/screens/signin_screen.dart';
import 'package:pomogrow/features/home/presentation/screens/entry_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final isRecovering = ref.watch(isRecoveringPasswordProvider);

    if (isRecovering) {
      return const ResetPasswordScreen();
    }

    return auth.when(
      data: (user) {
        if (user == null) return const SigninScreen();
        return const EntryScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SigninScreen(),
    );
  }
}