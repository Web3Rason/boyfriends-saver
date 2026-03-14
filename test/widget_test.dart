import 'package:flutter_test/flutter_test.dart';
import 'package:boyfriends_saver/composition_analyzer.dart';
import 'dart:ui';

void main() {
  test('CompositionAnalyzer returns Perfect when face at rule-of-thirds', () {
    final analyzer = CompositionAnalyzer();
    // Face centered at (1/3, 1/3) of a 1080x1920 screen
    final faceRect = Rect.fromCenter(
      center: const Offset(360, 640),
      width: 200,
      height: 250,
    );
    final result = analyzer.analyze(faceRect, const Size(1080, 1920));
    expect(result.score, greaterThan(80));
  });

  test('CompositionAnalyzer gives direction when face is off-center', () {
    final analyzer = CompositionAnalyzer();
    // Face at far left
    final faceRect = Rect.fromCenter(
      center: const Offset(100, 960),
      width: 200,
      height: 250,
    );
    final result = analyzer.analyze(faceRect, const Size(1080, 1920));
    expect(result.direction, contains('Right'));
  });
}
