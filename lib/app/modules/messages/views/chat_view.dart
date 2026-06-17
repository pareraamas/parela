import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/modules/messages/controllers/messages_controller.dart';
import 'package:parela/app/theme/app_colors.dart';

class ChatView extends GetView<MessagesController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final conv = controller.activeConversation;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new, color: kText, size: 20),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(conv.avatarColor),
                  child: Text(
                    conv.sellerInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (conv.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conv.sellerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kText,
                  ),
                ),
                Text(
                  conv.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 11,
                    color: conv.isOnline
                        ? const Color(0xFF4CAF50)
                        : kSubtext,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined, color: kText, size: 22),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: kText, size: 22),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: controller.messages.length,
                  itemBuilder: (_, i) => _MessageBubble(
                    message: controller.messages[i],
                    showAvatar: !controller.messages[i].isMe &&
                        (i == 0 ||
                            controller.messages[i - 1].isMe),
                    sellerInitial: conv.sellerInitial,
                    avatarColor: conv.avatarColor,
                  ),
                )),
          ),
          _InputBar(controller: controller),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final dynamic message;
  final bool showAvatar;
  final String sellerInitial;
  final int avatarColor;

  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.sellerInitial,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe as bool;
    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            showAvatar
                ? CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(avatarColor),
                    child: Text(
                      sellerInitial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : const SizedBox(width: 28),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? kPrimary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text as String,
                    style: TextStyle(
                      color: isMe ? Colors.white : kText,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.time as String,
                      style: const TextStyle(
                        fontSize: 10,
                        color: kSubtext,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 3),
                      Icon(
                        (message.isRead as bool)
                            ? Icons.done_all
                            : Icons.done,
                        size: 12,
                        color: (message.isRead as bool)
                            ? kPrimary
                            : kSubtext,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final MessagesController controller;

  const _InputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline, color: kSubtext, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller.messageInput,
                maxLines: null,
                onChanged: (v) =>
                    controller.isTyping.value = v.trim().isNotEmpty,
                decoration: const InputDecoration(
                  hintText: 'Tulis pesan...',
                  hintStyle: TextStyle(color: kSubtext, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => GestureDetector(
                onTap: controller.sendMessage,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: controller.isTyping.value ? kPrimary : kBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    controller.isTyping.value
                        ? Icons.send_rounded
                        : Icons.mic_outlined,
                    color: controller.isTyping.value ? Colors.white : kSubtext,
                    size: 20,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
