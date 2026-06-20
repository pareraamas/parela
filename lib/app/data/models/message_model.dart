class ConversationModel {
  final String id;
  final String sellerName;
  final String sellerInitial;
  final int avatarColor;
  final String? sellerAvatarUrl;
  final String lastMessage;
  final String time;
  bool isRead;
  final int unreadCount;
  final bool isOnline;

  ConversationModel({
    required this.id,
    required this.sellerName,
    required this.sellerInitial,
    required this.avatarColor,
    this.sellerAvatarUrl,
    required this.lastMessage,
    required this.time,
    required this.isRead,
    required this.unreadCount,
    required this.isOnline,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> j) => ConversationModel(
        id: j['id'] as String,
        sellerName: (j['seller_name'] as String?) ?? '',
        sellerInitial: (j['seller_initial'] as String?) ?? '',
        avatarColor: (j['avatar_color'] as int?) ?? 0xFF9E9E9E,
        sellerAvatarUrl: j['seller_avatar_url'] as String?,
        lastMessage: (j['last_message'] as String?) ?? '',
        time: (j['time_label'] as String?) ?? '',
        isRead: (j['is_read'] as bool?) ?? true,
        unreadCount: (j['unread_count'] as int?) ?? 0,
        isOnline: (j['is_online'] as bool?) ?? false,
      );
}

class MessageModel {
  final String id;
  final String text;
  final String time;
  final bool isMe;
  bool isRead;

  MessageModel({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> j) => MessageModel(
        id: j['id'] as String,
        text: (j['text'] as String?) ?? '',
        time: (j['time'] as String?) ?? '',
        isMe: (j['is_me'] as bool?) ?? false,
        isRead: (j['is_read'] as bool?) ?? false,
      );
}
