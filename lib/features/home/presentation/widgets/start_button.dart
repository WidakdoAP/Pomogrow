import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class StartButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback? onPressed;
  const StartButton({super.key, this.isRunning = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppPallete.textTitleColor, width: 4),
      ),
      child: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {},
          backgroundColor: AppPallete.backgroundColor,
          child: Icon(
            isRunning ? Icons.pause : Icons.play_arrow_rounded,
            size: 50,
            color: AppPallete.textTitleColor,
          ),
        ),
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       IconButton(
//         icon: const Icon(Icons.arrow_back),
//         onPressed: onPressed ?? () => Navigator.pop(context),
//       ),
//     ],
//   );
// }
