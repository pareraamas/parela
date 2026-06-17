import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/repositories/order_repository.dart';

class MyOrdersController extends GetxController {
  late final List<OrderModel> orders;

  @override
  void onInit() {
    super.onInit();
    orders = Get.find<OrderRepository>().getAll();
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Delivered':
        return const Color(0xFF4CAF50);
      case 'Shipped':
        return const Color(0xFF2196F3);
      case 'Processing':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}
