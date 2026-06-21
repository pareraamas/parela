import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/flash_sale_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/promotion_repository.dart';

class ExploreTabController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategoryIndex = 0.obs;
  final TextEditingController searchTextController = TextEditingController();

  final flashSale = Rxn<FlashSaleModel>();
  final isLoadingFlashSale = true.obs;
  final countdown = '00:00:00'.obs;

  final flashSaleProducts = <String, ProductModel>{};

  Timer? _countdownTimer;

  @override
  void onInit() {
    super.onInit();
    searchTextController.addListener(
      () => searchQuery.value = searchTextController.text,
    );
    _loadFlashSale();
  }

  void selectCategory(int index) => selectedCategoryIndex.value = index;

  Future<void> _loadFlashSale() async {
    try {
      isLoadingFlashSale.value = true;
      final data = await Get.find<PromotionRepository>().getFlashSale();
      if (data.currentSession != null) {
        _startCountdown(data.currentSession!.endsAt);
        final repo = Get.find<ProductRepository>();
        final results = await Future.wait(
          data.currentSession!.items.map((item) => repo.getById(item.productId)),
        );
        for (var i = 0; i < data.currentSession!.items.length; i++) {
          final product = results[i];
          if (product != null) {
            flashSaleProducts[data.currentSession!.items[i].productId] = product;
          }
        }
      }
      flashSale.value = data;
    } catch (_) {
      flashSale.value = null;
    } finally {
      isLoadingFlashSale.value = false;
    }
  }

  void _startCountdown(DateTime endsAt) {
    _countdownTimer?.cancel();
    _tick(endsAt);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick(endsAt));
  }

  void _tick(DateTime endsAt) {
    final diff = endsAt.difference(DateTime.now());
    if (diff.isNegative) {
      countdown.value = '00:00:00';
      _countdownTimer?.cancel();
      return;
    }
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    countdown.value = '$h:$m:$s';
  }

  @override
  void onClose() {
    searchTextController.dispose();
    _countdownTimer?.cancel();
    super.onClose();
  }
}
