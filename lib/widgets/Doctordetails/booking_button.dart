import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';

class BookingButton extends StatelessWidget {
  const BookingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return bookButton();
  }

  Widget bookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkcolor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Book an Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
