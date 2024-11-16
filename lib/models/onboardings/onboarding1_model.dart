class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

final List<OnboardingContent> onboarding1Data = [
  OnboardingContent(
    title: 'Find Trusted Doctors',
    description:
        "Discover a network of highly-qualified doctors, carefully selected to provide the best possible care. Our intuitive search tool helps you find the right specialist, based on your specific needs. Whether you're seeking a routine checkup or specialized treatment, we're here to guide you every step of the way.",
    imagePath: 'assets/images/onboard1.jpg',
  ),
];

final List<OnboardingContent> onboarding2Data = [
  OnboardingContent(
    title: 'Book Appointments, Your Way',
    description:
        'Say goodbye to the hassle of traditional appointment booking. With our user-friendly app, you can easily schedule appointments that fit your busy lifestyle. Choose your preferred date and time, and book instantly, without any phone calls or waiting in long queues.',
    imagePath: 'assets/images/onboard3.jpg',
  ),
];
final List<OnboardingContent> onboarding3Data = [
  OnboardingContent(
    title: 'Your Privacy, Our Commitment',
    description:
        'Your health information is our top priority. We employ advanced security measures to protect your personal data, ensuring complete confidentiality. Rest assured, your information is safe with us.',
    imagePath: 'assets/images/onboard2.jpg',
  ),
];
