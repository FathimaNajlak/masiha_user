import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/widgets/login/button.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: "Login",
      onPressed: onPressed,
      isLoading: isLoading,
      color: AppColors.darkcolor,
    );
  }
}
