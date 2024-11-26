import 'package:flutter/material.dart';
import 'package:masiha_user/providers/signup_provider.dart';

import 'package:masiha_user/widgets/login/login_with.dart';
import 'package:masiha_user/widgets/signup/existing_account.dart';
import 'package:masiha_user/widgets/signup/gender_drop_down.dart';
import 'package:masiha_user/widgets/signup/profile_image_field.dart';
import 'package:masiha_user/widgets/signup/signup_form/costum_form_field.dart';
import 'package:masiha_user/widgets/signup/signup_form/date_of_birth.dart';
import 'package:masiha_user/widgets/signup/signup_form/next_button.dart';
import 'package:provider/provider.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: provider.getFormKey,
        child: Column(
          children: [
            ProfileImageField(
              onImageSelected: provider.setProfileImage,
              errorText: provider.profileImage == null
                  ? 'Please select a profile image'
                  : null,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              labelText: 'Full Name',
              onChanged: (value) => provider.setFormData(fullName: value),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter your full name' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Age',
              keyboardType: TextInputType.number,
              onChanged: (value) => provider.setFormData(age: value),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your age';
                }
                final age = int.tryParse(value!);
                if (age == null || age < 0) {
                  return 'Please enter a valid age';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DateOfBirthField(
              controller: provider.dateController,
              onDateSelected: (date) => provider.setFormData(dateOfBirth: date),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please select your date of birth'
                  : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => provider.setFormData(email: value),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            GenderDropdown(
              onChanged: (value) => provider.setFormData(gender: value),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select your gender'
                  : null,
            ),
            const SizedBox(height: 24),
            NextButton(
              onPressed: provider.isFormValid
                  ? () {
                      if (provider.getFormKey.currentState!.validate()) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushNamed(context, '/home');
                        });
                      }
                    }
                  : null,
            ),
            const SizedBox(height: 16),
            const LoginWith(),
            const SizedBox(height: 16),
            const ExistingAccountPrompt(),
          ],
        ),
      ),
    );
  }
}
