import 'package:get/get.dart';
import 'package:parela/app/data/repositories/user_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  Future<void> _navigate() async {
    if (StorageService.instance.isLoggedIn) {
      try {
        final user = await Get.find<UserRepository>().getUser();
        Get.find<MainController>().setUser(user);
      } catch (_) {
        await StorageService.instance.clearTokens();
      }
    }
    Get.offNamed(Routes.MAIN);
  }
}
