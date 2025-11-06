import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashIcon extends StatelessWidget {
  final String asset;

  const SplashIcon({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SvgPicture.asset(asset)],
      ),
    );
  }
}
