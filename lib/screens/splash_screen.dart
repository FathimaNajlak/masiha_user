import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Navigate to home screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      // Replace this with your actual navigation logic
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Column(
              children: [
                SizedBox(
                  width: 400,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Loading indicator
            RotationTransition(
              turns: _controller,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CustomPaint(
                  painter: LoadingDotsPainter(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF009FE3)
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    for (int i = 0; i < 8; i++) {
      final double angle = (i * pi / 4);
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);

      // Make dots smaller as they go clockwise
      final double dotRadius = 3 - (i * 0.2);

      canvas.drawCircle(
        Offset(x, y),
        dotRadius.clamp(1.0, 3.0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
