import 'package:get/get.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/repositories/order_repository.dart';

class TransactionTabController extends GetxController {
  final orders = <OrderModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      orders.assignAll(await Get.find<OrderRepository>().getAll());
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
