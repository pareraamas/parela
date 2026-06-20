class NotificationModel {
  final String id;
  final String title;
  final String body;
  bool isRead;
  final String time;
  final String type;
  final String? actionUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.time,
    required this.type,
    this.actionUrl,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> m) =>
      NotificationModel(
        id: m['id'] as String,
        title: m['title'] as String,
        body: m['body'] as String,
        isRead: (m['isRead'] as bool?) ?? false,
        time: (m['time'] as String?) ?? '',
        type: (m['type'] as String?) ?? 'system',
        actionUrl: m['actionUrl'] as String?,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> j) =>
      NotificationModel(
        id: j['id'] as String,
        title: j['title'] as String,
        body: j['body'] as String,
        isRead: (j['is_read'] as bool?) ?? false,
        time: (j['time'] as String?) ?? '',
        type: (j['type'] as String?) ?? 'system',
        actionUrl: j['action_url'] as String?,
      );
}
