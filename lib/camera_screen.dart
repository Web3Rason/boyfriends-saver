import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'face_detector_service.dart';
import 'composition_analyzer.dart';
import 'overlay_painter.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  final FaceDetectorService _faceDetector = FaceDetectorService();
  final CompositionAnalyzer _analyzer = CompositionAnalyzer();

  Rect? _faceRect;
  String _direction = '';
  int _score = 0;
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _faceDetector.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _error = 'No cameras found');
        return;
      }

      // Prefer back camera
      final camera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();
      if (!mounted) return;

      await _controller!.startImageStream(_processCameraImage);
      setState(() => _isInitialized = true);
    } catch (e) {
      setState(() => _error = 'Camera error: $e');
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_controller == null) return;

    final camera = _controller!.description;
    final sensorOrientation = camera.sensorOrientation;

    final faces = await _faceDetector.processImage(image, camera, sensorOrientation);

    if (!mounted) return;

    if (faces.isEmpty) {
      setState(() {
        _faceRect = null;
        _direction = 'No face detected';
        _score = 0;
      });
      return;
    }

    // Use the largest face
    final face = faces.reduce((a, b) =>
        a.boundingBox.width * a.boundingBox.height >
                b.boundingBox.width * b.boundingBox.height
            ? a
            : b);

    // Convert face bounding box to preview coordinates
    final previewSize = _controller!.value.previewSize!;
    final screenSize = MediaQuery.of(context).size;

    final faceRect = _convertFaceRect(
      face.boundingBox,
      previewSize,
      screenSize,
      camera,
    );

    final result = _analyzer.analyze(faceRect, screenSize);

    setState(() {
      _faceRect = faceRect;
      _direction = result.direction;
      _score = result.score;
    });
  }

  Rect _convertFaceRect(
    Rect boundingBox,
    Size imageSize,
    Size screenSize,
    CameraDescription camera,
  ) {
    // Image dimensions (may be rotated)
    final rotation = camera.sensorOrientation;
    double imgW, imgH;
    if (rotation == 90 || rotation == 270) {
      imgW = imageSize.height;
      imgH = imageSize.width;
    } else {
      imgW = imageSize.width;
      imgH = imageSize.height;
    }

    final scaleX = screenSize.width / imgW;
    final scaleY = screenSize.height / imgH;

    double left, top, width, height;

    if (rotation == 90) {
      left = boundingBox.top * scaleX;
      top = (imgH - boundingBox.right) * scaleY;
      width = boundingBox.height * scaleX;
      height = boundingBox.width * scaleY;
    } else if (rotation == 270) {
      left = (imgW - boundingBox.bottom) * scaleX;
      top = boundingBox.left * scaleY;
      width = boundingBox.height * scaleX;
      height = boundingBox.width * scaleY;
    } else {
      left = boundingBox.left * scaleX;
      top = boundingBox.top * scaleY;
      width = boundingBox.width * scaleX;
      height = boundingBox.height * scaleY;
    }

    // Mirror for front camera
    if (camera.lensDirection == CameraLensDirection.front) {
      left = screenSize.width - left - width;
    }

    return Rect.fromLTWH(left, top, width, height);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(_error!, style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview (full screen)
          CameraPreview(_controller!),
          // Overlay with grid, face box, direction, score
          CustomPaint(
            painter: OverlayPainter(
              faceRect: _faceRect,
              direction: _direction,
              score: _score,
            ),
          ),
        ],
      ),
    );
  }
}
