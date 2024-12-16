import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class AvailabilityCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const AvailabilityCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Safely extract availability and working hours
    final Map<String, dynamic>? availability = profile['availability'];
    final Map<String, dynamic>? workingHours = profile['workingHours'];

    // Check if availability exists and is a map
    if (availability == null || availability.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkcolor, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Available Days
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
                children: availability.entries
                    .where((entry) => entry.value == true)
                    .map((entry) => Chip(
                          label: Text(entry.key),
                          backgroundColor: AppColors.lightcolor,
                        ))
                    .toList(),
              ),

              // Working Hours
              if (workingHours != null &&
                  workingHours['start'] != null &&
                  workingHours['end'] != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Working Hours:',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.titleText),
                ),
                const SizedBox(height: 8),
                Text(
                  '${workingHours['start']} - ${workingHours['end']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
