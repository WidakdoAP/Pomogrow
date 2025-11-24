import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomThumbImage extends SliderComponentShape {
  final ui.Image image;
  CustomThumbImage(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(70, 70);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final imageOffset = Offset(
      center.dx - (image.width / 2),
      center.dy - (image.height / 2),
    );
    canvas.drawImage(image, imageOffset, Paint());
  }
}
