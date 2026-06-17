import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
          onPressed: Get.back,
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: kText, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: controller.markAllRead,
            child: const Text(
              'Mark all read',
              style: TextStyle(color: kPrimary, fontSize: 12),
            ),
          ),
        ],
      ),
      body: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, color: kBackground),
          itemBuilder: (context, index) {
            final n = controller.notifications[index];
            return GestureDetector(
              onTap: () => controller.markRead(index),
              child: Container(
                color: n.isRead
                    ? Colors.white
                    : kPrimaryLight.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: kPrimaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_iconForType(n.type), color: kPrimary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.title,
                            style: TextStyle(
                              fontWeight:
                                  n.isRead ? FontWeight.w500 : FontWeight.w700,
                              fontSize: 13,
                              color: kText,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            n.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kSubtext,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            n.time,
                            style: const TextStyle(color: kSubtext, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    if (!n.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          color: kPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'promo':
        return Icons.local_offer_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}
