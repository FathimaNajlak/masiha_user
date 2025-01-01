import 'package:flutter/material.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';
import 'package:masiha_user/widgets/doctor_detials/book_button.dart';
import 'package:masiha_user/widgets/doctor_detials/date_selection.dart';
import 'package:masiha_user/widgets/doctor_detials/doc_details_header.dart';
import 'package:masiha_user/widgets/doctor_detials/doc_details_info.dart';
import 'package:masiha_user/widgets/doctor_detials/work_hours.dart';
import 'package:provider/provider.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorDetailsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Appointment',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<DoctorDetailsProvider>(
          builder: (context, doctorProvider, _) {
            return FutureBuilder<Map<String, dynamic>?>(
              future: doctorProvider.getDoctorAdditionalDetails(doctor),
              builder: (context, snapshot) {
                if (doctorProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (doctorProvider.error != null) {
                  return Center(child: Text(doctorProvider.error!));
                }

                final additionalDetails = snapshot.data;
                final double consultationFee = doctor.consultationFees ??
                    (additionalDetails?['consultationFee']?.toDouble() ?? 0.0);

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DoctorDetailsHeader(
                              doctor: doctor,
                              consultationFee: consultationFee,
                            ),
                            DoctorDetailsInfo(
                              additionalDetails: additionalDetails,
                            ),
                            if (additionalDetails?['workingHours'] != null)
                              WorkingHours(
                                  additionalDetails: additionalDetails!),
                            if (additionalDetails?['availability'] != null)
                              DateSelection(
                                  availability:
                                      additionalDetails!['availability']),
                          ],
                        ),
                      ),
                    ),
                    BookButton(
                      consultationFee: consultationFee,
                      doctor: doctor,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
