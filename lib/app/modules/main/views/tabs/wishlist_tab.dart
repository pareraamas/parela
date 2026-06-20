import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';
import 'package:parela/app/widgets/product_card.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class WishlistTab extends StatelessWidget {
  const WishlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    final homeTab = Get.find<HomeTabController>();
    return Obx(() {
      final saved = homeTab.products
          .where((p) => main.wishlistIds.contains(p.id))
          .toList();
      return Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: const Text(
              'Saved Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kText,
              ),
            ),
          ),
          saved.isEmpty
              ? const Expanded(child: _EmptyWishlist())
              : Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: saved.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final p = saved[index];
                      return ProductCard(
                        product: p,
                        isFavorite: true,
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
                      );
                    },
                  ),
                ),
        ],
      );
    });
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: kPrimaryLight),
          SizedBox(height: 16),
          Text(
            'No saved items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kText,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the heart icon to save products',
            style: TextStyle(color: kSubtext),
          ),
        ],
      ),
    );
  }
}
