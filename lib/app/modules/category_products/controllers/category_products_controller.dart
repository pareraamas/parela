import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';

class CategoryProductsController extends GetxController {
  late final CategoryModel category;
  final products = <ProductModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is CategoryModel) {
      category = arg;
    } else {
      final cats = Get.find<HomeTabController>().categories;
      category = cats.isNotEmpty
          ? cats.first
          : const CategoryModel(id: '', label: '', icon: Icons.category);
    }
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      products.assignAll(await Get.find<ProductRepository>().getByCategory(category.id));
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
