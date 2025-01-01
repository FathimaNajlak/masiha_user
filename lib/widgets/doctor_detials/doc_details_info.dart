import 'package:flutter/material.dart';

class DoctorDetailsInfo extends StatelessWidget {
  final Map<String, dynamic>? additionalDetails;

  const DoctorDetailsInfo({
    super.key,
    required this.additionalDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (additionalDetails == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (additionalDetails?['bio'] != null)
          _buildDetails(additionalDetails!['bio']),
        const SizedBox(height: 35),
      ],
    );
  }

  Widget _buildDetails(String bio) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bio,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
