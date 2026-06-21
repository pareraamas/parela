import 'package:get/get.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/user_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';

class CheckoutController extends GetxController {
  final addresses = <AddressModel>[].obs;
  final paymentMethods = <PaymentMethodModel>[].obs;
  final selectedAddressIndex = 0.obs;
  final selectedPaymentIndex = 0.obs;
  final isLoading = false.obs;
  final isReady = false.obs;

  final _productsById = <String, ProductModel>{};

  ProductModel? productById(String id) => _productsById[id];

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final userRepo = Get.find<UserRepository>();
      final productRepo = Get.find<ProductRepository>();
      final results = await Future.wait([
        userRepo.getAddresses(),
        userRepo.getPaymentMethods(),
        productRepo.getAll(limit: 100),
      ]);
      addresses.assignAll(results[0] as List<AddressModel>);
      paymentMethods.assignAll(results[1] as List<PaymentMethodModel>);
      final pr = results[2] as ({List<ProductModel> data, bool hasMore});
      for (final p in pr.data) {
        _productsById[p.id] = p;
      }
      isReady.value = true;
    } catch (_) {
      isReady.value = true;
    }
  }

  MainController get _main => Get.find<MainController>();

  AddressModel? get selectedAddress =>
      addresses.isNotEmpty ? addresses[selectedAddressIndex.value] : null;

  PaymentMethodModel? get selectedPayment =>
      paymentMethods.isNotEmpty ? paymentMethods[selectedPaymentIndex.value] : null;

  static const _sellerDeliveryFees = <String, double>{
    's001': 12000,
    's002': 18000,
    's003': 15000,
    's004': 20000,
    's005': 17000,
  };

  double deliveryFeeForSeller(String sellerId) =>
      _sellerDeliveryFees[sellerId] ?? 15000;

  Set<String> get _sellerIdsInCart {
    final ids = <String>{};
    for (final item in _main.cartItems) {
      final p = productById(item.productId);
      if (p != null) ids.add(p.sellerId);
    }
    return ids;
  }

  double get subtotal => _main.cartSubtotal;
  double get totalDeliveryFee =>
      _sellerIdsInCart.fold(0.0, (s, id) => s + deliveryFeeForSeller(id));
  double get serviceFee => 2000.0;
  double get total => subtotal + totalDeliveryFee + serviceFee;

  double get savings => _main.cartItems.fold(0.0, (sum, item) {
        final product = productById(item.productId);
        if (product == null) return sum;
        return sum + (product.originalPrice - item.price) * item.quantity;
      });

  Future<void> placeOrder() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
    Get.toNamed(
      Routes.PAYMENT,
      arguments: {
        'paymentLabel': selectedPayment?.label ?? '',
        'paymentType': selectedPayment?.type ?? '',
        'paymentNumber': selectedPayment?.number ?? '',
        'total': total,
      },
    );
  }
}
