import 'package:get/get.dart';
import 'package:parela/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(Routes.ONBOARDING);
    });
  }
}
