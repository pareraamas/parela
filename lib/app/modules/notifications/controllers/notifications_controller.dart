import 'package:get/get.dart';
import 'package:parela/app/data/models/notification_model.dart';
import 'package:parela/app/data/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  late final NotificationRepository _repo;
  final notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<NotificationRepository>();
    notifications.assignAll(_repo.getAll());
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAllRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  void markRead(int index) {
    notifications[index].isRead = true;
    notifications.refresh();
  }
}
