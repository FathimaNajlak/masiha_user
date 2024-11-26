import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class TimeSlot extends StatelessWidget {
  final String time;
  final bool isSelected;

  const TimeSlot({
    super.key,
    required this.time,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return timeSlot(time, isSelected);
  }

  Widget timeSlot(String time, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkcolor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey[300]!,
        ),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
