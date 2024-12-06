import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masiha_user/providers/user_details_provider.dart';

class DateInputWidget extends StatelessWidget {
  final UserDetailsProvider provider;

  const DateInputWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
      text: provider.user.dateOfBirth != null
          ? DateFormat('dd/MM/yyyy').format(provider.user.dateOfBirth!)
          : '',
    );

    return TextFormField(
      controller: dateController,
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          provider.user.dateOfBirth = date;
          dateController.text = DateFormat('dd/MM/yyyy').format(date);
        }
      },
      validator: (value) =>
          provider.user.dateOfBirth == null ? 'Please select a date' : null,
    );
  }
}
