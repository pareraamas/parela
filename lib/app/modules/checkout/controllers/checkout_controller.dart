import 'package:get/get.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/repositories/user_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';

class CheckoutController extends GetxController {
  final addresses = <AddressModel>[].obs;
  final paymentMethods = <PaymentMethodModel>[].obs;
  final selectedAddressIndex = 0.obs;
  final selectedPaymentIndex = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = Get.find<UserRepository>();
      final results = await Future.wait([repo.getAddresses(), repo.getPaymentMethods()]);
      addresses.assignAll(results[0] as List<AddressModel>);
      paymentMethods.assignAll(results[1] as List<PaymentMethodModel>);
    } catch (_) {}
  }

  double get subtotal => Get.find<MainController>().cartSubtotal;
  double get deliveryFee => 15000.0;
  double get total => subtotal + deliveryFee;

  Future<void> placeOrder() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.find<MainController>().clearCart();
    Get.offNamed(Routes.ORDER_SUCCESS);
  }
}
