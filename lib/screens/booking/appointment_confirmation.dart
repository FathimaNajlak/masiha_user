import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/appointment_viewmodel.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/booking_provider.dart';
import 'package:masiha_user/services/booking_service.dart';
import 'package:masiha_user/services/stripe_service.dart';
import 'package:masiha_user/widgets/booking/appointment_details_card.dart';
import 'package:masiha_user/widgets/booking/doctor_profile_card.dart';
import 'package:masiha_user/widgets/booking/patient_details_card.dart';
import 'package:masiha_user/widgets/costum_button.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;
  final DateTime appointmentDate;
  final String appointmentTime;
  final PatientDetails patientDetails;

  final AppointmentViewModel _viewModel =
      AppointmentViewModel(BookingService(StripeService.instance));

  AppointmentConfirmationScreen({
    super.key,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.patientDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Confirmation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DoctorProfileCard(doctor: doctor),
            const SizedBox(height: 20),
            PatientDetailsCard(patientDetails: patientDetails),
            const SizedBox(height: 20),
            AppointmentDetailsCard(
              appointmentDate: appointmentDate,
              appointmentTime: appointmentTime,
              consultationFee: doctor.consultationFees,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Confirm Appointment',
              isLoading: false, // You can toggle this based on some state
              onTap: () => _viewModel.confirmAppointment(
                context,
              ),
              backgroundColor: AppColors.darkcolor,
              textColor: Colors.white,
              fontSize: 16,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}
