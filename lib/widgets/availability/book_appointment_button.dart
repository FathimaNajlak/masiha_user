import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/providers/booking_provider.dart';

class BookAppointmentButton extends StatelessWidget {
  final BookingProvider provider;

  const BookAppointmentButton({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: (provider.selectedDate != null &&
                provider.selectedTimeSlot != null &&
                provider.patientDetails != null)
            ? () => provider.bookAppointment(context)
            : null, // Disable the button if conditions are not met
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkcolor,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
