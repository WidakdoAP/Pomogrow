import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/core/widgets/flushbar_notif.dart';
import 'package:pomogrow/features/auth/presentation/providers/auth_provider.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_button.dart';
import 'package:pomogrow/features/auth/presentation/widgets/auth_txtfield.dart';
import 'package:pomogrow/features/auth/presentation/widgets/middlewave_clipper.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreen();
}

class _ResetPasswordScreen extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void resetPassword(BuildContext context) async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      await ref
          .read(authNotifierProvider.notifier)
          .updateNewPassword(password: _confirmPasswordController.text.trim());

      if (!context.mounted) return;
      FlushbarNotif.show(
        context,
        title: "Berhasil",
        msg: "Password berhasil diganti, jangan sampai lupa ya :3.",
      );
    } else {
      FlushbarNotif.show(context, title: "Error", msg: "Coba Lagi :(");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(
            child: ClipPath(
              clipper: MiddleCurveClipper(),
              child: Container(height: 1040, color: AppPalette.curveColor),
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
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Lottie.asset('assets/animations/forgor.json'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'SANDI BARU',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Buat sandi baru untuk akun mu lalu masuk kembali',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 20),
                    AuthField(
                      icon: const Icon(Icons.lock),
                      hintText: 'Konfirmasi Password',
                      isPassword: true,
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password tidak boleh kosong!";
                        }
                        if (value.length < 6) {
                          return "Minimal 6 karakter";
                        }
                        if (value != _passwordController.text.trim()) {
                          return "Password tidak cocok!";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    AuthButton(
                      text: 'Konfirmasi Email',
                      onPressed: () {
                        resetPassword(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(top: 50, left: 10, child: BackButtonWidgets()),
        ],
      ),
    );
  }
}
