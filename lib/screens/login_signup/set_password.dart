import 'package:flutter/material.dart';
import 'package:masiha_user/providers/set_password_provider.dart';
import 'package:provider/provider.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 32),
                _PasswordField(),
                SizedBox(height: 24),
                _ConfirmPasswordField(),
                SizedBox(height: 32),
                _CreatePasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SetPasswordProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: provider.setPassword,
          obscureText: !provider.isPasswordVisible,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F7FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                provider.isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: provider.togglePasswordVisibility,
            ),
            errorText: provider.passwordError,
          ),
        ),
      ],
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SetPasswordProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: provider.setConfirmPassword,
          obscureText: !provider.isConfirmPasswordVisible,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F7FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                provider.isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: provider.toggleConfirmPasswordVisibility,
            ),
            errorText: provider.confirmPasswordError,
          ),
        ),
      ],
    );
  }
}

class _CreatePasswordButton extends StatelessWidget {
  const _CreatePasswordButton();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SetPasswordProvider>();

    return ElevatedButton(
      onPressed: provider.isLoading
          ? null
          : () async {
              if (await provider.createNewPassword()) {
                // Navigate to next screen or show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password created successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7FBCD2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: provider.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'Create New Password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
