import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/notification_model.dart';
import '../notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  List<NotificationModel> getAll() => MockContent.mockNotifications;
}
