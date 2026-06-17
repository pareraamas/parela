import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
          onPressed: Get.back,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: kText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Join Parela and discover beauty',
              style: TextStyle(color: kSubtext, fontSize: 14),
            ),
            const SizedBox(height: 28),
            _buildField(
              'Full Name',
              controller.nameController,
              'Muhammad Farhan',
              error: controller.nameError,
            ),
            const SizedBox(height: 14),
            _buildField(
              'Email',
              controller.emailController,
              'your@email.com',
              keyboardType: TextInputType.emailAddress,
              error: controller.emailError,
            ),
            const SizedBox(height: 14),
            Obx(
              () => _buildField(
                'Password',
                controller.passwordController,
                '••••••••',
                obscure: controller.obscurePassword.value,
                error: controller.passwordError,
                suffix: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: kSubtext,
                    size: 20,
                  ),
                  onPressed: () => controller.obscurePassword.toggle(),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => _buildField(
                'Confirm Password',
                controller.confirmController,
                '••••••••',
                obscure: controller.obscureConfirm.value,
                error: controller.confirmError,
                suffix: IconButton(
                  icon: Icon(
                    controller.obscureConfirm.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: kSubtext,
                    size: 20,
                  ),
                  onPressed: () => controller.obscureConfirm.toggle(),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: kSubtext, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: Get.back,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: kPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    String hint, {
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
    RxString? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: kText,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: ctrl,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: kText),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: kSubtext),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (error != null)
          Obx(() {
            final msg = error.value;
            if (msg.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                msg,
                style: const TextStyle(color: Colors.red, fontSize: 11),
              ),
            );
          }),
      ],
    );
  }
}
