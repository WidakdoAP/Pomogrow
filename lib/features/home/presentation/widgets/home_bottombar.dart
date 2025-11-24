import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomBarClipper(),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppPallete.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppPallete.blackShadow,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    double centerWidth = size.width / 2;
    double fabRadius = 50;

    double topLeftRadius = 24;
    double topRightRadius = 24;

    path.moveTo(0, size.height);

    path.lineTo(0, topLeftRadius);
    path.quadraticBezierTo(0, 0, topLeftRadius, 0);

    path.lineTo(centerWidth - fabRadius, 0);

    path.arcToPoint(
      Offset(centerWidth + fabRadius, 0),
      radius: Radius.circular(fabRadius),
      clockwise: false,
    );

    path.lineTo(size.width - topRightRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, topRightRadius);

    path.lineTo(size.width, size.height);

    // Tutup path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
