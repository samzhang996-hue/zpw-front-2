
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ZpwGradientBorderPainter extends CustomPainter {
  final double width;
  final List<Color> colors;

  ZpwGradientBorderPainter({required this.width, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.width, size.height),
        colors,
        [0.0, 1.0],
      );

    // Draw the border rectangle
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
