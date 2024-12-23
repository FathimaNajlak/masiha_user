import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';
import 'package:masiha_user/screens/booking/availability_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          title: const Text('Appointment',
              style: TextStyle(color: Colors.black, fontSize: 18)),
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

                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDoctorHeader(context, consultationFee),
                              const SizedBox(height: 16),
                              if (additionalDetails?['bio'] != null)
                                _buildDetails(additionalDetails!['bio']),
                              const SizedBox(height: 35),
                              if (additionalDetails?['availability'] != null)
                                _buildWorkingHours(additionalDetails!),
                              const SizedBox(height: 35),
                              if (additionalDetails?['availability'] != null)
                                _buildDateSelection(
                                    additionalDetails!['availability']),
                              const SizedBox(height: 35),
                            ],
                          ),
                        ),
                      ),
                      _buildBookButton(context, consultationFee),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDoctorHeader(BuildContext context, double consultationFee) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: doctor.imagePath != null
                ? CachedNetworkImage(
                    imageUrl: doctor.imagePath!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${doctor.fullName ?? ""}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${doctor.specialty ?? ""} | ${doctor.hospitalName ?? ""}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (consultationFee > 0)
                      Text(
                        '₹${consultationFee.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkcolor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(String bio) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bio,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHours(Map<String, dynamic> additionalDetails) {
    final workingHours = additionalDetails['workingHours'] ?? {};
    final String startTime = workingHours['start'] ?? '';
    final String endTime = workingHours['end'] ?? '';

    // Create a list of hours between start and end time
    List<String> timeSlots = [];
    if (startTime.isNotEmpty && endTime.isNotEmpty) {
      // Convert times to hours for display
      timeSlots = [startTime, endTime];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Working Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: timeSlots.map((time) => _buildTimeChip(time)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(time),
        backgroundColor: AppColors.darkcolor,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDateSelection(Map<String, dynamic> availability) {
    // Filter only available days
    List<String> availableDays = availability.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableDays
                  .map((day) => _buildDateChip(day, availableDays.first == day))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(String day, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(day),
        backgroundColor: Colors.grey[200],
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildBookButton(BuildContext context, double consultationFee) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: consultationFee > 0
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvialabilityScreen(doctor: doctor),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkcolor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          consultationFee > 0
              ? 'Book an Appointment'
              : 'Consultation fee not set',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
