import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set app to portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const FlappyBirdPhysicsApp());
}

class FlappyBirdPhysicsApp extends StatelessWidget {
  const FlappyBirdPhysicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird Physics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
