import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/widgets/product_card.dart';
import 'package:parela/app/modules/search/controllers/search_result_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

const _sellerLocations = {
  's001': 'Jakarta',
  's002': 'Bandung',
  's003': 'Surabaya',
  's004': 'Bali',
  's005': 'Jakarta',
};

class SearchResultView extends GetView<SearchResultController> {
  const SearchResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ───────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: kText,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Hero(
                        tag: 'search-bar',
                        child: Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () => Get.offNamed(
                              Routes.SEARCH,
                              arguments: controller.query.value,
                            ),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: kBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: kPrimary.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search_rounded,
                                    color: kSubtext,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      controller.query.value,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: kText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Sort chips ────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.sortLabels.length, (i) {
                      final selected = controller.sortIndex.value == i;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => controller.setSort(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: selected ? kPrimary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? kPrimary
                                    : kSubtext.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              controller.sortLabels[i],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : kText,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // ── Results ───────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                final items = controller.results.toList();

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 72,
                          color: kSubtext,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Produk "${controller.query.value}" tidak ditemukan',
                          style: const TextStyle(color: kSubtext, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Coba kata kunci lain',
                          style: TextStyle(color: kSubtext, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${items.length} produk ditemukan',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kSubtext,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final p = items[index];
                          return Obx(
                            () => ProductCard(
                              product: p,
                              isFavorite: main.wishlistIds.contains(p.id),
                              location:
                                  _sellerLocations[p.sellerId] ?? 'Indonesia',
                              onFavorite: () => main.toggleWishlist(p.id),
                              onTap: () => Get.toNamed(
                                Routes.PRODUCT_DETAIL,
                                arguments: p,
                              ),
                              onAddToCart: () => main.addToCart(
                                CartItemModel(
                                  productId: p.id,
                                  quantity: 1,
                                  color: p.colors.isNotEmpty
                                      ? p.colors.first
                                      : 0xFF000000,
                                  size: p.sizes.isNotEmpty
                                      ? p.sizes.first
                                      : 'One Size',
                                  price: p.price,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
