import 'package:get/get.dart';
import '../controllers/video_tab_controller.dart';

class VideoTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoTabController>(() => VideoTabController());
  }
}
