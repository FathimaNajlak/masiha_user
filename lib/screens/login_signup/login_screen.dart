import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/providers/login_screen_provider.dart';
import 'package:masiha_user/widgets/login/login_button.dart';
import 'package:masiha_user/widgets/login/login_form.dart';
import 'package:masiha_user/widgets/login/login_with.dart';
import 'package:masiha_user/widgets/login/sign_up.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:
              Colors.transparent, // Makes the AppBar background transparent
          elevation: 0, // Removes the shadow
          centerTitle: true, // Centers the title
          title: const Text(
            'Hello!',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF78A6B8),
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black, // Default icon color for all icons in AppBar
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.black), // Default back arrow with explicit color
            onPressed: () => Navigator.pushReplacementNamed(
                context, '/letin'), // Navigates back to the previous screen
          ),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF78A6B8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 32),
                LoginForm(),
                SizedBox(height: 24),
                LoginButton(),
                SizedBox(height: 16),
                LoginWith(),
                SizedBox(height: 16),
                SignUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
