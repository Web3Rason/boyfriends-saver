import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'camera_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const BoyfriendsSaverApp());
}

class BoyfriendsSaverApp extends StatelessWidget {
  const BoyfriendsSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boyfriends Saver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CameraScreen(),
    );
  }
}
