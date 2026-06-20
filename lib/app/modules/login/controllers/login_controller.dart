import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/repositories/auth_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/services/api_client.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final isLoading = false.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final generalError = ''.obs;

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  bool _validate() {
    emailError.value = '';
    passwordError.value = '';
    generalError.value = '';
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
    try {
      final user = await Get.find<AuthRepository>().login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      Get.find<MainController>().setUser(user);
      Get.offAllNamed(Routes.MAIN);
    } on ApiException catch (e) {
      generalError.value = e.message;
    } catch (_) {
      generalError.value = 'Terjadi kesalahan. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
