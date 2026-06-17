import 'package:get/get.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/order_repository.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/user_repository.dart';

class OrderDetailController extends GetxController {
  late final ProductRepository _productRepo;
  late final UserRepository _userRepo;
  late final OrderModel order;

  final statusSteps = ['Confirmed', 'Processing', 'Shipped', 'Delivered'];

  @override
  void onInit() {
    super.onInit();
    _productRepo = Get.find<ProductRepository>();
    _userRepo = Get.find<UserRepository>();
    order = Get.arguments as OrderModel? ??
        Get.find<OrderRepository>().getAll().first;
  }

  List<ProductModel> get orderProducts =>
      _productRepo.getAll().where((p) => order.items.contains(p.id)).toList();

  AddressModel get address => _userRepo.getAddresses().first;
  PaymentMethodModel get payment => _userRepo.getPaymentMethods().first;
}
