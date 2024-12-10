import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor_details_model.dart';

class ExperienceEducationCard extends StatelessWidget {
  final DoctorDetailsModel doctor;

  const ExperienceEducationCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience & Education',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.titleText),
          ),
          const SizedBox(height: 16),
          _buildListTile(
            context,
            icon: Icons.work,
            text: '${doctor.yearOfExperience} Years of Experience',
          ),
          if (doctor.educations?.isNotEmpty ?? false) ...[
            const Divider(),
            ...doctor.educations!.map(
              (education) => _buildListTile(
                context,
                icon: Icons.school,
                text: education.degree ?? '',
                subtitle: education.institution ?? 'Unknown',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon, required String text, String? subtitle}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkcolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
          : null,
    );
  }
}
