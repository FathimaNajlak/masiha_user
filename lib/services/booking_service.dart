import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';
import 'package:masiha_user/services/stripe_service.dart';

class BookingService {
  final StripeService _stripeService;
  final DoctorDetailsProvider _doctorProvider;

  BookingService({
    required StripeService stripeService,
    required DoctorDetailsProvider doctorProvider,
  })  : _stripeService = stripeService,
        _doctorProvider = doctorProvider;

  Future<void> makeAppointmentPayment({
    required DoctorDetailsModel doctor,
  }) async {
    try {
      await _stripeService.makePaymentForConsultation(
        doctor: doctor,
        doctorProvider: _doctorProvider,
      );
    } catch (e) {
      throw Exception('Payment failed: ${e.toString()}');
    }
  }
}
