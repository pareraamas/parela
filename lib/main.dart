import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/app_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/services/notification_service.dart';
import 'app/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.init();
  runApp(
    GetMaterialApp(
      title: 'Parela',
      initialBinding: AppBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
