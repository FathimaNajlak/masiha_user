import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masiha_user/consts/colors.dart';

class AppointmentDetailsCard extends StatelessWidget {
  final DateTime appointmentDate;
  final String appointmentTime;
  final double? consultationFee;

  const AppointmentDetailsCard({
    super.key,
    required this.appointmentDate,
    required this.appointmentTime,
    this.consultationFee,
  });

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
            Text(
              'Appointment Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkcolor,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.calendar_today,
              'Date',
              DateFormat('EEEE, MMM d, yyyy').format(appointmentDate),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.access_time, 'Time', appointmentTime),
            const SizedBox(height: 12),
            if (consultationFee != null)
              _buildDetailRow(
                Icons.attach_money,
                'Consultation Fee',
                '\$${consultationFee!.toStringAsFixed(2)}',
              ),
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
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
