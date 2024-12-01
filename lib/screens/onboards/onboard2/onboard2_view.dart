import 'package:flutter/material.dart';
import 'package:masiha_user/models/onboardings/onboarding1_model.dart';
import 'package:masiha_user/providers/onboarding_provider.dart';
import 'package:masiha_user/screens/onboards/common/onboard_control.dart';
import 'package:masiha_user/screens/onboards/common/onboard_page.dart';
import 'package:provider/provider.dart';

class Onboarding2View extends StatefulWidget {
  const Onboarding2View({super.key});

  @override
  State<Onboarding2View> createState() => _Onboarding2ViewState();
}

class _Onboarding2ViewState extends State<Onboarding2View> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Set the correct section
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().setSection(2);
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
      onWillPop: () async => false,
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
                  itemCount: onboarding2Data.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(content: onboarding2Data[index]);
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
