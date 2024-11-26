import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/signup/signup_form/sign_up_form.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: RegistrationForm(),
      ),
    );
  }
}
