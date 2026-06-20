import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/repositories/order_repository.dart';

class MyOrdersController extends GetxController {
  late final OrderRepository _repo;
  final orders = <OrderModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<OrderRepository>();
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      final list = await _repo.getAll();
      orders.assignAll(list);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'shipped':
        return const Color(0xFF2196F3);
      case 'processing':
      case 'waiting_payment':
        return const Color(0xFFFF9800);
      case 'cancelled':
        return Colors.red;
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}
