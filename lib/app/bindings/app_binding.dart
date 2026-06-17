import 'package:get/get.dart';
import 'package:parela/app/data/repositories/cart_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_cart_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_notification_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_order_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_product_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_seller_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_user_repository.dart';
import 'package:parela/app/data/repositories/notification_repository.dart';
import 'package:parela/app/data/repositories/order_repository.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/seller_repository.dart';
import 'package:parela/app/data/repositories/user_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductRepository>(MockProductRepository(), permanent: true);
    Get.put<UserRepository>(MockUserRepository(), permanent: true);
    Get.put<OrderRepository>(MockOrderRepository(), permanent: true);
    Get.put<NotificationRepository>(MockNotificationRepository(), permanent: true);
    Get.put<SellerRepository>(MockSellerRepository(), permanent: true);
    Get.put<CartRepository>(MockCartRepository(), permanent: true);
  }
}
