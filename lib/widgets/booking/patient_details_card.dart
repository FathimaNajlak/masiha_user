import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/providers/booking_provider.dart';

class PatientDetailsCard extends StatelessWidget {
  final PatientDetails patientDetails;

  const PatientDetailsCard({super.key, required this.patientDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.darkcolor)),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.person, 'Name', patientDetails.name),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.cake, 'Age', '${patientDetails.age} years'),
            const SizedBox(height: 12),
            _buildDetailRow(
                Icons.medical_services, 'Medical Issue', patientDetails.issue),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.darkcolor, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
