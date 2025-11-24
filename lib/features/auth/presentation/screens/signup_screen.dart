import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_positioned.dart';
import 'package:rive/rive.dart';

import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/core/widgets/flushbar_notif.dart';
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

  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine 1",
    );
    artboard.addController(controller!);
    return controller;
  }

  void signUp(BuildContext context) {
    final form = _formKey.currentState!;
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(Duration(seconds: 2), () async {
      if (form.validate()) {
        await ref
            .read(authNotifierProvider.notifier)
            .signIn(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
        check.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
        confetti.fire();
      } else {
        error.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UserEntity?>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null && context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        error: (err, _) {
          FlushbarNotif.show(context, title: "Error", msg: err.toString());
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 160),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Masukkan Username mu!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AuthField(
                      icon: const Icon(Icons.email),
                      hintText: 'Email',
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email tidak boleh kosong!";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Email tidak valid";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AuthField(
                      icon: const Icon(Icons.lock),
                      hintText: 'Password',
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password tidak boleh kosong!";
                        }
                        if (value.length < 6) {
                          return "Minimal 6 karakter";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    AuthButton(
                      text: 'Sign Up',
                      onPressed: () {
                        signUp(context);
                      },
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
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
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
          const Positioned(top: 50, left: 10, child: BackButtonWidgets()),

          isShowLoading
              ? CustomPositioned(
                  child: RiveAnimation.asset(
                    'assets/animations/check_error.riv',
                    onInit: (artboard) {
                      StateMachineController controller = getRiveController(
                        artboard,
                      );
                      check = controller.findSMI("Check") as SMITrigger;
                      error = controller.findSMI("Error") as SMITrigger;
                      reset = controller.findSMI("Reset") as SMITrigger;
                    },
                  ),
                )
              : SizedBox(),

          isShowConfetti
              ? CustomPositioned(
                  child: Transform.scale(
                    scale: 6,
                    child: RiveAnimation.asset(
                      "assets/animations/confetti_explosion.riv",
                      onInit: (artboard) {
                        StateMachineController controller = getRiveController(
                          artboard,
                        );
                        confetti =
                            controller.findSMI("Trigger explosion")
                                as SMITrigger;
                      },
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
