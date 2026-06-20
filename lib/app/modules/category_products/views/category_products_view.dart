import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/main/widgets/app_header.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/widgets/product_card.dart';
import '../controllers/category_products_controller.dart';

class CategoryProductsView extends GetView<CategoryProductsController> {
  const CategoryProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: controller.category.label,
              leading: IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  minimumSize: const Size(36, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimary),
                  );
                }
                if (controller.products.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada produk di kategori ini',
                      style: TextStyle(color: kSubtext),
                    ),
                  );
                }
                return MasonryGridView.count(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: controller.products.length,
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
