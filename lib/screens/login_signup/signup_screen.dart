import 'package:flutter/material.dart';
import 'package:masiha_user/providers/signup_provider.dart';
import 'package:masiha_user/widgets/login/login_with.dart';
import 'package:masiha_user/widgets/login/pick_image.dart';
import 'package:masiha_user/widgets/signup/header.dart';
import 'package:masiha_user/widgets/signup/login.dart';
import 'package:masiha_user/widgets/signup/next_button.dart';
import 'package:masiha_user/widgets/signup/signup_form/sign_up_form.dart';
import 'package:masiha_user/widgets/signup/terms_and_co.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Header(),
                SizedBox(height: 15),
                Center(child: ProfileImagePicker()),
                SizedBox(height: 15),
                SignUpForm(),
                SizedBox(height: 15),
                TermsAndCo(),
                SizedBox(height: 15),
                NextButton(),
                SizedBox(height: 15),
                LoginWith(),
                // const SizedBox(height: 5.0),
                Login(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
