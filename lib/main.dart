import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masiha_user/screens/home/home.dart';
import 'package:masiha_user/screens/login_signup/let_in.dart';
import 'package:masiha_user/screens/login_signup/login_screen.dart';
import 'package:masiha_user/screens/login_signup/signup_screen.dart';
import 'package:masiha_user/screens/onboards/onboard1/onboard1.dart';
import 'package:masiha_user/screens/onboards/onboard2/onboard2.dart';
import 'package:masiha_user/screens/onboards/onboard3/onboard3.dart';
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
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboard1': (context) => const Onboarding1(),
        '/onboard2': (context) => const Onboarding2(),
        '/onboard3': (context) => const Onboarding3(),
        '/letin': (context) => const LetinPage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
