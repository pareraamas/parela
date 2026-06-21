import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button if navigable
              if (Navigator.of(context).canPop())
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.arrow_back_ios,
                        color: kText, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                )
              else
                const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Brand
              Center(
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'par',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: kSubtext,
                            ),
                          ),
                          TextSpan(
                            text: 'ela',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: kPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Beauty Marketplace',
                      style: TextStyle(fontSize: 11, color: kSubtext),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Masuk',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kText,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Selamat datang kembali',
                style: TextStyle(fontSize: 13, color: kSubtext),
              ),

              const SizedBox(height: 24),

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
                    onPressed: controller.toggleObscure,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 0),
                  ),
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(color: kPrimary, fontSize: 12),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login,
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
                            'Masuk',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  const Expanded(
                      child: Divider(color: Color(0xFFEEEEEE))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'atau masuk dengan',
                      style: TextStyle(color: kSubtext, fontSize: 12),
                    ),
                  ),
                  const Expanded(
                      child: Divider(color: Color(0xFFEEEEEE))),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, size: 22),
                  label: const Text('Lanjut dengan Google'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kText,
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: kSubtext, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.REGISTER),
                      child: const Text(
                        'Daftar',
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

              const SizedBox(height: 24),
            ],
          ),
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
            hintStyle:
                const TextStyle(color: kSubtext, fontSize: 13),
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFFE8E8E8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFFE8E8E8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: kPrimary, width: 1.5),
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
                style:
                    const TextStyle(color: Colors.red, fontSize: 11),
              ),
            );
          }),
      ],
    );
  }
}
