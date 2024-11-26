import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor.dart';

class DoctorHeader extends StatelessWidget {
  final Doctor doctor;

  const DoctorHeader({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildDoctorHeader(doctor);
  }

  Widget _buildDoctorHeader(Doctor doctor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(doctor.imageUrl),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${doctor.specialty} | ${doctor.hospital}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$120.00',
                    style: TextStyle(
                      color: AppColors.darkcolor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
