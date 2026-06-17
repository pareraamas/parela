import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/home/widgets/product_card.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/category_products_controller.dart';

class CategoryProductsView extends GetView<CategoryProductsController> {
  const CategoryProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
          onPressed: Get.back,
        ),
        title: Text(
          controller.category.label,
          style: const TextStyle(
            color: kText,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: kText),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final p = controller.products[index];
          return Obx(
            () => ProductCard(
              product: p,
              isFavorite: main.wishlistIds.contains(p.id),
              onFavorite: () => main.toggleWishlist(p.id),
              onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: p),
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
      ),
    );
  }
}
