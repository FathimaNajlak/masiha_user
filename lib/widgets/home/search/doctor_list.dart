import 'package:flutter/material.dart';
import 'package:masiha_user/providers/doctor_filter_provider.dart';
import 'package:masiha_user/widgets/home/doctor_card.dart';
import 'package:provider/provider.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<DoctorFilterProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filterProvider.filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = filterProvider.filteredDoctors[index];
        return DoctorCard(
          doctor: doctor,
          onFavorite: () {},
        );
      },
    );
  }
}
