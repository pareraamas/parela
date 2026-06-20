import 'package:flutter/material.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/widgets/cached_image.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final String location;
  final SellerModel? seller;

  const ProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavorite,
    this.onTap,
    this.onAddToCart,
    this.location = 'Indonesia',
    this.seller,
  });

  int get _discountPct {
    if (product.discountPercent > 0) return product.discountPercent;
    if (product.originalPrice > product.price) {
      return ((product.originalPrice - product.price) /
              product.originalPrice *
              100)
          .round();
    }
    return 0;
  }

  String _fmtSold(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}JT+';
    if (count >= 1000) return '${(count / 1000).round()}RB+';
    return '$count';
  }

  String _fmtNum(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    final discount = _discountPct;
    final hasSaved = product.originalPrice > product.price;
    final savedAmount = (product.originalPrice - product.price).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
              child: Stack(
                children: [
                  CachedImage(
                    url: product.imageUrls.isNotEmpty
                        ? product.imageUrls.first
                        : null,
                    fallbackColor: product.color,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  // Discount badge — top-right corner
                  if (discount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          '-$discount%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  // Best badge — top-left
                  if (product.isBestSeller)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8F00),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 9,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'Best',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Favorite button — below discount badge
                  Positioned(
                    top: discount > 0 ? 30 : 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: kPrimary,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Content ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kText,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Promo savings tag
                  if (hasSaved)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFFF8F00),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          'Hemat Rp ${_fmtNum(savedAmount.toDouble())}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFFE65100),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  // Price
                  Text(
                    'Rp ${product.formattedPrice}',
                    style: const TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  if (hasSaved)
                    Text(
                      'Rp ${product.formattedOriginalPrice}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: kSubtext,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: kSubtext,
                      ),
                    ),
                  const SizedBox(height: 5),
                  // Rating + sold count
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFC107),
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          color: kText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (product.soldCount > 0) ...[
                        const SizedBox(width: 5),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: kSubtext,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${_fmtSold(product.soldCount)} terjual',
                          style: const TextStyle(fontSize: 10, color: kSubtext),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Location + add-to-cart button
                  Row(
                    children: [
                      if (seller?.isMall == true) ...[
                        _SellerBadge.mall(),
                        const SizedBox(width: 4),
                      ] else if (seller?.isOfficial == true) ...[
                        _SellerBadge.official(),
                        const SizedBox(width: 4),
                      ] else ...[
                        const Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: kSubtext,
                        ),
                        const SizedBox(width: 2),
                      ],
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: kSubtext),
                        ),
                      ),
                      if (onAddToCart != null)
                        GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
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
    );
  }
}

class _SellerBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;

  const _SellerBadge({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  factory _SellerBadge.mall() => const _SellerBadge(
        label: 'Mall',
        icon: Icons.store_rounded,
        bg: Color(0xFFFFEBEE),
        fg: Color(0xFFE53935),
      );

  factory _SellerBadge.official() => const _SellerBadge(
        label: 'Official',
        icon: Icons.verified_rounded,
        bg: Color(0xFFE3F2FD),
        fg: Color(0xFF1E88E5),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: fg),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
