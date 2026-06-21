import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/flash_sale_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/product_detail_controller.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/widgets/shimmer.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    final discount = product.originalPrice > product.price
        ? ((product.originalPrice - product.price) /
                  product.originalPrice *
                  100)
              .round()
        : 0;

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).padding.top,
                ),
                // ── Image gallery ───────────────────────────────────────
                _ImageGallery(product: product),

                // ── Price card ────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flash sale banner strip
                      if (controller.isFlashSale)
                        _FlashSaleBanner(item: controller.flashSaleItem!),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Rp ${product.formattedPrice}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: controller.isFlashSale
                                        ? const Color(0xFFFF5722)
                                        : kPrimary,
                                  ),
                                ),
                                if (discount > 0) ...[
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: controller.isFlashSale
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFFFF5722),
                                                Color(0xFFFF9800),
                                              ],
                                            )
                                          : null,
                                      color: controller.isFlashSale
                                          ? null
                                          : kPrimary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '$discount%',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Rp ${product.formattedOriginalPrice}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: kSubtext,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: kText,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                if (product.isBestSeller) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kPrimaryLight,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Best Seller',
                                      style: TextStyle(
                                        color: kPrimary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 15,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${product.rating}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kText,
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  width: 1,
                                  height: 12,
                                  color: kSubtext.withValues(alpha: 0.4),
                                ),
                                Text(
                                  '${_fmtCount(product.reviewCount)} ulasan',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kSubtext,
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  width: 1,
                                  height: 12,
                                  color: kSubtext.withValues(alpha: 0.4),
                                ),
                                Text(
                                  '${_fmtCount(product.soldCount)} terjual',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kSubtext,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Warna ─────────────────────────────────────────────────
                if (product.colors.isNotEmpty)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final sel = controller.selectedColorIndex.value;
                          final colorName =
                              product.sizes.length > product.colors.length
                              ? null
                              : (sel < product.sizes.length
                                    ? product.sizes[sel]
                                    : null);
                          return Row(
                            children: [
                              const Text(
                                'Warna: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: kText,
                                ),
                              ),
                              if (colorName != null)
                                Text(
                                  colorName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: kSubtext,
                                  ),
                                ),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),
                        Obx(() {
                          final sel = controller.selectedColorIndex.value;
                          return Row(
                            children: List.generate(product.colors.length, (i) {
                              final isSelected = i == sel;
                              return GestureDetector(
                                onTap: () =>
                                    controller.selectedColorIndex.value = i,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: Color(product.colors[i]),
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: kPrimary,
                                            width: 2.5,
                                          )
                                        : null,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.12,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              );
                            }),
                          );
                        }),
                      ],
                    ),
                  ),

                // ── Ukuran ────────────────────────────────────────────────
                if (product.sizes.isNotEmpty)
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final sel = controller.selectedSizeIndex.value;
                          return Row(
                            children: [
                              const Text(
                                'Ukuran: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: kText,
                                ),
                              ),
                              Text(
                                product.sizes[sel],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: kSubtext,
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),
                        Obx(() {
                          final sel = controller.selectedSizeIndex.value;
                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(product.sizes.length, (i) {
                              final isSelected = i == sel;
                              return GestureDetector(
                                onTap: () =>
                                    controller.selectedSizeIndex.value = i,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected ? kPrimary : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? kPrimary
                                          : kSubtext.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    product.sizes[i],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : kText,
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
                      ],
                    ),
                  ),

                const SizedBox(height: 8),

                // ── Seller card ───────────────────────────────────────────
                Obx(() {
                  final s = controller.seller.value;
                  if (s == null) return const SizedBox.shrink();
                  return _SellerCard(seller: s, product: product);
                }),

                const SizedBox(height: 8),

                // ── Deskripsi ─────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Deskripsi Produk',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: kText,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.description,
                        style: const TextStyle(
                          color: kSubtext,
                          height: 1.7,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Ulasan ────────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Ulasan Pembeli',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: kText,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 15,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: kText,
                            ),
                          ),
                          Text(
                            ' / 5',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kSubtext,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Obx(() {
                        if (controller.isLoadingReviews.value) {
                          return AppShimmer(
                            child: Column(
                              children: List.generate(
                                3,
                                (_) => const ShimmerListRow(),
                              ),
                            ),
                          );
                        }
                        if (controller.reviews.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Belum ada ulasan',
                                style: TextStyle(color: kSubtext, fontSize: 13),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: controller.reviews
                              .map(_ReviewCard.new)
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // ── Floating overlay buttons ─────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _CircleBtn(
                    onTap: Get.back,
                    child: const Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: kText,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  _WishlistBtn(controller: controller),
                  const SizedBox(width: 8),
                  _CircleBtn(
                    onTap: () => _showShareSheet(context, product),
                    child: const Icon(
                      CupertinoIcons.arrowshape_turn_up_right_fill,
                      color: kPrimary,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom bar ───────────────────────────────────────────────────
      bottomSheet: _BottomBar(controller: controller),
    );
  }
}

// ── Image Gallery ─────────────────────────────────────────────────────────────

class _ImageGallery extends StatefulWidget {
  final ProductModel product;
  const _ImageGallery({required this.product});

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.product.imageUrls;
    final color = widget.product.color;

    if (images.isEmpty) {
      return _FallbackHero(product: widget.product);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () => _openFullScreen(ctx, images, i),
              child: SizedBox.expand(
                child: Image.asset(
                  images[i],
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, _, _) => Container(
                    color: color,
                    child: Center(
                      child: Text(
                        widget.product.brand.isNotEmpty
                            ? widget.product.brand[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

void _openFullScreen(
  BuildContext context,
  List<String> images,
  int initialIndex,
) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, _, _) =>
          _FullScreenGallery(images: images, initialIndex: initialIndex),
      transitionsBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    ),
  );
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const _FullScreenGallery({required this.images, required this.initialIndex});

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late final PageController _ctrl;
  late int _page;

  @override
  void initState() {
    super.initState();
    _page = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Swipeable zoomable images ─────────────────────────────
          PageView.builder(
            controller: _ctrl,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: Image.asset(
                  widget.images[i],
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.broken_image_rounded,
                    color: Colors.white38,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),

          // ── Close button ──────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // ── Page counter ──────────────────────────────────────────
          if (widget.images.length > 1)
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _FallbackHero extends StatelessWidget {
  final ProductModel product;
  const _FallbackHero({required this.product});

  @override
  Widget build(BuildContext context) {
    final c = product.color;
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c.withValues(alpha: 0.2), c.withValues(alpha: 0.5)],
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: c.withValues(alpha: 0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  product.brand.isNotEmpty
                      ? product.brand[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: c,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Flash Sale Banner ─────────────────────────────────────────────────────────

class _FlashSaleBanner extends StatelessWidget {
  final FlashSaleItemModel item;
  const _FlashSaleBanner({required this.item});

  @override
  Widget build(BuildContext context) {
    final soldPercent = item.soldPercent.clamp(0, 100);
    final almostOut = soldPercent >= 70;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFF8F5)],
        ),
        border: Border(
          bottom: BorderSide(color: Color(0xFFFFE0B2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: Colors.white, size: 12),
                SizedBox(width: 2),
                Text(
                  'FLASH SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: soldPercent / 100,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFFFE0B2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      almostOut
                          ? const Color(0xFFFF5722)
                          : const Color(0xFFFF9800),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  almostOut
                      ? 'Hampir habis! Sisa ${100 - soldPercent}%'
                      : 'Terjual $soldPercent%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: almostOut
                        ? const Color(0xFFFF5722)
                        : const Color(0xFFE65100),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Seller Card ───────────────────────────────────────────────────────────────

class _SellerCard extends StatelessWidget {
  final SellerModel seller;
  final ProductModel product;
  const _SellerCard({required this.seller, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: seller.avatarUrl != null
                    ? Image.asset(
                        seller.avatarUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _AvatarFallback(name: seller.name, size: 48),
                      )
                    : _AvatarFallback(name: seller.name, size: 48),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            seller.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: kText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (seller.isMall)
                          _BadgeChip(
                            label: 'Mall',
                            color: const Color(0xFFFF5722),
                          ),
                        if (!seller.isMall && seller.isOfficial)
                          _BadgeChip(
                            label: 'Official',
                            color: const Color(0xFF1976D2),
                          ),
                        if (seller.verified &&
                            !seller.isMall &&
                            !seller.isOfficial)
                          const Icon(
                            Icons.verified_rounded,
                            color: kPrimary,
                            size: 16,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: kSubtext,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          seller.location,
                          style: const TextStyle(fontSize: 11, color: kSubtext),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${seller.rating}',
                          style: const TextStyle(fontSize: 11, color: kSubtext),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Get.toNamed(
                  Routes.SELLER_STORE,
                  arguments: product.sellerId,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Kunjungi',
                    style: TextStyle(
                      fontSize: 12,
                      color: kPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: kBackground),
          const SizedBox(height: 10),
          Row(
            children: [
              _SellerStat(label: 'Penilaian', value: '${seller.rating}'),
              _SellerDivider(),
              _SellerStat(label: 'Terjual', value: _fmtCount(seller.soldCount)),
              _SellerDivider(),
              _SellerStat(label: 'Respon', value: seller.responseRate ?? '-'),
              _SellerDivider(),
              _SellerStat(label: 'Waktu', value: seller.responseTime ?? '-'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final Color color;
  const _BadgeChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String name;
  final double size;
  const _AvatarFallback({required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: kPrimaryLight,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
            color: kPrimary,
          ),
        ),
      ),
    );
  }
}

class _SellerStat extends StatelessWidget {
  final String label;
  final String value;
  const _SellerStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: kSubtext)),
        ],
      ),
    );
  }
}

class _SellerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: kBackground,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final ProductDetailController controller;
  const _BottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BarIconBtn(
                  icon: CupertinoIcons.chat_bubble_text,
                  onTap: () => Get.toNamed(Routes.MESSAGES),
                ),
                SizedBox(
                  height: 28,
                  child: VerticalDivider(color: kPrimary, width: 1),
                ),
                Obx(() {
                  final count = Get.find<MainController>().cartCount.value;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _BarIconBtn(
                        icon: CupertinoIcons.cart,
                        onTap: () => Get.toNamed(Routes.CART),
                      ),
                      if (count > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            decoration: const BoxDecoration(
                              color: kPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${count > 99 ? 99 : count}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                elevation: 0,

                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size.fromHeight(48),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'Tambah ke Keranjang',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Review Card ───────────────────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard(this.review);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(14),
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
                  review.userName[0].toUpperCase(),
                  style: const TextStyle(
                    color: kPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: kText,
                      ),
                    ),
                    Text(
                      review.date,
                      style: const TextStyle(color: kSubtext, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  final stars = review.rating.round();
                  return Icon(
                    i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 13,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(color: kSubtext, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

// ── Wishlist button with bounce animation ─────────────────────────────────────

class _WishlistBtn extends StatefulWidget {
  final ProductDetailController controller;
  const _WishlistBtn({required this.controller});

  @override
  State<_WishlistBtn> createState() => _WishlistBtnState();
}

class _WishlistBtnState extends State<_WishlistBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.45, end: 0.85), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _tap() {
    widget.controller.toggleWishlist();
    _anim.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Obx(
            () => ScaleTransition(
              scale: _scale,
              child: Icon(
                widget.controller.isWishlisted
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: kPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Share bottom sheet ────────────────────────────────────────────────────────

void _showShareSheet(BuildContext context, ProductModel product) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _ShareSheet(product: product),
  );
}

class _ShareSheet extends StatelessWidget {
  final ProductModel product;
  const _ShareSheet({required this.product});

  static final _platforms = [
    (
      icon: Icons.chat_rounded,
      label: 'WhatsApp',
      color: const Color(0xFF25D366),
    ),
    (
      icon: Icons.photo_camera_rounded,
      label: 'Instagram',
      color: const Color(0xFFE1306C),
    ),
    (
      icon: Icons.people_rounded,
      label: 'Teman',
      color: const Color(0xFF1877F2),
    ),
    (icon: Icons.more_horiz_rounded, label: 'Lainnya', color: kSubtext),
  ];

  @override
  Widget build(BuildContext context) {
    final mockUrl = 'parela.app/p/${product.id}';
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: kText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${product.formattedPrice}',
            style: const TextStyle(
              fontSize: 13,
              color: kPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: _platforms.map((p) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: p.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(p.icon, color: p.color, size: 26),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.label,
                        style: const TextStyle(fontSize: 11, color: kSubtext),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: kBackground),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: mockUrl));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tautan disalin'),
                  backgroundColor: kPrimary,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.link_rounded, color: kPrimary, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Salin Tautan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _BarIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: kPrimary, size: 28),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _CircleBtn({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}

String _fmtCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}jt';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}rb';
  return n.toString();
}
