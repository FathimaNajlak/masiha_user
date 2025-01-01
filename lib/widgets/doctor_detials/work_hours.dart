import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class WorkingHours extends StatelessWidget {
  final Map<String, dynamic> additionalDetails;

  const WorkingHours({
    super.key,
    required this.additionalDetails,
  });

  @override
  Widget build(BuildContext context) {
    final workingHours = additionalDetails['workingHours'] ?? {};
    final String startTime = workingHours['start'] ?? '';
    final String endTime = workingHours['end'] ?? '';

    // Create a list of hours between start and end time
    List<String> timeSlots = [];
    if (startTime.isNotEmpty && endTime.isNotEmpty) {
      // Convert times to hours for display
      timeSlots = [startTime, endTime];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Working Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: timeSlots.map((time) => _buildTimeChip(time)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(time),
        backgroundColor: AppColors.darkcolor,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
