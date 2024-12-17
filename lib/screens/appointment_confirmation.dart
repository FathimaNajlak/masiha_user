import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/screens/booking_form.dart';
import 'package:provider/provider.dart';
import 'package:masiha_user/providers/booking_provider.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;
  final DateTime appointmentDate;
  final String appointmentTime;

  const AppointmentConfirmationScreen({
    super.key,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Appointment'),
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

              // Appointment Details Card
              _buildAppointmentDetailsCard(),

              const SizedBox(height: 30),

              // Confirm Button
              _buildConfirmButton(context),
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
        child: Row(
          children: [
            // Doctor Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: doctor.imagePath != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: doctor.imagePath!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const Icon(Icons.person, size: 50, color: Colors.white),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  if (doctor.hospitalName != null)
                    Text(
                      doctor.hospitalName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                ],
              ),
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
      onPressed: () => _confirmAppointment(context),
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

  void _confirmAppointment(BuildContext context) {
    final bookingProvider = BookingProvider(doctor);
    bookingProvider.selectedDate = appointmentDate;
    bookingProvider.selectedTimeSlot = appointmentTime;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: bookingProvider,
          child: Builder(
            builder: (context) => BookAppointmentScreen(
              bookingProvider: Provider.of<BookingProvider>(
                context,
                listen: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
