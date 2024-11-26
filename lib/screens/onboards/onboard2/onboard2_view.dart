import 'package:flutter/material.dart';
import 'package:masiha_user/models/onboardings/onboarding1_model.dart';
import 'package:masiha_user/providers/onboarding_provider.dart';
import 'package:masiha_user/screens/onboards/common/onboard_control.dart';
import 'package:masiha_user/screens/onboards/common/onboard_page.dart';
import 'package:provider/provider.dart';

class Onboarding2View extends StatelessWidget {
  const Onboarding2View({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure correct section is set when view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OnboardingProvider>();
      if (provider.currentSection != 2) {
        provider.setSection(2);
      }
    });

    return WillPopScope(
      onWillPop: () async {
        final provider = context.read<OnboardingProvider>();
        if (provider.currentPage == 0) {
          provider.setSection(1);
          Navigator.pushReplacementNamed(context, '/onboard1');
          return false;
        }
        provider.previousPage();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    context.read<OnboardingProvider>().setPage(index);
                  },
                  itemCount: onboarding2Data.length,
                  itemBuilder: (context, index) {
                    return Onboarding1Page(content: onboarding2Data[index]);
                  },
                ),
              ),
              const OnboardingControls(),
            ],
          ),
        ),
      ),
    );
  }
}
