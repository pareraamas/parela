import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreTabController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategoryIndex = 0.obs;
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchTextController.addListener(() => searchQuery.value = searchTextController.text);
  }

  void selectCategory(int index) => selectedCategoryIndex.value = index;

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
