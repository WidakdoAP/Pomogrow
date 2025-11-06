import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_button.dart';

import 'package:pomogrow/features/auth/presentation/widgets/auth_remember.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_txtfield.dart';
import 'package:pomogrow/features/auth/presentation/widgets/wave_clipper.dart';

import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final notifier = ref.read(authProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Image.asset(
                    'assets/images/background_signin.jpg',
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.40,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(top: 40, left: 10, child: BackButtonWidgets()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'HI GROWERS!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Masuk dan teruskan perjalananmu',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    icon: Icon(Icons.person),
                    hintText: 'Nama Pengguna',
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    icon: Icon(Icons.lock),
                    hintText: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(width: 10, height: 10),
                  Row(
                    children: [
                      AuthRemember(
                        value: state.isRemembered,
                        onChanged: (_) => notifier.toggleRemember(),
                      ),
                      const SizedBox(width: 100),
                      RichText(
                        text: TextSpan(
                          text: 'Lupa Password?',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppPallete.textTitleColor,
                                decoration: TextDecoration.underline,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/');
                            },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 140),
                  AuthButton(onPressed: notifier.signUp),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "Tidak punya akun? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppPallete.textTitleColor,
                                decoration: TextDecoration.underline,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/signup');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
