import 'dart:ui';

class CompositionResult {
  final String direction;
  final int score;

  const CompositionResult({required this.direction, required this.score});
}

class CompositionAnalyzer {
  // Rule of thirds intersection points (normalized 0-1)
  static const _thirdPoints = [
    Offset(1 / 3, 1 / 3),
    Offset(2 / 3, 1 / 3),
    Offset(1 / 3, 2 / 3),
    Offset(2 / 3, 2 / 3),
  ];

  /// Analyze face position relative to the preview frame.
  /// [faceRect] and [previewSize] should be in the same coordinate space.
  CompositionResult analyze(Rect faceRect, Size previewSize) {
    final faceCenterX = faceRect.center.dx / previewSize.width;
    final faceCenterY = faceRect.center.dy / previewSize.height;
    final faceCenter = Offset(faceCenterX, faceCenterY);

    // Face size ratio relative to frame
    final faceRatio = faceRect.width / previewSize.width;

    // Direction hint
    final direction = _getDirection(faceCenterX, faceCenterY, faceRatio);

    // Composition score: distance from nearest rule-of-thirds point
    final score = _calcScore(faceCenter);

    return CompositionResult(direction: direction, score: score);
  }

  String _getDirection(double cx, double cy, double faceRatio) {
    // Face too small → come closer
    if (faceRatio < 0.12) return 'Come Closer ↑';
    // Face too large → step back
    if (faceRatio > 0.45) return 'Step Back ↓';
    // Horizontal position
    if (cx < 0.25) return 'Move Right →';
    if (cx > 0.75) return '← Move Left';
    // Vertical position
    if (cy < 0.20) return 'Move Down ↓';
    if (cy > 0.70) return 'Move Up ↑';
    return 'Perfect! 📸';
  }

  int _calcScore(Offset faceCenter) {
    double minDist = double.infinity;
    for (final p in _thirdPoints) {
      final d = (faceCenter - p).distance;
      if (d < minDist) minDist = d;
    }
    // Max possible distance is sqrt(0.5) ≈ 0.707
    final normalized = (1.0 - (minDist / 0.707)).clamp(0.0, 1.0);
    return (normalized * 100).round();
  }
}
