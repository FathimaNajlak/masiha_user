import 'package:flutter/material.dart';

class LoginWith extends StatelessWidget {
  const LoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'or sign up with',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFF5F7FB),
            child: Image.asset(
              'assets/images/google.png',
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}
