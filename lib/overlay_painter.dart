import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class OverlayPainter extends CustomPainter {
  final Rect? faceRect;
  final String direction;
  final int score;

  OverlayPainter({
    this.faceRect,
    required this.direction,
    required this.score,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawRuleOfThirds(canvas, size);
    if (faceRect != null) {
      _drawFaceBox(canvas, faceRect!);
    }
    _drawDirection(canvas, size);
    _drawScore(canvas, size);
  }

  void _drawRuleOfThirds(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Vertical lines
    canvas.drawLine(Offset(w / 3, 0), Offset(w / 3, h), paint);
    canvas.drawLine(Offset(2 * w / 3, 0), Offset(2 * w / 3, h), paint);
    // Horizontal lines
    canvas.drawLine(Offset(0, h / 3), Offset(w, h / 3), paint);
    canvas.drawLine(Offset(0, 2 * h / 3), Offset(w, 2 * h / 3), paint);

    // Intersection dots
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    for (final dx in [w / 3, 2 * w / 3]) {
      for (final dy in [h / 3, 2 * h / 3]) {
        canvas.drawCircle(Offset(dx, dy), 4, dotPaint);
      }
    }
  }

  void _drawFaceBox(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = score >= 75 ? Colors.greenAccent : Colors.yellowAccent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
  }

  void _drawDirection(Canvas canvas, Size size) {
    if (direction.isEmpty) return;

    final textStyle = ui.TextStyle(
      color: direction.contains('Perfect') ? Colors.greenAccent : Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(color: Colors.black, blurRadius: 6, offset: const Offset(1, 1)),
      ],
    );

    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      maxLines: 1,
    ))
      ..pushStyle(textStyle)
      ..addText(direction);

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.width));

    canvas.drawParagraph(
      paragraph,
      Offset(0, size.height * 0.82),
    );
  }

  void _drawScore(Canvas canvas, Size size) {
    final color = score >= 75
        ? Colors.greenAccent
        : score >= 50
            ? Colors.yellowAccent
            : Colors.redAccent;

    final textStyle = ui.TextStyle(
      color: color,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(color: Colors.black, blurRadius: 4, offset: const Offset(1, 1)),
      ],
    );

    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      maxLines: 1,
    ))
      ..pushStyle(textStyle)
      ..addText('Composition: $score%');

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.width));

    canvas.drawParagraph(
      paragraph,
      Offset(0, size.height * 0.90),
    );
  }

  @override
  bool shouldRepaint(covariant OverlayPainter oldDelegate) {
    return oldDelegate.faceRect != faceRect ||
        oldDelegate.direction != direction ||
        oldDelegate.score != score;
  }
}
