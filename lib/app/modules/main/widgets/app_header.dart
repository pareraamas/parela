import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/search/views/search_page.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class AppHeader extends StatelessWidget {
  final String? title;
  final String heroTag;
  final Widget? leading;

  const AppHeader({
    super.key,
    this.title,
    this.heroTag = 'search-bar',
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(leading != null ? 4 : 20, 0, 8, 6),
      child: Row(
        children: [
          ?leading,
          title == null
              ? Expanded(
                  child: Hero(
                    tag: heroTag,
                    child: Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, _, _) =>
                                SearchPage(heroTag: heroTag),
                            transitionDuration: const Duration(
                              milliseconds: 250,
                            ),
                            transitionsBuilder: (_, anim, _, child) =>
                                FadeTransition(
                                  opacity: CurvedAnimation(
                                    parent: anim,
                                    curve: Curves.easeOut,
                                  ),
                                  child: child,
                                ),
                          ),
                        ),
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 249, 251),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kPrimary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: kSubtext,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              _AnimatedCategoryText(),
                            ],
                          ),
                        ),
                      ),
                    ),
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
          if (title != null) const Spacer(),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (main.isLoggedIn.value) {
                Get.toNamed(Routes.MESSAGES);
              } else {
                Get.toNamed(Routes.LOGIN);
              }
            },
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(0),
              minimumSize: const Size(32, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(
              CupertinoIcons.chat_bubble_text,
              color: kPrimary,
              size: 22,
            ),
          ),
          Obx(
            () => Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    if (main.isLoggedIn.value) {
                      Get.toNamed(Routes.CART);
                    } else {
                      Get.toNamed(Routes.LOGIN);
                    }
                  },
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(
                    CupertinoIcons.cart,
                    color: kPrimary,
                    size: 22,
                  ),
                ),
                if (main.cartCount.value > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        decoration: const BoxDecoration(
                          color: kPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${main.cartCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCategoryText extends StatefulWidget {
  const _AnimatedCategoryText();

  @override
  State<_AnimatedCategoryText> createState() => _AnimatedCategoryTextState();
}

class _AnimatedCategoryTextState extends State<_AnimatedCategoryText> {
  static const _labels = [
    'beauty',
    'skincare',
    'makeup',
    'parfume',
    'lipstick',
    'hair care',
  ];

  int _labelIndex = 0;
  String _displayed = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _typeWord();
  }

  void _typeWord() {
    _timer?.cancel();
    final word = _labels[_labelIndex];
    int i = 0;
    setState(() => _displayed = '');

    _timer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      i++;
      setState(() => _displayed = word.substring(0, i));
      if (i >= word.length) {
        t.cancel();
        // Pause lalu ketik kata berikutnya
        _timer = Timer(const Duration(milliseconds: 1800), () {
          if (!mounted) return;
          _labelIndex = (_labelIndex + 1) % _labels.length;
          _typeWord();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Cari produk ',
          style: TextStyle(fontSize: 13, color: kSubtext),
        ),
        Text(_displayed, style: const TextStyle(fontSize: 13, color: kSubtext)),
        const Text('...', style: TextStyle(fontSize: 13, color: kSubtext)),
      ],
    );
  }
}
