import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/seller_repository.dart';

class SellerStoreController extends GetxController {
  late final SellerModel seller;
  late final List<ProductModel> products;

  @override
  void onInit() {
    super.onInit();
    final sellerRepo = Get.find<SellerRepository>();
    final productRepo = Get.find<ProductRepository>();
    final sellerId = Get.arguments as String? ?? 's001';
    seller = sellerRepo.getById(sellerId) ?? sellerRepo.getAll().first;
    products = productRepo.getBySeller(sellerId);
  }
}
