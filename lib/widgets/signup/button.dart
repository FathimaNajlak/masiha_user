import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/services/firebase_auth_service.dart';

class SignUpButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool isSigningUp = false;

  Future<void> _signUp() async {
    if (!widget.formKey.currentState!.validate()) {
      return; // Exit if validation fails
    }

    setState(() {
      isSigningUp = true;
    });

    try {
      await _auth.signUpWithEmailAndPassword(
        widget.emailController.text.trim(),
        widget.passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User successfully created")),
        );
        Navigator.pushNamed(context, "/allset");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSigningUp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSigningUp ? null : _signUp,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.darkcolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isSigningUp
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
