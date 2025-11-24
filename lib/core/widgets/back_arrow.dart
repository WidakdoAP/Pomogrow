import 'package:flutter/material.dart';

class BackButtonWidgets extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const BackButtonWidgets({super.key, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onPressed ?? () => Navigator.pop(context),
        ),
      ],
    );
  }
}
