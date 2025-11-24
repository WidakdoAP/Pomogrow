import 'package:flutter/material.dart';

class MiddleCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.4);

    path.quadraticBezierTo(
      size.width * 0.5, // titik tengah
      size.height * 0.1, // semakin kecil semakin tinggi
      size.width,
      size.height * 0.4,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
