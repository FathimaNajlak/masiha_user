import 'package:flutter/material.dart';

import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/widgets/Doctordetails/booking_button.dart';
import 'package:masiha_user/widgets/Doctordetails/details.dart';
import 'package:masiha_user/widgets/Doctordetails/header.dart';
import 'package:masiha_user/widgets/Doctordetails/select_date.dart';
import 'package:masiha_user/widgets/Doctordetails/working_hours.dart';
import 'package:provider/provider.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final String doctorId;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctor =
        doctorProvider.doctors.firstWhere((doc) => doc.id == doctorId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Appointment',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorHeader(
              doctor: doctor,
            ),
            const SizedBox(height: 40),
            const DoctorDetails(),
            const SizedBox(height: 40),
            const WorkingHours(),
            const SizedBox(height: 40),
            const SelectDate(),
            const SizedBox(height: 40),
            const BookingButton(),
          ],
        ),
      ),
    );
  }
}
