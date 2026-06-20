import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/review_model.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
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
            actions: [
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleWishlist,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isWishlisted
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: kPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: product.color,
                child: const Center(
                  child: Icon(Icons.image, size: 100, color: kPrimary),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            Routes.SELLER_STORE,
                            arguments: product.sellerId,
                          ),
                          child: Text(
                            product.brand,
                            style: const TextStyle(
                              color: kPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating} (${product.reviewCount})',
                          style: const TextStyle(color: kSubtext, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Rp ${product.formattedPrice}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: kPrimary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Rp ${product.formattedOriginalPrice}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: kSubtext,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Color',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      final selectedColor = controller.selectedColorIndex.value;
                      return Row(
                        children: List.generate(product.colors.length, (i) {
                          final isSelected = i == selectedColor;
                          return GestureDetector(
                            onTap: () => controller.selectedColorIndex.value = i,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color(product.colors[i]),
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: kPrimary, width: 2.5)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                    const SizedBox(height: 20),
                    const Text(
                      'Size',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      final selectedSize = controller.selectedSizeIndex.value;
                      return Wrap(
                        spacing: 10,
                        children: List.generate(product.sizes.length, (i) {
                          final isSelected = i == selectedSize;
                          return GestureDetector(
                            onTap: () => controller.selectedSizeIndex.value = i,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? kPrimary : kBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.sizes[i],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : kSubtext,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                    const SizedBox(height: 20),
                    const Divider(color: kBackground),
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(
                        color: kSubtext,
                        height: 1.6,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: kBackground),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reviews',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: kText,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: kText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...controller.reviews.map(_ReviewCard.new),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Obx(
              () => Row(
                children: [
                  _QtyBtn(Icons.remove, controller.decrementQty),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${controller.quantity.value}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _QtyBtn(Icons.add, controller.incrementQty),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: kPrimary),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard(this.review);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: kPrimaryLight,
                child: Text(
                  review.userName[0],
                  style: const TextStyle(
                    color: kPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: kText,
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  final stars = review.rating.round();
                  return Icon(
                    i < stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(color: kSubtext, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 4),
          Text(
            review.date,
            style: const TextStyle(color: kSubtext, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
