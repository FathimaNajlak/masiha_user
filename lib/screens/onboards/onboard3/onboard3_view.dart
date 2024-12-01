import 'package:flutter/material.dart';
import 'package:masiha_user/models/onboardings/onboarding1_model.dart';
import 'package:masiha_user/providers/onboarding_provider.dart';
import 'package:masiha_user/screens/onboards/common/onboard_control.dart';
import 'package:masiha_user/screens/onboards/common/onboard_page.dart';
import 'package:provider/provider.dart';

class Onboarding3View extends StatefulWidget {
  const Onboarding3View({super.key});

  @override
  State<Onboarding3View> createState() => _Onboarding3ViewState();
}

class _Onboarding3ViewState extends State<Onboarding3View> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().setSection(3);
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
                  itemCount: onboarding3Data.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(content: onboarding3Data[index]);
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
