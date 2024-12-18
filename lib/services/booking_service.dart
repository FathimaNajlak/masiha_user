import 'stripe_service.dart';

class BookingService {
  final StripeService _stripeService;

  BookingService(this._stripeService);

  Future<void> makeAppointmentPayment() async {
    try {
      await _stripeService.makePayement();
    } catch (e) {
      rethrow; // Re-throws error to handle at UI level
    }
  }
}
