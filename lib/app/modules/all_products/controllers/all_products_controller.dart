import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';

class AllProductsController extends GetxController {
  final products = <ProductModel>[].obs;
  final title = 'All Products'.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is String) title.value = arg;
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      products.assignAll(await Get.find<ProductRepository>().getAll());
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
