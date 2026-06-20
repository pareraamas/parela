import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/seller_repository.dart';

class SellerStoreController extends GetxController {
  final seller = Rxn<SellerModel>();
  final products = <ProductModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      final sellerId = Get.arguments as String? ?? 's001';
      final results = await Future.wait([
        Get.find<SellerRepository>().getById(sellerId),
        Get.find<ProductRepository>().getBySeller(sellerId),
      ]);
      seller.value = results[0] as SellerModel?;
      products.assignAll(results[1] as List<ProductModel>);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
