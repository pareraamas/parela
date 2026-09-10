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

  static const _dummyEmail = 'demo@parela.com';
  static const _dummyPassword = 'demo123456';

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    emailError.value = '';
    passwordError.value = '';
    generalError.value = '';
    isLoading.value = true;
    try {
      final email = emailController.text.trim().isEmpty
          ? _dummyEmail
          : emailController.text.trim();
      final password = passwordController.text.isEmpty
          ? _dummyPassword
          : passwordController.text;
      final user = await Get.find<AuthRepository>().login(
        email: email,
        password: password,
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

  Future<void> loginWithGoogle() async {
    generalError.value = '';
    isLoading.value = true;
    try {
      final user = await Get.find<AuthRepository>().login(
        email: 'demo.google@parela.com',
        password: 'google_dummy_token',
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
