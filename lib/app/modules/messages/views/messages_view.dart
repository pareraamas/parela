import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/message_model.dart';
import 'package:parela/app/modules/messages/controllers/messages_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class MessagesView extends GetView<MessagesController> {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App bar (pinned) ───────────────────────────────────────
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 1,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              leading: IconButton(
                onPressed: Get.back,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: kText,
                  size: 20,
                ),
              ),
              title: const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kText,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: kText,
                    size: 22,
                  ),
                ),
              ],
            ),

            // ── Search bar (bagian konten, naik ke app bar saat scroll)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: kPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search_rounded, color: kSubtext, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 13, color: kText),
                          decoration: InputDecoration(
                            hintText: 'Search messages...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: kSubtext,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Daftar percakapan ─────────────────────────────────────
            Obx(
              () => SliverList.separated(
                itemCount: controller.conversations.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  indent: 76,
                  color: kBackground,
                ),
                itemBuilder: (_, i) {
                  final conv = controller.conversations[i];
                  return _ConversationTile(
                    conversation: conv,
                    onTap: () {
                      controller.openChat(conv);
                      Get.toNamed(Routes.CHAT);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(conversation.avatarColor),
                  child: Text(
                    conversation.sellerInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.sellerName,
                    style: TextStyle(
                      fontWeight: conversation.isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                      fontSize: 14,
                      color: kText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: conversation.isRead ? kSubtext : kText,
                      fontWeight: conversation.isRead
                          ? FontWeight.normal
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: conversation.isRead ? kSubtext : kPrimary,
                    fontWeight: conversation.isRead
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                if (conversation.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${conversation.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
