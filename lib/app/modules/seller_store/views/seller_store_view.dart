import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/widgets/cached_image.dart';
import 'package:parela/app/widgets/shimmer.dart';
import 'package:parela/app/widgets/product_card.dart';
import '../controllers/seller_store_controller.dart';

class SellerStoreView extends GetView<SellerStoreController> {
  const SellerStoreView({super.key});

  static String _fmt(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}Jt';
    if (v >= 1000) return '${(v / 1000).round()}Rb';
    return '$v';
  }

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final seller = controller.seller.value;
        if (seller == null) {
          return const ShimmerProductGrid();
        }
        return CustomScrollView(
          slivers: [
            // ── App bar ──────────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                onPressed: Get.back,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: kText,
                  size: 18,
                ),
              ),
              title: Text(
                seller.name,
                style: const TextStyle(
                  color: kText,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
              actions: [
                Obx(
                  () => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () => Get.toNamed(
                          main.isLoggedIn.value ? Routes.CART : Routes.LOGIN,
                        ),
                        icon: const Icon(
                          CupertinoIcons.cart,
                          color: kPrimary,
                          size: 22,
                        ),
                      ),
                      if (main.cartCount.value > 0)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
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
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Seller info section ───────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  children: [
                    // avatar
                    ClipOval(
                      child: seller.avatarUrl != null
                          ? CachedImage(
                              url: seller.avatarUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              fallbackColor: kPrimaryLight,
                              fallbackIcon: Text(
                                seller.name[0],
                                style: const TextStyle(
                                  color: kPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                          : Container(
                              width: 56,
                              height: 56,
                              color: kPrimaryLight,
                              child: Center(
                                child: Text(
                                  seller.name[0],
                                  style: const TextStyle(
                                    color: kPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    // name + stats
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                seller.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kText,
                                ),
                              ),
                              if (seller.verified) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: kPrimary,
                                  size: 14,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _StatChip(
                                icon: Icons.star_rounded,
                                iconColor: const Color(0xFFFFC107),
                                label: seller.rating.toStringAsFixed(1),
                              ),
                              const SizedBox(width: 10),
                              _StatChip(
                                label:
                                    '${_fmt(seller.followerCount)} Followers',
                              ),
                              const SizedBox(width: 10),
                              _StatChip(
                                label: '${_fmt(seller.soldCount)} Terjual',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // action buttons
                    Column(
                      children: [
                        _ActionBtn(
                          label: 'Follow',
                          outlined: true,
                          onTap: () {},
                        ),
                        const SizedBox(height: 6),
                        _ActionBtn(
                          label: 'Chat',
                          outlined: false,
                          onTap: () => Get.toNamed(Routes.MESSAGES),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // ── Masonry grid ──────────────────────────────────────────────
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: ShimmerProductGrid(),
                );
              }
              if (controller.products.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Belum ada produk',
                      style: TextStyle(color: kSubtext),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final p = controller.products[index];
                    return Obx(
                      () => ProductCard(
                        product: p,
                        isFavorite: main.wishlistIds.contains(p.id),
                        onFavorite: () => main.toggleWishlist(p.id),
                        onTap: () =>
                            Get.toNamed(Routes.PRODUCT_DETAIL, arguments: p),
                        onAddToCart: () => main.addToCart(
                          CartItemModel(
                            productId: p.id,
                            quantity: 1,
                            color: p.colors.first,
                            size: p.sizes.first,
                            price: p.price,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  const _StatChip({required this.label, this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 2),
        ],
        Text(label, style: const TextStyle(fontSize: 11, color: kSubtext)),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final bool outlined;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.label,
    required this.outlined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: outlined ? Colors.white : kPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kPrimary),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: outlined ? kPrimary : Colors.white,
          ),
        ),
      ),
    );
  }
}
