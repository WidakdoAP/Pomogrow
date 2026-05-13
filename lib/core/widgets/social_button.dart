import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pomogrow/core/theme/palette.dart';

class SocialButton extends StatelessWidget {
  final String asset;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double height;
  final double logoSize;
  final EdgeInsetsGeometry padding;

  const SocialButton({
    super.key,
    required this.asset,
    required this.onPressed,
    this.backgroundColor = AppPalette.transparentColor,
    this.height = 48,
    this.logoSize = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: CircleBorder(),
          padding: padding,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset, width: logoSize, height: logoSize),
          ],
        ),
      ),
    );
  }
}
