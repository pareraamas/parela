import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String brand;
  final String name;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final bool isBestSeller;
  final String sellerId;
  final String categoryId;
  final String description;
  final List<int> colors;
  final List<String> sizes;
  final String colorHex;
  final List<String> imageUrls;
  final int discountPercent;
  final int soldCount;

  const ProductModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.isBestSeller,
    required this.sellerId,
    required this.categoryId,
    required this.description,
    required this.colors,
    required this.sizes,
    this.colorHex = '#F8D7E5',
    this.imageUrls = const [],
    this.discountPercent = 0,
    this.soldCount = 0,
  });

  Color get color {
    try {
      final hex = colorHex.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFFF8D7E5);
    }
  }

  String get formattedPrice => _fmt(price);
  String get formattedOriginalPrice => _fmt(originalPrice);

  String _fmt(double v) => v.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
        id: j['id'] as String,
        brand: (j['brand'] as String?) ?? '',
        name: j['name'] as String,
        price: (j['price'] as num).toDouble(),
        originalPrice: (j['original_price'] as num? ?? j['price'] as num).toDouble(),
        rating: (j['rating'] as num? ?? 0).toDouble(),
        reviewCount: (j['review_count'] as int?) ?? 0,
        isBestSeller: (j['is_best_seller'] as bool?) ?? false,
        sellerId: (j['seller_id'] as String?) ?? '',
        categoryId: (j['category_id'] as String?) ?? '',
        description: (j['description'] as String?) ?? '',
        colors: ((j['colors'] as List?)?.cast<int>()) ?? const [],
        sizes: ((j['sizes'] as List?)?.cast<String>()) ?? const ['One Size'],
        colorHex: (j['color_hex'] as String?) ?? '#F8D7E5',
        imageUrls: ((j['image_urls'] as List?)?.cast<String>()) ?? const [],
        discountPercent: (j['discount_percent'] as int?) ?? 0,
        soldCount: (j['sold_count'] as int?) ?? 0,
      );
}
