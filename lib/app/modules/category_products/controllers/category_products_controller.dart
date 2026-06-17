import 'package:get/get.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';

class CategoryProductsController extends GetxController {
  late final CategoryModel category;
  late final List<ProductModel> products;

  @override
  void onInit() {
    super.onInit();
    final repo = Get.find<ProductRepository>();
    category = Get.arguments as CategoryModel? ?? repo.getCategories().first;
    products = repo.getByCategory(category.id);
  }
}
