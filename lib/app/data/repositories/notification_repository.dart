import 'package:parela/app/data/models/notification_model.dart';

abstract class NotificationRepository {
  List<NotificationModel> getAll();
}
