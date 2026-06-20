import 'package:get/get.dart';
import 'package:parela/app/data/repositories/auth_repository.dart';
import 'package:parela/app/data/repositories/cart_repository.dart';
import 'package:parela/app/data/repositories/impl/api_auth_repository.dart';
import 'package:parela/app/data/repositories/impl/api_cart_repository.dart';
import 'package:parela/app/data/repositories/impl/api_notification_repository.dart';
import 'package:parela/app/data/repositories/impl/api_order_repository.dart';
import 'package:parela/app/data/repositories/impl/api_product_repository.dart';
import 'package:parela/app/data/repositories/impl/api_seller_repository.dart';
import 'package:parela/app/data/repositories/impl/api_user_repository.dart';
import 'package:parela/app/data/repositories/notification_repository.dart';
import 'package:parela/app/data/repositories/order_repository.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/seller_repository.dart';
import 'package:parela/app/data/repositories/user_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(ApiAuthRepository(), permanent: true);
    Get.put<ProductRepository>(ApiProductRepository(), permanent: true);
    Get.put<UserRepository>(ApiUserRepository(), permanent: true);
    Get.put<OrderRepository>(ApiOrderRepository(), permanent: true);
    Get.put<NotificationRepository>(ApiNotificationRepository(), permanent: true);
    Get.put<SellerRepository>(ApiSellerRepository(), permanent: true);
    Get.put<CartRepository>(ApiCartRepository(), permanent: true);
  }
}
