import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/screens/booking/availability_screen.dart';
import 'package:masiha_user/services/stripe_service.dart';

class BookButton extends StatelessWidget {
  final double consultationFee;
  final DoctorDetailsModel doctor;

  const BookButton({
    super.key,
    required this.consultationFee,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
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
// class BookButton extends StatelessWidget {
//   final double consultationFee;
//   final DoctorDetailsModel doctor;

//   const BookButton({
//     super.key,
//     required this.consultationFee,
//     required this.doctor,
//   });

//   Future<void> _handlePaymentAndNavigation(BuildContext context) async {
//     try {
//       await StripeService.instance
//           .makePayment(consultationFee: consultationFee);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AvialabilityScreen(doctor: doctor),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment failed: ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, -3),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: consultationFee > 0
//             ? () => _handlePaymentAndNavigation(context)
//             : null,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.darkcolor,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: Text(
//           consultationFee > 0
//               ? 'Book an Appointment'
//               : 'Consultation fee not set',
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
