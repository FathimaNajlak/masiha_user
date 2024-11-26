import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Icon? suffixIcon;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.validator,
    this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
