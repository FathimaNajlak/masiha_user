import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class ConsultationFeeCard extends StatelessWidget {
  final double? consultationFee;

  const ConsultationFeeCard({
    super.key,
    required this.consultationFee,
  });

  @override
  Widget build(BuildContext context) {
    if (consultationFee == null) return const SizedBox.shrink();

    return Card(
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
            const Row(
              children: [
                Icon(
                  Icons.payments_outlined,
                  color: AppColors.darkcolor,
                ),
                SizedBox(width: 8),
                Text(
                  'Consultation Fee',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkcolor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\$${consultationFee!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkcolor,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'per consultation',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}