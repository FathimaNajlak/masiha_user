import 'package:flutter/material.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/widgets/home/search_delegate.dart';

class DoctorSearchBar extends StatelessWidget {
  const DoctorSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DoctorDetailsModel? selectedDoctor = await showSearch(
          context: context,
          delegate: DoctorSearchDelegate(),
        );

        if (selectedDoctor != null && context.mounted) {
          // Navigate to doctor details page
          Navigator.pushNamed(
            context,
            '/doctor-details',
            arguments: selectedDoctor,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              'Search doctors..',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
