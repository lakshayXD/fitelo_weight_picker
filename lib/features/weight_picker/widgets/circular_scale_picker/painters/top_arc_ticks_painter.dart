import 'dart:math';
import 'package:fitelo_assignment/constants/colors.dart';
import 'package:flutter/material.dart';

class TopArcTicksPainter extends CustomPainter {
  final double scrollOffset;
  final int min;
  final double itemExtent;
  final int visibleItemCount;
  final double radius;
  final TextStyle textStyle;

  TopArcTicksPainter({
    required this.scrollOffset,
    required this.min,
    required this.itemExtent,
    required this.visibleItemCount,
    required this.radius,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint tickPaint = Paint()..strokeCap = StrokeCap.round;
    final Offset center = Offset(size.width / 2, radius + 6);

    final int visible = max(3, visibleItemCount);
    final double angleStep = pi / (visible - 1);

    final double centerIndexFraction = scrollOffset / itemExtent;
    final int half = visible ~/ 2;
    final int centerIdx = centerIndexFraction.round();

    final int start = max(min - min, centerIdx - half);
    final int end = centerIdx + half;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double outerR = radius - 8;

    ///scale ticks making logic
    for (int idx = start; idx <= end; idx++) {
      final double relative = idx - centerIndexFraction;
      final double rotatedAngle = -pi / 2 + (relative * angleStep);

      final Offset outer = Offset(
        center.dx + outerR * cos(rotatedAngle),
        center.dy + outerR * sin(rotatedAngle),
      );

      final bool isMajor = ((min + idx) % 20 == 0);
      final bool isHalf = ((min + idx) % 10 == 0);
      final double tickLen = (isMajor || isHalf) ? 24.0 : 20.0;

      final Offset inner = Offset(
        center.dx + (outerR - tickLen) * cos(rotatedAngle),
        center.dy + (outerR - tickLen) * sin(rotatedAngle),
      );

      Color tickColor = primaryBlack;
      if (isMajor) {
        tickColor = primaryBlack;
      } else if (isHalf) {
        tickColor = primaryOrange;
      } else {
        tickColor = secondaryBlack;
      }

      tickPaint.color = tickColor;
      tickPaint.strokeWidth = (isMajor || isHalf) ? 2.0 : 1.6;

      canvas.drawLine(inner, outer, tickPaint);

      if (isMajor) {
        final int weightValue = max(min, (min + idx / 20).round());
        textPainter.text = TextSpan(
          text: "$weightValue",
          style: textStyle.copyWith(fontSize: 12, color: primaryBlack),
        );
        textPainter.layout();
        final double labelOffsetR = outerR - (tickLen + 14);
        final Offset labelPos = Offset(
          center.dx + labelOffsetR * cos(rotatedAngle) - textPainter.width / 2,
          center.dy + labelOffsetR * sin(rotatedAngle) - textPainter.height / 2,
        );

        textPainter.paint(canvas, labelPos);
      }
    }

    ///outer borders
    final Paint arcPaintOuter1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = primaryGrey.withOpacity(0.14);
    final Path arcPathOuter1 = Path();
    arcPathOuter1.addArc(
      Rect.fromCircle(center: center, radius: outerR + 38),
      -pi,
      pi,
    );
    canvas.drawPath(arcPathOuter1, arcPaintOuter1);

    final Paint arcPaintOuter2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = primaryGrey.withOpacity(0.14);
    final Path arcPathOuter2 = Path();
    arcPathOuter2.addArc(
      Rect.fromCircle(center: center, radius: outerR + 30),
      -pi,
      pi,
    );
    canvas.drawPath(arcPathOuter2, arcPaintOuter2);

    ///inner border
    final Paint arcPaintInner = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = primaryGrey.withOpacity(0.14);
    final Path arcPathInner = Path();
    arcPathInner.addArc(
      Rect.fromCircle(center: center, radius: outerR - 70),
      -pi,
      pi,
    );
    canvas.drawPath(arcPathInner, arcPaintInner);
  }

  @override
  bool shouldRepaint(covariant TopArcTicksPainter old) {
    return old.scrollOffset != scrollOffset ||
        old.min != min ||
        old.itemExtent != itemExtent ||
        old.visibleItemCount != visibleItemCount ||
        old.radius != radius;
  }
}
