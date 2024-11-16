import 'package:flutter/material.dart';
import 'package:masiha_user/providers/onboardings/onboarding_provider.dart';
import 'package:masiha_user/screens/onboards/onboard2/onboard2_view.dart';
import 'package:provider/provider.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const Onboarding2View(),
    );
  }
}
