import 'package:flutter/material.dart';
import 'package:masiha_user/providers/user_details_provider.dart';

class GenderDropdownWidget extends StatelessWidget {
  final UserDetailsProvider provider;

  const GenderDropdownWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      onChanged: (value) => provider.user.gender = value,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Please select a gender' : null,
    );
  }
}
