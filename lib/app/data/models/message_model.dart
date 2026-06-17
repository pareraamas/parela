class ConversationModel {
  final String id;
  final String sellerName;
  final String sellerInitial;
  final int avatarColor;
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
    required this.lastMessage,
    required this.time,
    required this.isRead,
    required this.unreadCount,
    required this.isOnline,
  });
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
}
