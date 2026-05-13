import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';

class ProfileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  const ProfileButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: AppPalette.gradient3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppPalette.textTitleColor, size: 22),
              const SizedBox(width: 10),
            ],

            Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ), //Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
