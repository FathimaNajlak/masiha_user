import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class DateOption extends StatelessWidget {
  final String day;
  final bool isSelected;

  const DateOption({
    super.key,
    required this.day,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return dateOption(day, isSelected);
  }

  Widget dateOption(String day, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkcolor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey[300]!,
        ),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
