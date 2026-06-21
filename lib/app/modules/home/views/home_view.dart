import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';
import 'package:parela/app/modules/home/widgets/banner_carousel.dart';
import 'package:parela/app/modules/home/widgets/category_row.dart';
import 'package:parela/app/widgets/product_card.dart';
import 'package:parela/app/modules/home/widgets/story_row.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/main/widgets/app_header.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/widgets/shimmer.dart';

// sellerId → location (matches MockContent.mockSellers)
const _sellerLocations = {
  's001': 'Jakarta Selatan',
  's002': 'Bandung',
  's003': 'Jakarta Pusat',
  's004': 'Surabaya',
  's005': 'Yogyakarta',
};

// StatefulWidget agar ScrollController lifecycle-nya ikut widget tree,
// bukan GetX controller lifecycle — mencegah "used after disposed" error.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final ScrollController _scrollController;
  late final HomeTabController _ctrl;
  late final MainController _main;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<HomeTabController>();
    _main = Get.find<MainController>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _ctrl.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(),
        Expanded(
          child: Obx(() {
            final isLoading = _ctrl.isLoading.value;
            final items = _ctrl.products.toList();
            final banners = _ctrl.banners.toList();
            final stories = _ctrl.stories.toList();
            final categories = _ctrl.categories.toList();
            final isLoadingMore = _ctrl.isLoadingMore.value;

            if (isLoading && items.isEmpty) {
              return const ShimmerProductGrid(count: 6);
            }

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BannerCarousel(banners: banners),
                  StoryRow(
                    stories: stories,
                    onTap: (index) => Get.toNamed(
                      Routes.STORY,
                      arguments: {'stories': stories, 'initialIndex': index},
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SectionHeader(
                    title: 'Categories',
                    onSeeAll: () => Get.toNamed(Routes.ALL_PRODUCTS),
                  ),
                  const SizedBox(height: 8),
                  CategoryRow(
                    categories: categories,
                    onTap: (cat) =>
                        Get.toNamed(Routes.CATEGORY_PRODUCTS, arguments: cat),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final p = items[index];
                        return Obx(
                          () => ProductCard(
                            product: p,
                            isFavorite: _main.wishlistIds.contains(p.id),
                            location:
                                _sellerLocations[p.sellerId] ?? 'Indonesia',
                            seller: _main.sellerById(p.sellerId),
                            onFavorite: () => _main.toggleWishlist(p.id),
                            onTap: () => Get.toNamed(
                              Routes.PRODUCT_DETAIL,
                              arguments: p,
                            ),
                            onAddToCart: () => _main.addToCart(
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
                  const SizedBox(height: 16),
                  if (isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: kPrimary,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 31, 31, 74),
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'See All',
              style: TextStyle(color: kSubtext, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
