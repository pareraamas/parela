import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class AppHeader extends StatelessWidget {
  final String? title;

  const AppHeader({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
      child: Row(
        children: [
          title == null
              ? RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'par',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: kText,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: 'ela',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: kPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kText,
                  ),
                ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.toNamed(Routes.MESSAGES),
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: kText, size: 24),
          ),
          Obx(() => Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () => Get.toNamed(Routes.CART),
                    icon: const Icon(Icons.shopping_bag_outlined, color: kText, size: 24),
                  ),
                  if (main.cartCount.value > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        decoration: const BoxDecoration(
                          color: kPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${main.cartCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )),
        ],
      ),
    );
  }
}
