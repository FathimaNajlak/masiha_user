import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:masiha_user/consts/stripe_keys.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<void> makePaymentForConsultation({
    required DoctorDetailsModel doctor,
    required DoctorDetailsProvider doctorProvider,
  }) async {
    try {
      // Fetch doctor's details to get consultation fee
      final doctorDetails =
          await doctorProvider.getDoctorAdditionalDetails(doctor);

      if (doctorDetails == null) {
        throw Exception('Could not fetch doctor details');
      }

      final consultationFee = doctorDetails['consultationFee'];
      if (consultationFee == null) {
        throw Exception('Consultation fee not set');
      }

      // Convert consultation fee to integer cents
      final amountInCents = (consultationFee * 100).round();

      String? paymentIntentClientSecret = await _createPaymentIntent(
        amountInCents,
        'inr', // Using INR since the consultation fee is in Rupees (₹)
      );

      if (paymentIntentClientSecret == null) {
        throw Exception('Failed to create payment intent');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Masiha Healthcare',
          // currency: 'INR', // Corrected parameter name from currencyCode to currency
        ),
      );

      await _processPayment();
    } catch (e) {
      rethrow; // Rethrow the error to be handled by the calling widget
    }
  }

  Future<String?> _createPaymentIntent(
      int amountInCents, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> body = {
        "amount": amountInCents.toString(),
        "currency": currency,
        "payment_method_types[]": "card"
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      if (e is StripeException) {
        throw Exception(e.error.localizedMessage);
      } else {
        throw Exception('Payment processing failed: $e');
      }
    }
  }
}
