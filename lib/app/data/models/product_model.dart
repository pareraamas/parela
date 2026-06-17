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
  final Color color;
  final String description;
  final List<int> colors;
  final List<String> sizes;

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
    required this.color,
    required this.description,
    required this.colors,
    required this.sizes,
  });

  String get formattedPrice => _fmt(price);
  String get formattedOriginalPrice => _fmt(originalPrice);
  double get discountPercent =>
      ((originalPrice - price) / originalPrice * 100).roundToDouble();

  String _fmt(double v) => v.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}
