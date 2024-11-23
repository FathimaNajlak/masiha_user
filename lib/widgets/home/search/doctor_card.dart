import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                doctor.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.hospital,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    doctor.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: doctor.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () =>
                      doctorProvider.toggleFavorite(doctor.id as int),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement booking functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightcolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
