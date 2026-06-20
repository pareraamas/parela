import 'package:get/get.dart';
import 'package:parela/app/data/models/notification_model.dart';
import 'package:parela/app/data/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  late final NotificationRepository _repo;
  final notifications = <NotificationModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<NotificationRepository>();
    _load();
  }

  Future<void> _load() async {
    try {
      isLoading.value = true;
      final list = await _repo.getAll();
      notifications.assignAll(list);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> markAllRead() async {
    await _repo.markAllRead();
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  Future<void> markRead(int index) async {
    await _repo.markRead(notifications[index].id);
    notifications[index].isRead = true;
    notifications.refresh();
  }
}
