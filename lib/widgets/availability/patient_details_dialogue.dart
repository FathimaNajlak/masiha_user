import 'package:flutter/material.dart';
import 'package:masiha_user/providers/booking_provider.dart';

void showPatientDetailsDialog(BuildContext context, BookingProvider provider) {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final issueController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  if (provider.patientDetails != null) {
    nameController.text = provider.patientDetails!.name;
    ageController.text = provider.patientDetails!.age.toString();
    issueController.text = provider.patientDetails!.issue;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Patient Details'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextFormField(
                controller: issueController,
                decoration: const InputDecoration(labelText: 'Medical Issue'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                provider.setPatientDetails(
                  PatientDetails(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    issue: issueController.text,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
