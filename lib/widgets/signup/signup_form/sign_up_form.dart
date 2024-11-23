import 'package:flutter/material.dart';
import 'package:masiha_user/providers/signup_provider.dart';
import 'package:masiha_user/widgets/signup/signup_form/date_field.dart';
import 'package:masiha_user/widgets/signup/signup_form/gender_dropdown.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SignUpForm({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF78A6B8)),
                  ),
                ),
                onChanged: (value) {
                  provider.setFullName(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF78A6B8)),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    provider.setAge(int.parse(value));
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DateField(provider: provider),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF78A6B8)),
                  ),
                ),
                onChanged: (value) {
                  provider.setEmail(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GenderDropdown(provider: provider),
            ],
          ),
        );
      },
    );
  }
}
