import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeTabController>(() => HomeTabController());
  }
}
