import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/booking/success_animation_widget.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key});

  void _onViewAppointmentPressed(BuildContext context) {
    Navigator.pushNamed(context, '/appointmentDetails');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SuccessAnimationWidget(
          onViewAppointmentPressed: () => _onViewAppointmentPressed(context),
        ),
      ),
    );
  }
}
