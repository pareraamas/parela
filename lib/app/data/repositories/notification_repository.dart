import 'package:parela/app/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getAll();
  Future<void> markAllRead();
  Future<void> markRead(String id);
}
