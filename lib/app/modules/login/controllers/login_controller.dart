import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final isLoading = false.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  bool _validate() {
    emailError.value = '';
    passwordError.value = '';
    bool ok = true;
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      ok = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email address';
      ok = false;
    }
    if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      ok = false;
    }
    return ok;
  }

  Future<void> login() async {
    if (!_validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.offAllNamed(Routes.MAIN);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
