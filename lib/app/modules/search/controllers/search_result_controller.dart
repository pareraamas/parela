import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';

class SearchResultController extends GetxController {
  final results = <ProductModel>[].obs;
  final query = ''.obs;
  final sortIndex = 0.obs;

  final _sortLabels = ['Relevan', 'Terbaru', 'Termurah', 'Termahal'];
  List<String> get sortLabels => _sortLabels;

  @override
  void onInit() {
    super.onInit();
    query.value = (Get.arguments as String?) ?? '';
    _load();
  }

  void _load() {
    final q = query.value.toLowerCase();
    final all = Get.find<HomeTabController>().products;
    if (q.isEmpty) {
      results.assignAll(all);
    } else {
      results.assignAll(
        all.where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q)),
      );
    }
    _applySort();
  }

  void setSort(int index) {
    sortIndex.value = index;
    _applySort();
  }

  void _applySort() {
    switch (sortIndex.value) {
      case 1:
        results.sort((a, b) => b.id.compareTo(a.id));
      case 2:
        results.sort((a, b) => a.price.compareTo(b.price));
      case 3:
        results.sort((a, b) => b.price.compareTo(a.price));
      default:
        break;
    }
  }
}
