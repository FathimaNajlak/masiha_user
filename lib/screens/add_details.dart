import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masiha_user/providers/user_details_provider.dart';
import 'package:masiha_user/widgets/add_details/date_input.dart';
import 'package:masiha_user/widgets/add_details/gender_dropdown.dart';
import 'package:masiha_user/widgets/add_details/profile_image.dart';
import 'package:masiha_user/widgets/add_details/save_button.dart';
import 'package:masiha_user/widgets/add_details/text_input.dart';

import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UserDetailsPage extends StatelessWidget {
  const UserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add user Details'),
      ),
      body: Consumer<UserDetailsProvider>(
        builder: (context, UserDetailsProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: UserDetailsProvider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageWidget(provider: UserDetailsProvider),
                  const SizedBox(height: 24),
                  TextInputWidget(
                    label: 'Full Name',
                    onSaved: (value) =>
                        UserDetailsProvider.user.fullName = value,
                    validator: UserDetailsProvider.validateName,
                  ),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => UserDetailsProvider.user.age =
                        int.tryParse(value ?? ''),
                    validator: UserDetailsProvider.validateAge,
                  ),
                  const SizedBox(height: 16),
                  DateInputWidget(provider: UserDetailsProvider),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => UserDetailsProvider.user.email = value,
                    validator: UserDetailsProvider.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  GenderDropdownWidget(provider: UserDetailsProvider),
                  const SizedBox(height: 16),

                  const SizedBox(height: 16),
                  // AvailableDaysWidget(provider: UserDetailsProvider),
                  const SizedBox(height: 16),
                  // WorkingTimeWidget(provider: UserDetailsProvider),
                  const SizedBox(height: 16),

                  const SizedBox(height: 24),
                  NextButtonWidget(provider: UserDetailsProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
