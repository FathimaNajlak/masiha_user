import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/signup/form_container.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SignUpForm({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          FormContainerWidget(
            hintText: "Username",
            isPasswordField: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          FormContainerWidget(
            hintText: "Email",
            isPasswordField: false,
            inputType: TextInputType.emailAddress,
            validator: (value) {
              final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!emailPattern.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          FormContainerWidget(
            hintText: "Password",
            isPasswordField: true,
            validator: (value) {
              final passwordPattern = RegExp(r'^(?=.*\d)[A-Za-z\d]{6,}$');
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (!passwordPattern.hasMatch(value)) {
                return 'Password must be at least 6 characters long and include a digit';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
