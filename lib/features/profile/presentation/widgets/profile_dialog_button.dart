import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class ProfileDialogButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const ProfileDialogButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppPallete.gradient1,
            AppPallete.gradient2,
            AppPallete.gradient3,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: Colors.transparent,
        ),
        child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
