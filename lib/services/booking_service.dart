import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:path/path.dart';

import 'stripe_service.dart';

class BookingService {
  final StripeService _stripeService;

  BookingService(this._stripeService);

  Future<void> makeAppointmentPayment() async {
    try {
      await _stripeService.makePayement();
    } catch (e) {
      rethrow;
    }
  }
}
