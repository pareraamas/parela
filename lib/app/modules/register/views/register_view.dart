import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
          onPressed: Get.back,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            const Text(
              'Buat Akun',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: kText,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Bergabung dengan komunitas Parela',
              style: TextStyle(fontSize: 13, color: kSubtext),
            ),

            const SizedBox(height: 24),

            _Field(
              ctrl: controller.nameController,
              label: 'Nama Lengkap',
              hint: 'Nama kamu',
              error: controller.nameError,
            ),
            const SizedBox(height: 14),
            _Field(
              ctrl: controller.emailController,
              label: 'Email',
              hint: 'email@kamu.com',
              keyboardType: TextInputType.emailAddress,
              error: controller.emailError,
            ),
            const SizedBox(height: 14),
            Obx(
              () => _Field(
                ctrl: controller.passwordController,
                label: 'Password',
                hint: '••••••••',
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
              () => _Field(
                ctrl: controller.confirmController,
                label: 'Konfirmasi Password',
                hint: '••••••••',
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
                    disabledBackgroundColor: kPrimary.withAlpha(120),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                          'Daftar',
                          style: TextStyle(
                            fontSize: 15,
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
                    'Sudah punya akun? ',
                    style: TextStyle(color: kSubtext, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: Get.back,
                    child: const Text(
                      'Masuk',
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
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final RxString? error;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: kText,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, color: kText),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: kSubtext, fontSize: 13),
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
        if (error != null)
          Obx(() {
            final msg = error!.value;
            if (msg.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 4, left: 2),
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
