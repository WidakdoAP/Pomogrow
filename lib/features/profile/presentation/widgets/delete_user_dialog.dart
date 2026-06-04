import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/flushbar_notif.dart';
import 'package:pomogrow/features/profile/presentation/providers/profile_provider.dart';
import 'package:pomogrow/features/profile/presentation/widgets/profile_dialog_button.dart';

Future<String?> showCustomUserDeleteDialog(BuildContext context, WidgetRef ref) {

  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, _, _) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (_, animation, _, _) {
      return Transform.translate(
        offset: Offset(0, -100 + (100 * animation.value)),
        child: Opacity(
          opacity: animation.value,
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Dialog(
                insetPadding: const EdgeInsets.only(
                  top: 100,
                  left: 20,
                  right: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/background_signin.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Hapus Akun?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.blackShadow,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row (
                            //spacing: 16,
                            children: [
                              ProfileDialogButton(
                                text: "Kembali",
                                size: Size(140, 55),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Spacer(),
                              ProfileDialogButton(
                                text: "Hapus",
                                  size: Size(140, 55),
                                onPressed: () async {
                                  try {
                                    await ref
                                        .read(userProfileProvider.notifier)
                                        .deleteUser();

                                    if (context.mounted) {
                                      Navigator.of(context)
                                        ..pop()
                                        ..pushReplacementNamed('/signin');
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      FlushbarNotif.show(
                                          context,
                                          title: "Error",
                                          msg: "Gagal menghapus akun."
                                      );
                                    }
                                  }
                                }
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
