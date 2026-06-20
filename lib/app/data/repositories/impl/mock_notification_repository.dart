import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/notification_model.dart';
import '../notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationModel>> getAll() async => MockContent.mockNotifications;

  @override
  Future<void> markAllRead() async {}

  @override
  Future<void> markRead(String id) async {}
}
