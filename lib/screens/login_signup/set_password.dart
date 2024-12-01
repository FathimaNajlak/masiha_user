import 'package:flutter/material.dart';
import 'package:masiha_user/providers/set_password_provider.dart';
import 'package:masiha_user/widgets/set_pass/button.dart';
import 'package:masiha_user/widgets/set_pass/confirm_pass.dart';
import 'package:masiha_user/widgets/set_pass/pass_field.dart';
import 'package:provider/provider.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    print('Received email in SetPasswordScreen: $email'); // Debug print

    return ChangeNotifierProvider(
      create: (_) => SetPasswordProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Set Password',
            style: TextStyle(
              color: Color(0xFF7FBCD2),
              fontSize: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const PasswordField(),
                const SizedBox(height: 24),
                const ConfirmPasswordField(),
                const SizedBox(height: 32),
                CreatePasswordButton(email: email),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
