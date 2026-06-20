import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';
import 'package:parela/app/modules/home/widgets/banner_carousel.dart';
import 'package:parela/app/modules/home/widgets/category_row.dart';
import 'package:parela/app/modules/home/widgets/product_card.dart';
import 'package:parela/app/modules/home/widgets/story_row.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/main/widgets/app_header.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class HomeTab extends GetView<HomeTabController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Column(
      children: [
        const AppHeader(),
        Expanded(
          child: Obx(() {
            final isLoading = main.isLoading.value;
            final products = main.products.toList();
            final banners = main.banners.toList();
            final stories = main.stories.toList();
            final categories = main.categories.toList();

            if (isLoading && products.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: kPrimary));
            }
            final items = products.take(4).toList();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BannerCarousel(banners: banners),
                  StoryRow(stories: stories),
                  const SizedBox(height: 16),
                  _SectionHeader(
                    title: 'Categories',
                    onSeeAll: () => Get.toNamed(Routes.ALL_PRODUCTS),
                  ),
                  const SizedBox(height: 10),
                  CategoryRow(
                    categories: categories,
                    onTap: (cat) => Get.toNamed(Routes.CATEGORY_PRODUCTS, arguments: cat),
                  ),
                  const SizedBox(height: 16),
                  _SectionHeader(
                    title: 'Makeup Products',
                    onSeeAll: () => Get.toNamed(Routes.ALL_PRODUCTS),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final p = items[index];
                        return Obx(
                          () => ProductCard(
                            product: p,
                            isFavorite: main.wishlistIds.contains(p.id),
                            onFavorite: () => main.toggleWishlist(p.id),
                            onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: p),
                            onAddToCart: () => main.addToCart(CartItemModel(
                              productId: p.id,
                              quantity: 1,
                              color: p.colors.isNotEmpty ? p.colors.first : 0xFF000000,
                              size: p.sizes.isNotEmpty ? p.sizes.first : 'One Size',
                              price: p.price,
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kText)),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('See All', style: TextStyle(color: kSubtext, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
