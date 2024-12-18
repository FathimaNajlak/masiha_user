import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:masiha_user/models/doctor_details_model.dart';

class DoctorProfileCard extends StatelessWidget {
  final DoctorDetailsModel doctor;

  const DoctorProfileCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              child: doctor.imagePath != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: doctor.imagePath!,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    )
                  : const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.fullName ?? 'Unknown Doctor',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (doctor.specialty != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialty!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                  if (doctor.hospitalName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      doctor.hospitalName!,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
