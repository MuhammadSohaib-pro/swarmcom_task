import 'package:flutter/material.dart';

class EllipsePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final Color strokeColor;

  EllipsePainter({
    required this.color,
    required this.strokeWidth,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawOval(rect, paint); // Draw filled ellipse

    // Draw stroke
    if (strokeWidth > 0) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = strokeColor;

      canvas.drawOval(rect, paint); // Draw ellipse stroke
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
