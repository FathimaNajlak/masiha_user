import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/booking_provider.dart';
import 'package:masiha_user/screens/booking/payment_confirmation_screen.dart';
import 'package:masiha_user/services/stripe_service.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;
  final DateTime appointmentDate;
  final String appointmentTime;
  final PatientDetails patientDetails;

  const AppointmentConfirmationScreen({
    super.key,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.patientDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Doctor Profile Card
              _buildDoctorProfileCard(context),

              const SizedBox(height: 20),

              // Patient Details Card
              _buildPatientDetailsCard(context),

              const SizedBox(height: 20),

              // Appointment Details Card
              _buildAppointmentDetailsCard(),

              const SizedBox(height: 30),

              // Confirm Button
              _buildConfirmButton(
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorProfileCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkcolor,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Doctor Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: doctor.imagePath != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: doctor.imagePath!,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.person, size: 40, color: Colors.white),
                ),

                const SizedBox(width: 16),

                // Doctor Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.fullName ?? 'Unknown Doctor',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      if (doctor.specialty != null)
                        Text(
                          doctor.specialty!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      if (doctor.hospitalName != null)
                        Text(
                          doctor.hospitalName!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetailsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkcolor,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.person,
              title: 'Name',
              value: patientDetails.name,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.cake,
              title: 'Age',
              value: '${patientDetails.age} years',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.medical_services,
              title: 'Medical Issue',
              value: patientDetails.issue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkcolor,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.calendar_today,
              title: 'Date',
              value: DateFormat('EEEE, MMM d, yyyy').format(appointmentDate),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.access_time,
              title: 'Time',
              value: appointmentTime,
            ),
            const SizedBox(height: 12),
            if (doctor.consultationFees != null)
              _buildDetailRow(
                icon: Icons.attach_money,
                title: 'Consultation Fee',
                value: '\$${doctor.consultationFees!.toStringAsFixed(2)}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.darkcolor, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Attempt to make payment
          await StripeService.instance.makePayement();

          // Navigate to confirmation screen only if payment is successful
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PaymentConfirmationScreen()),
          );
        } catch (e) {
          // Optionally handle any payment errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed: $e')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.darkcolor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: const Text('Confirm Appointment'),
    );
  }
}
