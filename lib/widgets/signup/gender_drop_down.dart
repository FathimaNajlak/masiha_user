import 'package:flutter/material.dart';

class GenderDropdown extends StatelessWidget {
  final String? value;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

  const GenderDropdown({
    super.key,
    this.value,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      value: value,
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
