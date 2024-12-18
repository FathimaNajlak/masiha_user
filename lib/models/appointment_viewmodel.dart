import '../services/booking_service.dart';
import 'package:flutter/material.dart';

class AppointmentViewModel extends ChangeNotifier {
  final BookingService _bookingService;

  AppointmentViewModel(this._bookingService);

  Future<void> confirmAppointment(BuildContext context) async {
    try {
      await _bookingService.makeAppointmentPayment();
      Navigator.pushNamed(context, '/payment_confirmation');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }
}
