import 'package:flutter/material.dart';
import 'package:masiha_user/providers/set_password_provider.dart';
import 'package:provider/provider.dart';

class CreatePasswordButton extends StatelessWidget {
  final String email;

  const CreatePasswordButton({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SetPasswordProvider>(
      builder: (context, provider, _) {
        return ElevatedButton(
          onPressed: provider.isLoading
              ? null
              : () async {
                  final success = await provider.createNewPassword(email);
                  if (success) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account created successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Navigate to login screen
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7FBCD2),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: provider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }
}
