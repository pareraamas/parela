import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';

class AllProductsController extends GetxController {
  late final List<ProductModel> products;
  final title = 'All Products'.obs;

  @override
  void onInit() {
    super.onInit();
    products = Get.find<ProductRepository>().getAll();
    final arg = Get.arguments;
    if (arg is String) title.value = arg;
  }
}
