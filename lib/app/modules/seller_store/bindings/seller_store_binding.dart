import 'package:get/get.dart';
import '../controllers/seller_store_controller.dart';

class SellerStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerStoreController>(() => SellerStoreController());
  }
}
