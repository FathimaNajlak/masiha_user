import 'package:flutter/material.dart';

class ExistingAccountPrompt extends StatelessWidget {
  const ExistingAccountPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text(
            'Log in',
            style: TextStyle(
              color: Color(0xFF79B3D4),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
