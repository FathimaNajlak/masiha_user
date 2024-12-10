import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class AboutDoctorCard extends StatelessWidget {
  final String bio;

  const AboutDoctorCard({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightcolor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Doctor',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.titleText),
            ),
            const SizedBox(height: 16),
            Text(
              bio,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
