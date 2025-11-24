import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              "assets/images/field.png",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: AppPallete.gradient3,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
