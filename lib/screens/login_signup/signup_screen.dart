import 'package:flutter/material.dart';

import 'package:masiha_user/widgets/signup/footer.dart';
import 'package:masiha_user/widgets/signup/header.dart';
import 'package:masiha_user/widgets/signup/signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignUpHeader(), // Header Section
                SizedBox(height: 30),
                SignUpForm(), // Form Section
                SizedBox(height: 30),
                SignUpFooter(), // Footer Section
              ],
            ),
          ),
        ),
      ),
    );
  }
}
