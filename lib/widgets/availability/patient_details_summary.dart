import 'package:flutter/material.dart';
import 'package:masiha_user/providers/booking_provider.dart';
import 'package:masiha_user/widgets/availability/patient_details_dialogue.dart';

class PatientDetailsCard extends StatelessWidget {
  final BookingProvider provider;

  const PatientDetailsCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Patient Details'),
          trailing: TextButton.icon(
            icon: Icon(
              provider.patientDetails != null ? Icons.edit : Icons.add,
            ),
            label: Text(provider.patientDetails != null
                ? 'Edit Details'
                : 'Add Details'),
            onPressed: () {
              showPatientDetailsDialog(context, provider);
            },
          ),
        ),
        if (provider.patientDetails != null)
          ListTile(
            title: Text(provider.patientDetails!.name),
            subtitle: Text(
                'Age: ${provider.patientDetails!.age}, Issue: ${provider.patientDetails!.issue}'),
          ),
      ],
    );
  }
}
