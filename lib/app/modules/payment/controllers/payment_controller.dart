import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/services/notification_service.dart';
import 'package:uuid/uuid.dart';

class PaymentController extends GetxController {
  late final String paymentLabel;
  late final String paymentType;
  late final String paymentNumber;
  late final double total;

  final isConfirming = false.obs;
  late final String qrData;

  final timeLeft = const Duration(hours: 24).obs;
  final dueDate = ''.obs;
  Timer? _timer;

  final _months = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    paymentLabel = (args['paymentLabel'] as String?) ?? '';
    paymentType = (args['paymentType'] as String?) ?? '';
    paymentNumber = (args['paymentNumber'] as String?) ?? '';
    total = (args['total'] as double?) ?? 0;

    qrData = 'PARELA-${const Uuid().v4().toUpperCase()}';

    final due = DateTime.now().add(const Duration(hours: 24));
    dueDate.value =
        '${due.day} ${_months[due.month]} ${due.year}, ${due.hour.toString().padLeft(2, '0')}:${due.minute.toString().padLeft(2, '0')}';

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft.value.inSeconds > 0) {
        timeLeft.value = timeLeft.value - const Duration(seconds: 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String get countdownText {
    final d = timeLeft.value;
    final h = d.inHours;
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h jam $m menit $s detik';
  }

  String get bankName {
    if (paymentLabel.contains('BCA')) return 'BCA';
    if (paymentLabel.contains('Mandiri')) return 'Mandiri';
    if (paymentLabel.contains('BNI')) return 'BNI';
    if (paymentLabel.contains('BRI')) return 'BRI';
    return paymentLabel.split(' ').first;
  }

  void copyVA() {
    Clipboard.setData(ClipboardData(text: paymentNumber.replaceAll(' ', '')));
    Get.snackbar(
      'Disalin!',
      'Nomor VA telah disalin ke clipboard',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> confirm() async {
    if (isConfirming.value) return;
    isConfirming.value = true;
    _timer?.cancel();
    await Future.delayed(const Duration(seconds: 3));
    await NotificationService.showPaymentSuccess(
      paymentLabel: paymentLabel,
      total: total,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    Get.find<MainController>().clearCart();
    Get.offNamedUntil(Routes.ORDER_SUCCESS, (r) => r.settings.name == Routes.MAIN);
  }
}
