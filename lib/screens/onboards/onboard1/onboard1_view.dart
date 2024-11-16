import 'package:flutter/material.dart';
import 'package:masiha_user/models/onboardings/onboarding1_model.dart';
import 'package:masiha_user/screens/onboards/common/onboard_control.dart';
import 'package:masiha_user/screens/onboards/common/onboard_page.dart';
import 'package:provider/provider.dart';
import 'package:masiha_user/providers/onboardings/onboarding_provider.dart';

class Onboarding1View extends StatelessWidget {
  const Onboarding1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  context.read<OnboardingProvider>().setPage(index);
                },
                itemCount: onboarding1Data.length,
                itemBuilder: (context, index) {
                  return Onboarding1Page(content: onboarding1Data[index]);
                },
              ),
            ),
            const OnboardingControls(),
          ],
        ),
      ),
    );
  }
}
