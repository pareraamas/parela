import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';

class EditProfileController extends GetxController {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  final isLoading = false.obs;
  final nameError = ''.obs;
  final emailError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final user = Get.find<MainController>().currentUser.value;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    phoneController = TextEditingController(text: user?.phone ?? '');
    addressController = TextEditingController(text: user?.address ?? '');
  }

  bool _validate() {
    nameError.value = '';
    emailError.value = '';
    bool ok = true;
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name is required';
      ok = false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Enter a valid email address';
      ok = false;
    }
    return ok;
  }

  Future<void> save() async {
    if (!_validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.back();
    Get.snackbar(
      'Saved',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
