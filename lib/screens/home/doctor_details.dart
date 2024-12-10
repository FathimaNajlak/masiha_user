import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/widgets/doctor_detials/cards/about_doctor_card.dart';
import 'package:masiha_user/widgets/doctor_detials/availability_card.dart';
import 'package:masiha_user/widgets/doctor_detials/cards/doctor_profile_card.dart';
import 'package:masiha_user/widgets/doctor_detials/doctorprofilewithbio.dart';
import 'package:masiha_user/widgets/doctor_detials/experience_education_card.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  Future<Map<String, dynamic>?> _loadAdditionalDetails() async {
    try {
      final requestDoc = await FirebaseFirestore.instance
          .collection('doctorRequests')
          .doc(doctor.requestId)
          .get();

      if (!requestDoc.exists) return null;

      final userId = requestDoc.data()?['userId'];
      if (userId == null) return null;

      final docSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error loading doctor details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dr. ${doctor.fullName}'),
        backgroundColor:
            Colors.transparent, // Ensure AppBar blends with gradient
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _loadAdditionalDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final additionalDetails = snapshot.data;

          return Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 236, 250, 255)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // // Profile Card
                  // DoctorProfileCard(doctor: doctor),

                  // About Doctor
                  if (additionalDetails?['bio'] != null)
                    // AboutDoctorCard(bio: additionalDetails?['bio']),
                    DoctorProfileWithBioCard(
                        doctor: doctor, bio: additionalDetails?['bio']),
                  const SizedBox(height: 24),

                  // Experience and Education
                  ExperienceEducationCard(doctor: doctor),
                  const SizedBox(height: 16),

                  // Availability
                  if (additionalDetails?['availability'] != null)
                    Center(
                      child: AvailabilityCard(
                          availability: additionalDetails?['availability']),
                    ),
                  const SizedBox(height: 32),

                  // Book Appointment Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/book-appointment',
                          arguments: doctor,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: AppColors.darkcolor, // Deep Blue Border
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        'Book Appointment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkcolor, // Deep Blue Text
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
