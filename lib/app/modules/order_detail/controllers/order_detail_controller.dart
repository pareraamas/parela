import 'package:get/get.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/user_repository.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';

class OrderDetailController extends GetxController {
  final isLoading = true.obs;
  late final OrderModel order;
  final orderProducts = <ProductModel>[].obs;
  final address = Rxn<AddressModel>();
  final payment = Rxn<PaymentMethodModel>();

  final statusSteps = ['Confirmed', 'Processing', 'Shipped', 'Delivered'];

  @override
  void onInit() {
    super.onInit();
    order = Get.arguments as OrderModel? ?? Get.find<HomeTabController>().products.first as dynamic;
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      final productRepo = Get.find<ProductRepository>();
      final userRepo = Get.find<UserRepository>();

      final itemIds = order.items.map((i) => i.productId).toList();
      final results = await Future.wait([
        Future.wait(itemIds.map((id) => productRepo.getById(id))),
        userRepo.getAddresses(),
        userRepo.getPaymentMethods(),
      ]);

      orderProducts.assignAll(
        (results[0] as List<ProductModel?>).whereType<ProductModel>(),
      );

      final addrs = results[1] as List<AddressModel>;
      address.value = addrs.isNotEmpty ? addrs.first : null;

      final pays = results[2] as List<PaymentMethodModel>;
      payment.value = pays.isNotEmpty ? pays.first : null;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
