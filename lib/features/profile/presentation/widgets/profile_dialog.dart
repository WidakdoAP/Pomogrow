import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/features/profile/presentation/widgets/profile_dialog_button.dart';

Future<String?> showCustomUsernameDialog(BuildContext context) {
  final usernameKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (_, animation, __, ___) {
      return Transform.translate(
        offset: Offset(0, -100 + (100 * animation.value)),
        child: Opacity(
          opacity: animation.value,
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Dialog(
                key: usernameKey,
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
                            "Ganti Username",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppPallete.blackShadow,
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller: nameController,
                            style: TextStyle(color: AppPallete.blackShadow),
                            decoration: InputDecoration(
                              hintText: "Masukkan username baru",
                              hintStyle: TextStyle(
                                color: AppPallete.blackShadow,
                              ),
                              filled: true,
                              fillColor: AppPallete.textfieldColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ProfileDialogButton(
                            text: "Simpan",
                            onPressed: () {
                              Navigator.pop(context, nameController.text);
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
        ),
      );
    },
  );
}
