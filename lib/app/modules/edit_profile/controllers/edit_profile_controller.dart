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
  final avatarUrl = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    final user = Get.find<MainController>().currentUser.value;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    phoneController = TextEditingController(text: user?.phone ?? '');
    addressController = TextEditingController(text: user?.address ?? '');
    avatarUrl.value = user?.avatarUrl;
  }

  bool _validate() {
    nameError.value = '';
    emailError.value = '';
    bool ok = true;
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Nama lengkap wajib diisi';
      ok = false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Format email tidak valid';
      ok = false;
    }
    return ok;
  }

  Future<void> save() async {
    if (!_validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;

    // Actually update current user details in MainController
    final mainController = Get.find<MainController>();
    final currentUser = mainController.currentUser.value;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        avatarUrl: avatarUrl.value,
      );
      mainController.setUser(updatedUser);
    }

    Get.back();
    Get.snackbar(
      'Berhasil',
      'Profil Anda berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
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
