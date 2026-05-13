import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';
import 'package:pomogrow/features/auth/presentation/screens/signin_screen.dart';
import 'package:pomogrow/features/home/presentation/screens/entry_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const EntryScreen();
        } else {
          return const SigninScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
    );
  }
}
