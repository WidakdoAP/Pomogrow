import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 300);
    path.quadraticBezierTo(size.width / 3, 350, size.width / 2, 300);
    path.quadraticBezierTo(2 / 3 * size.width, 230, size.width, 230);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
