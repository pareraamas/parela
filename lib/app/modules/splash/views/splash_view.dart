import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.local_mall,
                size: 52,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Parela',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: kPrimary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Beauty Marketplace',
              style: TextStyle(fontSize: 14, color: kSubtext),
            ),
            const SizedBox(height: 60),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: kPrimary,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
