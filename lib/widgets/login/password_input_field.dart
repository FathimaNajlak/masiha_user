import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/login/form_input_widget.dart';

class PasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormInputWidget(
      controller: controller,
      hintText: "Password",
      isPasswordField: true,
      inputType: TextInputType.visiblePassword,
      validator: validator,
    );
  }
}
