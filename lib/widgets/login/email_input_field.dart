import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/login/form_input_widget.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;

  const EmailInputField({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormInputWidget(
      controller: controller,
      hintText: "Email",
      inputType: TextInputType.emailAddress,
      validator: validator,
    );
  }
}
