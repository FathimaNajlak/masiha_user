import 'package:flutter/material.dart';

class FormInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final bool isPasswordField;
  final String? Function(String?) validator;

  const FormInputWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.inputType,
    this.isPasswordField = false,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPasswordField,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}
