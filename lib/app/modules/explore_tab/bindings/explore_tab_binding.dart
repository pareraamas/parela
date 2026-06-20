import 'package:get/get.dart';
import '../controllers/explore_tab_controller.dart';

class ExploreTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreTabController>(() => ExploreTabController());
  }
}
