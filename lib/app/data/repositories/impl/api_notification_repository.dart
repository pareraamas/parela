import 'package:parela/app/data/models/notification_model.dart';
import 'package:parela/app/data/repositories/notification_repository.dart';
import 'package:parela/app/services/api_client.dart';

class ApiNotificationRepository implements NotificationRepository {
  final _client = ApiClient.instance;

  @override
  Future<List<NotificationModel>> getAll() async {
    final res = await _client.get('/notifications');
    return ((res['data'] as List?) ?? [])
        .map((j) => NotificationModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAllRead() async {
    await _client.put('/notifications/read-all');
  }

  @override
  Future<void> markRead(String id) async {
    await _client.put('/notifications/$id/read');
  }
}
