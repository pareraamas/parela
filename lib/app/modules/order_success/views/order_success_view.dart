import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/order_success_controller.dart';

class OrderSuccessView extends GetView<OrderSuccessController> {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: _SuccessPage(),
    );
  }
}

class _SuccessPage extends StatefulWidget {
  const _SuccessPage();

  @override
  State<_SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<_SuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _checkScale;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _contentFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderSuccessController>();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Check icon
                  ScaleTransition(
                    scale: _checkScale,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF7EE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF2E7D32),
                        size: 52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title & order number
                  FadeTransition(
                    opacity: _contentFade,
                    child: Column(
                      children: [
                        const Text(
                          'Pesanan Berhasil!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: kText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            controller.orderNumber,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: kSubtext,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Pesananmu sedang diproses.\nKamu bisa memantau status pengiriman di halaman pesananku.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: kSubtext,
                            height: 1.65,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Info rows
                  FadeTransition(
                    opacity: _contentFade,
                    child: const _InfoRows(),
                  ),
                ],
              ),
            ),
          ),

          // Buttons
          FadeTransition(
            opacity: _contentFade,
            child: const _Buttons(),
          ),
        ],
      ),
    );
  }
}

class _InfoRows extends StatelessWidget {
  const _InfoRows();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: 'Estimasi tiba',
            value: '2–3 hari kerja',
          ),
          const Divider(height: 1, indent: 48, color: Color(0xFFEEEEEE)),
          _InfoRow(
            icon: Icons.verified_outlined,
            label: 'Status pembayaran',
            value: 'Terkonfirmasi',
            valueColor: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kSubtext),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: kSubtext),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? kText,
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.MAIN),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Kembali ke Beranda',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
