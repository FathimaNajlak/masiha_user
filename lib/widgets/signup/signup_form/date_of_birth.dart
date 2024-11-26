import 'package:flutter/material.dart';

class DateOfBirthField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onDateSelected;
  final String? Function(String?)? validator;

  const DateOfBirthField({
    super.key,
    required this.controller,
    required this.onDateSelected,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF79B3D4),
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          final formattedDate =
              "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          controller.text = formattedDate;
          onDateSelected(formattedDate);
        }
      },
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
  }
}
