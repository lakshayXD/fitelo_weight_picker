import 'dart:math';
import 'package:fitelo_assignment/constants/colors.dart';
import 'package:flutter/material.dart';

class PinPainter extends CustomPainter {
  final double innerRadius;
  final double outerRadius;
  final Offset center;
  final Color color;

  PinPainter({
    required this.innerRadius,
    required this.outerRadius,
    required this.center,
    this.color = secondaryOrange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const double angle = -pi / 2;

    final Offset inner = Offset(
      center.dx + innerRadius * cos(angle),
      center.dy + innerRadius * sin(angle),
    );

    final Offset outer = Offset(
      center.dx + outerRadius * cos(angle),
      center.dy + outerRadius * sin(angle),
    );

    canvas.drawLine(inner, outer, paint);
    final double circleRadius = 5;
    final Paint circlePaint = Paint()..color = color;

    final Offset outerCircleCenter = Offset(
      outer.dx,
      outer.dy + 12,
    );
    final Path outerCircle = Path()
      ..addOval(
        Rect.fromCircle(center: outerCircleCenter, radius: circleRadius),
      );
    canvas.drawPath(outerCircle, circlePaint);
    final Offset innerCircleCenter = Offset(inner.dx, inner.dy);
    final Path innerCircle = Path()
      ..addOval(
        Rect.fromCircle(center: innerCircleCenter, radius: circleRadius),
      );
    canvas.drawPath(innerCircle, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}