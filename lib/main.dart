import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:masiha_user/consts/stripe_keys.dart';
import 'package:masiha_user/firebase_options.dart';
import 'package:masiha_user/providers/booking_provider.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/providers/forgot_password_provider.dart';
import 'package:masiha_user/providers/onboarding_provider.dart';
import 'package:masiha_user/providers/user_details_provider.dart';
import 'package:masiha_user/screens/add_details.dart';
import 'package:masiha_user/screens/home/favourites_screen.dart';
import 'package:masiha_user/screens/home/home.dart';
import 'package:masiha_user/screens/login_signup/all_set.dart';
import 'package:masiha_user/screens/login_signup/forgot_password.dart';
import 'package:masiha_user/screens/login_signup/let_in.dart';
import 'package:masiha_user/screens/login_signup/login_screen.dart';
import 'package:masiha_user/screens/login_signup/signup_screen.dart';
import 'package:masiha_user/screens/onboards/onboard1/onboard1.dart';
import 'package:masiha_user/screens/onboards/onboard2/onboard2.dart';
import 'package:masiha_user/screens/onboards/onboard3/onboard3.dart';
import 'package:masiha_user/screens/profile_screen.dart';
import 'package:masiha_user/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
        ChangeNotifierProvider(create: (_) => DoctorDetailsProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/forgotpass': (context) => const ForgotPasswordScreen(),
        '/allset': (context) => const AllSetScreen(),
        '/home': (context) => const HomeScreen(),
        '/addDetails': (context) => const UserDetailsPage(),
        '/profile': (context) => const ProfileScreen(),
        '/favorite': (context) => const FavoriteDoctorsScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
