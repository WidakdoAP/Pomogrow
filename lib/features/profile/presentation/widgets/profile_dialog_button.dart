import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';

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
            AppPalette.gradient1,
            AppPalette.gradient2,
            AppPalette.gradient3,
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
          backgroundColor: AppPalette.transparentColor,
          shadowColor: Colors.transparent,
        ),
        child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
