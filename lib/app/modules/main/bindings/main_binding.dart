import 'package:get/get.dart';
import 'package:parela/app/modules/explore_tab/bindings/explore_tab_binding.dart';
import 'package:parela/app/modules/home/bindings/home_binding.dart';
import 'package:parela/app/modules/profile_tab/bindings/profile_tab_binding.dart';
import 'package:parela/app/modules/transaction_tab/bindings/transaction_tab_binding.dart';
import 'package:parela/app/modules/video_tab/bindings/video_tab_binding.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    HomeTabBinding().dependencies();
    ExploreTabBinding().dependencies();
    VideoTabBinding().dependencies();
    TransactionTabBinding().dependencies();
    ProfileTabBinding().dependencies();
  }
}
