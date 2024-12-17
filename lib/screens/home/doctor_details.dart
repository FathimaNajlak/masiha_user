import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';
import 'package:masiha_user/screens/availability_screen.dart';
import 'package:masiha_user/widgets/doctor_detials/cards/availability_card.dart';
import 'package:masiha_user/widgets/doctor_detials/cards/consultation_fee_card.dart';
import 'package:masiha_user/widgets/doctor_detials/doctorprofilewithbio.dart';
import 'package:masiha_user/widgets/doctor_detials/experience_education_card.dart';
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
          title: Text('Dr. ${doctor.fullName ?? ""}'),
          backgroundColor: Colors.transparent,
          elevation: 0,
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

                return Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 236, 250, 255),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (additionalDetails?['bio'] != null)
                          DoctorProfileWithBioCard(
                            doctor: doctor,
                            bio: additionalDetails!['bio'],
                          ),
                        const SizedBox(height: 24),

                        ExperienceEducationCard(doctor: doctor),

                        if (additionalDetails?['availability'] != null)
                          Center(
                            child: AvailabilityCard(
                              profile: {
                                'availability':
                                    additionalDetails!['availability'],
                                'workingHours': {
                                  'start': additionalDetails['workingHours']
                                          ?['start'] ??
                                      '',
                                  'end': additionalDetails['workingHours']
                                          ?['end'] ??
                                      '',
                                },
                              },
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Use the consultation fee from either source
                        ConsultationFeeCard(
                          profile: {
                            'consultationFee': doctor.consultationFees ??
                                additionalDetails?['consultationFee']
                                    ?.toDouble() ??
                                0.0,
                          },
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (doctor.consultationFees != null ||
                                    additionalDetails?['consultationFee'] !=
                                        null)
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AvialabilityScreen(doctor: doctor),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: AppColors.darkcolor,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              (doctor.consultationFees != null ||
                                      additionalDetails?['consultationFee'] !=
                                          null)
                                  ? 'Book Appointment'
                                  : 'Consultation fee not set',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkcolor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
