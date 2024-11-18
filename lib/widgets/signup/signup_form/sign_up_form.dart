import 'package:flutter/material.dart';
import 'package:masiha_user/providers/signup_provider.dart';
import 'package:masiha_user/widgets/signup/signup_form/date_field.dart';
import 'package:masiha_user/widgets/signup/signup_form/gender_dropdown.dart';
import 'package:masiha_user/widgets/signup/signup_form/text_field.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTextField(label: 'Full Name'),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Age'),
            const SizedBox(height: 16),
            DateField(provider: provider),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Email'),
            const SizedBox(height: 16),
            GenderDropdown(provider: provider)
          ],
        );
      },
    );
  }
}
