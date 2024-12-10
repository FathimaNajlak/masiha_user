import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class AvailabilityCard extends StatelessWidget {
  final Map<String, dynamic> availability;

  const AvailabilityCard({super.key, required this.availability});

  String _formatTime(Map<String, dynamic> time) {
    final hour = time['hour'] as int;
    final minute = time['minute'] as int;
    final timeOfDay = TimeOfDay(hour: hour, minute: minute);
    final hourOf12 = timeOfDay.hourOfPeriod;
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hourOf12 == 0 ? 12 : hourOf12}:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (availability['days'] != null) ...[
            Text(
              'Available Days:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.titleText),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (availability['days'] as Map<String, dynamic>)
                  .entries
                  .where((e) => e.value == true)
                  .map((e) => Chip(label: Text(e.key)))
                  .toList(),
            ),
          ],
          const SizedBox(height: 16),
          if (availability['startTime'] != null &&
              availability['endTime'] != null) ...[
            Text(
              'Working Hours:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.titleText),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatTime(availability['startTime'])} - ${_formatTime(availability['endTime'])}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }
}
