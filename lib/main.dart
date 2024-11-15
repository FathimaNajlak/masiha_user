import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masiha_user/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner

      theme: ThemeData(
        primarySwatch: Colors.blue, // Define your theme colors
      ),
      home: const SplashScreen(), // Set SplashScreen as the home
    );
  }
}
