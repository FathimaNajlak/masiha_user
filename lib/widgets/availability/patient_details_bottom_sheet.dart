// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:masiha_user/consts/colors.dart';
// import 'package:masiha_user/providers/booking_provider.dart';

// class PatientDetailsBottomSheet extends StatelessWidget {
//   final BookingProvider provider;

//   const PatientDetailsBottomSheet({super.key, required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     final nameController = TextEditingController();
//     final ageController = TextEditingController();
//     final issueController = TextEditingController();
//     final formKey = GlobalKey<FormState>();

//     // Prefill data if available
//     if (provider.patientDetails != null) {
//       nameController.text = provider.patientDetails!.name;
//       ageController.text = provider.patientDetails!.age.toString();
//       issueController.text = provider.patientDetails!.issue;
//     }

//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 16,
//         right: 16,
//         top: 16,
//       ),
//       child: Form(
//         key: formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Patient Name',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter patient name';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: ageController,
//               decoration: const InputDecoration(
//                 labelText: 'Patient Age',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter patient age';
//                 }
//                 final age = int.parse(value);
//                 if (age < 0 || age > 120) {
//                   return 'Please enter a valid age';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: issueController,
//               decoration: const InputDecoration(
//                 labelText: 'Medical Issue',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please describe the medical issue';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
//               label: const Text('Save'),
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   // Save patient details
//                   final patientDetails = PatientDetails(
//                     name: nameController.text,
//                     age: int.parse(ageController.text),
//                     issue: issueController.text,
//                   );
//                   provider.setPatientDetails(patientDetails);
//                   Navigator.of(context).pop(); // Close bottom sheet
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.darkcolor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/providers/booking_provider.dart';

class PatientDetailsBottomSheet extends StatelessWidget {
  final BookingProvider provider;

  const PatientDetailsBottomSheet({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final issueController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Prefill data if available
    if (provider.patientDetails != null) {
      nameController.text = provider.patientDetails!.name;
      ageController.text = provider.patientDetails!.age.toString();
      issueController.text = provider.patientDetails!.issue;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add a drag handle at the top
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Patient Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient age';
                  }
                  final age = int.parse(value);
                  if (age < 0 || age > 120) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: issueController,
                decoration: const InputDecoration(
                  labelText: 'Medical Issue',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe the medical issue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
                  label: const Text('Save'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Save patient details
                      final patientDetails = PatientDetails(
                        name: nameController.text,
                        age: int.parse(ageController.text),
                        issue: issueController.text,
                      );
                      provider.setPatientDetails(patientDetails);
                      Navigator.of(context).pop(); // Close bottom sheet
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkcolor,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
