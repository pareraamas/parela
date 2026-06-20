import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/explore_tab/controllers/explore_tab_controller.dart';
import 'package:parela/app/modules/home/widgets/product_card.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/main/widgets/app_header.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class ExploreTab extends GetView<ExploreTabController> {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Column(
      children: [
        const AppHeader(title: 'Explore'),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: controller.searchTextController,
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: kSubtext, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: kSubtext),
                    suffixIcon: Icon(Icons.mic_outlined, color: kSubtext),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final categoryLabels = ['All', ...main.categories.map((c) => c.label)];
                return SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryLabels.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == controller.selectedCategoryIndex.value;
                      return GestureDetector(
                        onTap: () => controller.selectCategory(index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? kPrimary : kBackground,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            categoryLabels[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : kSubtext,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final products = main.products.toList();
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final p = products[index];
                return Obx(() => ProductCard(
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
                ));
              },
            );
          }),
        ),
      ],
    );
  }
}
