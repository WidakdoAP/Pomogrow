import 'package:flutter/material.dart';

class ProfileClip extends StatelessWidget {
  final Color color;
  final double height;
  const ProfileClip({super.key, required this.color, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomBarClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(color: color),
      ),
    );
  }
}

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    double centerWidth = size.width / 2;
    double fabRadius = 70;

    double topLeftRadius = 30;
    double topRightRadius = 30;

    path.moveTo(0, size.height);

    path.lineTo(0, topLeftRadius);
    path.quadraticBezierTo(0, 0, topLeftRadius, 0);

    path.lineTo(centerWidth - fabRadius, 0);

    path.quadraticBezierTo(centerWidth, fabRadius, centerWidth - fabRadius, 0);

    path.lineTo(size.width - topRightRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, topRightRadius);

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
