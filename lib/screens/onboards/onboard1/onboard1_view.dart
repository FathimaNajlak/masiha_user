import 'package:flutter/material.dart';
import 'package:masiha_user/models/onboardings/onboarding1_model.dart';
import 'package:masiha_user/providers/onboarding_provider.dart';
import 'package:masiha_user/screens/onboards/common/onboard_control.dart';
import 'package:masiha_user/screens/onboards/common/onboard_page.dart';
import 'package:provider/provider.dart';

class Onboarding1View extends StatefulWidget {
  const Onboarding1View({super.key});

  @override
  State<Onboarding1View> createState() => _Onboarding1ViewState();
}

class _Onboarding1ViewState extends State<Onboarding1View> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Set the initial section
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().setSection(1);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    context.read<OnboardingProvider>().setPage(index);
                  },
                  itemCount: onboarding1Data.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(content: onboarding1Data[index]);
                  },
                ),
              ),
              OnboardingControls(pageController: _pageController),
            ],
          ),
        ),
      ),
    );
  }
}
