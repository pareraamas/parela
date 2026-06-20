import 'package:get/get.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/search/controllers/search_controller.dart';
import 'package:parela/app/data/repositories/auth_repository.dart';
import 'package:parela/app/data/repositories/cart_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_auth_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_cart_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_notification_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_order_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_product_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_promotion_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_seller_repository.dart';
import 'package:parela/app/data/repositories/impl/mock_user_repository.dart';
import 'package:parela/app/data/repositories/notification_repository.dart';
import 'package:parela/app/data/repositories/order_repository.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/promotion_repository.dart';
import 'package:parela/app/data/repositories/seller_repository.dart';
import 'package:parela/app/data/repositories/user_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(MockAuthRepository(), permanent: true);
    Get.put<ProductRepository>(MockProductRepository(), permanent: true);
    Get.put<UserRepository>(MockUserRepository(), permanent: true);
    Get.put<OrderRepository>(MockOrderRepository(), permanent: true);
    Get.put<NotificationRepository>(MockNotificationRepository(), permanent: true);
    Get.put<SellerRepository>(MockSellerRepository(), permanent: true);
    Get.put<CartRepository>(MockCartRepository(), permanent: true);
    Get.put<PromotionRepository>(MockPromotionRepository(), permanent: true);
    Get.put<MainController>(MainController(), permanent: true);
    Get.put(ProductSearchController(), permanent: true);
  }
}
