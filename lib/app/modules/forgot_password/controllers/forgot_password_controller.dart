import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final isSent = false.obs;
  final emailError = ''.obs;

  bool _validate() {
    emailError.value = '';
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email address';
      return false;
    }
    return true;
  }

  Future<void> sendReset() async {
    if (!_validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    isSent.value = true;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
