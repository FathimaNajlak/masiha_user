import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/onboardings/onboarding1_model.dart';
import 'package:masiha_user/providers/onboardings/onboarding_provider.dart';
import 'package:provider/provider.dart';

class OnboardingControls extends StatelessWidget {
  const OnboardingControls({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final currentPage = provider.currentPage;
    final currentSection = provider.currentSection;

    // Calculate if we're on the last page of section 3
    final isLastPage =
        currentSection == 3 && currentPage == onboarding3Data.length - 1;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                onboarding1Data.length,
                (index) => _buildIndicator(
                  isActive: currentSection == 1 && currentPage == index,
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(
                onboarding2Data.length,
                (index) => _buildIndicator(
                  isActive: currentSection == 2 && currentPage == index,
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(
                onboarding3Data.length,
                (index) => _buildIndicator(
                  isActive: currentSection == 3 && currentPage == index,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                final provider = context.read<OnboardingProvider>();
                if (isLastPage) {
                  Navigator.pushReplacementNamed(context, '/letin');
                } else {
                  provider.nextPage();
                  // Check if section changed after nextPage
                  if (provider.currentSection != currentSection) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/onboard${provider.currentSection}',
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isLastPage ? 'Get Started' : 'Next',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF009FE3) : Colors.grey[300],
      ),
    );
  }
}
