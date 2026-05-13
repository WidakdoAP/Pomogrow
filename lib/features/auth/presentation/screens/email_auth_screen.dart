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

class UserEmailScreen extends ConsumerStatefulWidget {
  const UserEmailScreen({super.key});

  @override
  ConsumerState<UserEmailScreen> createState() => _UserEmailScreen();
}

class _UserEmailScreen extends ConsumerState<UserEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void resetEmailPassword(BuildContext context) async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      await ref
          .read(authNotifierProvider.notifier)
          .sendResetEmail(email: _emailController.text.trim());

      if (!context.mounted) return;
      FlushbarNotif.show(
        context,
        title: "Berhasil",
        msg: "Email reset password telah dikirim.",
      );
    } else {
      FlushbarNotif.show(context, title: "Error", msg: "Coba Lagi");
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
                      'VERIFIKASI EMAIL',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kami akan mengirimkan verifikasi ke email kamu',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
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
                    const SizedBox(height: 20),
                    AuthButton(
                      text: 'Konfirmasi Email',
                      onPressed: () {
                        resetEmailPassword(context);
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
