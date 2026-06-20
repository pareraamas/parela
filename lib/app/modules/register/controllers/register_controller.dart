import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/repositories/auth_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/services/api_client.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;
  final isLoading = false.obs;
  final nameError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final confirmError = ''.obs;
  final generalError = ''.obs;

  bool _validate() {
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmError.value = '';
    generalError.value = '';
    bool ok = true;
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Full name is required';
      ok = false;
    }
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
    if (confirmController.text != passwordController.text) {
      confirmError.value = 'Passwords do not match';
      ok = false;
    }
    return ok;
  }

  Future<void> register() async {
    if (!_validate()) return;
    isLoading.value = true;
    try {
      final user = await Get.find<AuthRepository>().register(
        name: nameController.text.trim(),
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
