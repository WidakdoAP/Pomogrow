import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/core/widgets/social_button.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';

import 'package:pomogrow/features/auth/presentation/providers/auth_service.dart';

import 'package:pomogrow/features/auth/presentation/widgets/auth_button.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_hr.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_remember.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_txtfield.dart';

import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final notifier = ref.read(authProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const BackButtonWidgets(),
              const SizedBox(height: 40),
              Text('BUAT AKUN', style: Theme.of(context).textTheme.titleLarge),
              Text(
                "Buat akun baru dan jadi bagian dari PomoGrow",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              AuthField(icon: Icon(Icons.person), hintText: 'Nama Pengguna'),
              const SizedBox(height: 15),
              AuthField(icon: Icon(Icons.email), hintText: 'Gmail'),
              const SizedBox(height: 15),
              AuthField(
                icon: Icon(Icons.lock),
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 40),
              AuthButton(onPressed: notifier.signUp),
              const SizedBox(width: 10, height: 10),
              AuthRemember(
                value: state.isRemembered,
                onChanged: (_) => notifier.toggleRemember(),
              ),
              const SizedBox(height: 40),
              CenteredText(text: 'Atau pilih dengan'),
              const SizedBox(height: 40),
              SocialButton(
                asset: 'assets/icons/google.svg',
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signInWithGoogle();
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
    );
  }
}
