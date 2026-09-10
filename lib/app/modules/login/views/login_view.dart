import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Image.asset(
              'assets/icon/app_icon.png',
              width: 180,
              height: 180,
            ),
          ),

          // ── Form card ───────────────────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            vertical: 8,
                            horizontal: 0,
                          ),
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

                    const SizedBox(height: 24),

                    Row(
                      children: const [
                        Expanded(child: Divider(color: Color(0xFFEEEEEE))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'atau masuk dengan',
                            style: TextStyle(color: kSubtext, fontSize: 12),
                          ),
                        ),
                        Expanded(child: Divider(color: Color(0xFFEEEEEE))),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: controller.loginWithGoogle,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kText,
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icon/google.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text('Lanjut dengan Google'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

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

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
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
              horizontal: 16,
              vertical: 14,
            ),
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
