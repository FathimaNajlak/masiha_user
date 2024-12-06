import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masiha_user/services/firebase_auth_service.dart';
import 'package:masiha_user/widgets/login/email_input_field.dart';
import 'package:masiha_user/widgets/login/forgot_password/forgot_pass_button.dart';
import 'package:masiha_user/widgets/login/google_sign_in.dart';
import 'package:masiha_user/widgets/login/header.dart';
import 'package:masiha_user/widgets/login/login_button.dart';
import 'package:masiha_user/widgets/login/password_input_field.dart';
import 'package:masiha_user/widgets/login/signup_prompt.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isSigning = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSigning = true);

      try {
        User? user = await _auth.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null && mounted) {
          Navigator.pushReplacementNamed(context, '/addDetails');
        }
      } finally {
        if (mounted) setState(() => _isSigning = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isSigning = true);

    try {
      User? user = await _auth.signInWithGoogle();

      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/addDetails');
      }
    } finally {
      if (mounted) setState(() => _isSigning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoginHeader(),
                const SizedBox(height: 30),
                EmailInputField(
                  controller: _emailController,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 10),
                PasswordInputField(
                  controller: _passwordController,
                  validator: _validatePassword,
                ),
                const ForgotPasswordButton(),
                const SizedBox(height: 20),
                LoginButton(
                  onPressed: _handleLogin,
                  isLoading: _isSigning,
                ),
                const SizedBox(height: 10),
                SocialSignInButton(
                  onPressed: _handleGoogleSignIn,
                  isLoading: _isSigning,
                ),
                const SizedBox(height: 20),
                const SignUpPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
