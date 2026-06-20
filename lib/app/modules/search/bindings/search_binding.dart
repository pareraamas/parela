import 'package:get/get.dart';
import 'package:parela/app/modules/search/controllers/search_result_controller.dart';

class SearchResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchResultController());
  }
}
