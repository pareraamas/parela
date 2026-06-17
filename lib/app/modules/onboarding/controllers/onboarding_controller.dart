import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }

  void skip() => Get.offNamed(Routes.LOGIN);

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
