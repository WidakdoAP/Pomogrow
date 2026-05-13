import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';

class StartButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback? onPressed;

  const StartButton({super.key, this.isRunning = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: SizedBox(
        width: 90,
        height: 90,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppPalette.textTitleColor, width: 4),
            color: AppPalette.backgroundColor,
          ),

          child: Icon(
            isRunning ? Icons.pause : Icons.play_arrow_rounded,
            size: 50,
            color: AppPalette.textTitleColor,
          ),
        ),
      ),
    );
  }
}
