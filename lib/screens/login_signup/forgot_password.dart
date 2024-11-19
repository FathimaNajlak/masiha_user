import 'package:flutter/material.dart';
import 'package:masiha_user/providers/forgot_password_provider.dart';
import 'package:masiha_user/widgets/login/forgot_password/button.dart';
import 'package:masiha_user/widgets/login/forgot_password/email_input.dart';
import 'package:masiha_user/widgets/login/forgot_password/illusration.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Forgot password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Enter your Email and we will send you\na password reset link',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 32),
                  EmailInput(),
                  SizedBox(height: 24),
                  IllustrationWidget(),
                  SizedBox(height: 32),
                  Button(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
