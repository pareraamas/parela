import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/home/widgets/product_card.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/seller_store_controller.dart';

class SellerStoreView extends GetView<SellerStoreController> {
  const SellerStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    final seller = controller.seller;
    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: kPrimary,
            leading: GestureDetector(
              onTap: Get.back,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios, color: kText, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kPrimary, Color(0xFFE91E8C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white,
                        child: Text(
                          seller.name[0],
                          style: const TextStyle(
                            color: kPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            seller.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          if (seller.verified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${seller.rating}  •  ${seller.productCount} products',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final p = controller.products[index];
                  return Obx(
                    () => ProductCard(
                      product: p,
                      isFavorite: main.wishlistIds.contains(p.id),
                      onFavorite: () => main.toggleWishlist(p.id),
                      onTap: () =>
                          Get.toNamed(Routes.PRODUCT_DETAIL, arguments: p),
                      onAddToCart: () => main.addToCart(CartItemModel(
                        productId: p.id,
                        quantity: 1,
                        color: p.colors.first,
                        size: p.sizes.first,
                        price: p.price,
                      )),
                    ),
                  );
                },
                childCount: controller.products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
