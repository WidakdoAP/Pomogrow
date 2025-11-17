import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/widgets/flushbar_notif.dart';
import 'package:rive/rive.dart' hide Image;

import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';

import 'package:pomogrow/features/auth/domain/entities/user.dart';

import 'package:pomogrow/features/auth/presentation/widgets/auth_button.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_positioned.dart';

import 'package:pomogrow/features/auth/presentation/widgets/auth_txtfield.dart';
import 'package:pomogrow/features/auth/presentation/widgets/wave_clipper.dart';

import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
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

  void signIn(BuildContext context) {
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
          if (user != null && mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) Navigator.pushReplacementNamed(context, '/home');
            });
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
          RepaintBoundary(
            child: ClipPath(
              clipper: WaveClipper(),
              child: Image.asset(
                'assets/images/background_signin.jpg',
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.40,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 350),
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //const Spacer(), Sama aja
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
                    const SizedBox(height: 150),
                    AuthButton(
                      text: 'Sign In',
                      onPressed: () {
                        signIn(context);
                      },
                    ),
                    const SizedBox(height: 20),
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
            ),
          ),
          const Positioned(top: 40, left: 10, child: BackButtonWidgets()),

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
