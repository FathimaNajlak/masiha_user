import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;

  const CustomButton({
    required this.text,
    this.isLoading = false,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: isLoading
              ? Colors.grey[300]
              : backgroundColor ?? AppColors.darkcolor,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize ?? 14,
                  ),
                ),
        ),
      ),
    );
  }
}
