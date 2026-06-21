import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/repositories/order_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';

class TransactionTabController extends GetxController {
  final orders     = <OrderModel>[].obs;
  final isLoading  = true.obs;
  final selectedTab = 'Semua'.obs;

  static const tabs = [
    'Semua', 'Menunggu', 'Diproses', 'Dikirim', 'Selesai', 'Dibatalkan',
  ];

  static const _rawStatus = {
    'Menunggu':   'waiting_payment',
    'Diproses':   'processing',
    'Dikirim':    'shipped',
    'Selesai':    'delivered',
    'Dibatalkan': 'cancelled',
  };

  @override
  void onInit() {
    super.onInit();
    // Reactively reload/clear orders when user login status changes
    ever(Get.find<MainController>().isLoggedIn, (_) => _load());
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      final mainController = Get.find<MainController>();
      if (mainController.isLoggedIn.value) {
        orders.assignAll(await Get.find<OrderRepository>().getAll());
      } else {
        orders.clear();
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderModel> get filteredOrders {
    if (selectedTab.value == 'Semua') return orders;
    final raw = _rawStatus[selectedTab.value];
    if (raw == null) return orders;
    return orders.where((o) {
      if (selectedTab.value == 'Selesai') {
        return o.status == 'delivered' || o.status == 'completed';
      }
      return o.status == raw;
    }).toList();
  }

  int    get totalOrders => orders.length;
  double get totalSpent  => orders.fold(0.0, (s, o) => s + o.total);
  double get totalSaved  => totalSpent * 0.082;

  void goToDetail(OrderModel order) =>
      Get.toNamed(Routes.ORDER_DETAIL, arguments: order);

  Color statusColor(String status) {
    switch (status) {
      case 'delivered':
      case 'completed':       return const Color(0xFF2E7D32);
      case 'shipped':         return const Color(0xFF1565C0);
      case 'processing':      return const Color(0xFFF57C00);
      case 'waiting_payment': return const Color(0xFFE65100);
      case 'cancelled':       return const Color(0xFFC62828);
      default:                return const Color(0xFF757575);
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'delivered':
      case 'completed':       return Icons.check_circle_outline_rounded;
      case 'shipped':         return Icons.local_shipping_outlined;
      case 'processing':      return Icons.sync_outlined;
      case 'waiting_payment': return Icons.hourglass_empty_outlined;
      case 'cancelled':       return Icons.cancel_outlined;
      default:                return Icons.receipt_long_outlined;
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case 'delivered':
      case 'completed':       return 'Selesai';
      case 'shipped':         return 'Dikirim';
      case 'processing':      return 'Diproses';
      case 'waiting_payment': return 'Menunggu';
      case 'cancelled':       return 'Dibatalkan';
      default:                return status;
    }
  }
}
