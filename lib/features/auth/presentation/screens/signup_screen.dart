import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/core/widgets/social_button.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/features/auth/domain/entities/user.dart';

import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';

import 'package:pomogrow/features/auth/presentation/widgets/auth_button.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_hr.dart';

import 'package:pomogrow/features/auth/presentation/widgets/auth_txtfield.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AsyncValue<UserEntity?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null && context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        error: (err, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err.toString())));
        },
      );
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const BackButtonWidgets(),
                const SizedBox(height: 40),
                Text(
                  'BUAT AKUN',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "Buat akun baru dan jadi bagian dari PomoGrow",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                AuthField(
                  icon: Icon(Icons.person),
                  hintText: 'Nama Pengguna',
                  controller: _nameController,
                  validator: (v) => v == null || v.isEmpty
                      ? 'Please enter your username'
                      : null,
                ),
                const SizedBox(height: 15),
                AuthField(
                  icon: Icon(Icons.email),
                  hintText: 'Gmail',
                  controller: _emailController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 15),
                AuthField(
                  icon: Icon(Icons.lock),
                  hintText: 'Password',
                  isPassword: true,
                  controller: _passwordController,
                  validator: (v) => v == null || v.isEmpty
                      ? 'Please enter your password'
                      : null,
                ),
                const SizedBox(height: 40),
                authState.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error: $err'),
                  data: (user) => AuthButton(
                    text: 'Sign Up',
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form != null && form.validate()) {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signUp(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10, height: 10),
                const SizedBox(height: 40),
                CenteredText(text: 'Atau pilih dengan'),
                const SizedBox(height: 40),
                SocialButton(
                  asset: 'assets/icons/google.svg',
                  onPressed: () async {
                    await ref
                        .read(authNotifierProvider.notifier)
                        .signUpWithGoogle();

                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                const SizedBox(height: 70),
                RichText(
                  text: TextSpan(
                    text: "Sudah punya akun? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppPallete.textTitleColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/signin');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
