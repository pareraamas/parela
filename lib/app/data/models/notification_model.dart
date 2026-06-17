class NotificationModel {
  final String id;
  final String title;
  final String body;
  bool isRead;
  final String time;
  final String type;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.time,
    required this.type,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> m) =>
      NotificationModel(
        id: m['id'] as String,
        title: m['title'] as String,
        body: m['body'] as String,
        isRead: m['isRead'] as bool,
        time: m['time'] as String,
        type: m['type'] as String,
      );
}
