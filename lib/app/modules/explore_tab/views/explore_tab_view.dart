import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/flash_sale_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/modules/explore_tab/controllers/explore_tab_controller.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';
import 'package:parela/app/widgets/product_card.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/main/widgets/app_header.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class ExploreTab extends GetView<ExploreTabController> {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    final homeTab = Get.find<HomeTabController>();
    return Column(
      children: [
        const AppHeader(heroTag: 'search-bar-explore'),
        Expanded(
          child: CustomScrollView(
            slivers: [
              // ── Flash Sale section ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoadingFlashSale.value) {
                    return _FlashSaleShimmer();
                  }
                  final session = controller.flashSale.value?.currentSession;
                  if (session == null || session.items.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return _FlashSaleSection(
                    session: session,
                    countdown: controller.countdown,
                    products: controller.flashSaleProducts,
                  );
                }),
              ),

              // ── Products grid (masonry) ───────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
                sliver: Obx(() {
                  final products = homeTab.products.toList();
                  return SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return Obx(
                        () => ProductCard(
                          product: p,
                          seller: main.sellerById(p.sellerId),
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
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Flash Sale Section ──────────────────────────────────────────────────────

class _FlashSaleSection extends StatelessWidget {
  final FlashSaleSessionModel session;
  final RxString countdown;
  final Map<String, ProductModel> products;

  const _FlashSaleSection({
    required this.session,
    required this.countdown,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, color: Colors.white, size: 14),
                      SizedBox(width: 2),
                      Text(
                        'FLASH SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                ),
                const Spacer(),
                // Countdown
                Obx(() => _CountdownBadge(countdown.value)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Cards horizontal scroll
          SizedBox(
            height: 234,
            child: ListView.builder(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, right: 8),
              itemCount: session.items.length,
              itemBuilder: (context, index) => _FlashSaleCard(
                item: session.items[index],
                fullProduct: products[session.items[index].productId],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
        ],
      ),
    );
  }
}

class _CountdownBadge extends StatelessWidget {
  final String time;
  const _CountdownBadge(this.time);

  @override
  Widget build(BuildContext context) {
    final parts = time.split(':');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 13,
          color: Color(0xFFFF5722),
        ),
        const SizedBox(width: 4),
        ...List.generate(parts.length, (i) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: kText,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  parts[i],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              if (i < parts.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    ':',
                    style: TextStyle(
                      color: kText,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

class _FlashSaleCard extends StatelessWidget {
  final FlashSaleItemModel item;
  final ProductModel? fullProduct;
  const _FlashSaleCard({required this.item, this.fullProduct});

  String _formatPrice(double price) {
    final s = price.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return 'Rp ${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final product = fullProduct ?? ProductModel(
          id: item.productId,
          brand: item.brand,
          name: item.productName,
          price: item.flashSalePrice,
          originalPrice: item.originalPrice,
          rating: 0,
          reviewCount: 0,
          isBestSeller: false,
          sellerId: item.sellerId,
          categoryId: '',
          description: '',
          colors: [item.color.toARGB32()],
          sizes: const ['One Size'],
          imageUrls: item.imageUrl != null ? [item.imageUrl!] : const [],
          discountPercent: item.discountPercent,
          soldCount: item.soldCount,
        );
        Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product);
      },
      child: Container(
        width: 140,
        height: 230,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: item.imageUrl != null
                      ? Image.asset(
                          item.imageUrl!,
                          width: 140,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 140,
                            height: 110,
                            color: item.color,
                          ),
                        )
                      : Container(width: 140, height: 110, color: item.color),
                ),
                // Info section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.brand,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: kText.withValues(alpha: 0.55),
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: kText,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          _formatPrice(item.flashSalePrice),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: kPrimary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _formatPrice(item.originalPrice),
                          style: TextStyle(
                            fontSize: 10,
                            color: kSubtext.withValues(alpha: 0.8),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: item.soldPercent / 100,
                            minHeight: 5,
                            backgroundColor: const Color(0xFFF0F0F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFF5722),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Terjual ${item.soldPercent}%',
                          style: TextStyle(
                            fontSize: 9,
                            color: kText.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Discount badge
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '-${item.discountPercent}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading shimmer ──────────────────────────────────────────────────────────

class _FlashSaleShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 24,
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 234,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, i) => Container(
                width: 140,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: kBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
