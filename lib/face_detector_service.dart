import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: false,
      enableLandmarks: false,
      enableClassification: false,
      enableTracking: false,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isProcessing = false;

  Future<List<Face>> processImage(CameraImage image, CameraDescription camera, int sensorOrientation) async {
    if (_isProcessing) return [];
    _isProcessing = true;

    try {
      final inputImage = _buildInputImage(image, camera, sensorOrientation);
      if (inputImage == null) return [];
      final faces = await _faceDetector.processImage(inputImage);
      return faces;
    } catch (_) {
      return [];
    } finally {
      _isProcessing = false;
    }
  }

  InputImage? _buildInputImage(CameraImage image, CameraDescription camera, int sensorOrientation) {
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    final plane = image.planes.first;
    final size = Size(image.width.toDouble(), image.height.toDouble());

    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: size,
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  void dispose() {
    _faceDetector.close();
  }
}
