import 'package:flutter/material.dart';

class FlashSaleItemModel {
  final String productId;
  final String productName;
  final String brand;
  final String sellerId;
  final String sellerName;
  final String? imageUrl;
  final double originalPrice;
  final double flashSalePrice;
  final int discountPercent;
  final int flashSaleStock;
  final int soldCount;
  final int soldPercent;
  final Color color;

  const FlashSaleItemModel({
    required this.productId,
    required this.productName,
    required this.brand,
    required this.sellerId,
    required this.sellerName,
    this.imageUrl,
    required this.originalPrice,
    required this.flashSalePrice,
    required this.discountPercent,
    required this.flashSaleStock,
    required this.soldCount,
    required this.soldPercent,
    required this.color,
  });

  factory FlashSaleItemModel.fromJson(Map<String, dynamic> json) {
    return FlashSaleItemModel(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      brand: json['brand'] as String,
      sellerId: json['seller_id'] as String,
      sellerName: json['seller_name'] as String,
      imageUrl: json['image_url'] as String?,
      originalPrice: (json['original_price'] as num).toDouble(),
      flashSalePrice: (json['flash_sale_price'] as num).toDouble(),
      discountPercent: json['discount_percent'] as int,
      flashSaleStock: json['flash_sale_stock'] as int,
      soldCount: json['sold_count'] as int,
      soldPercent: json['sold_percent'] as int,
      color: _colorFromHex(json['color_hex'] as String? ?? '#D4548A'),
    );
  }

  static Color _colorFromHex(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
  }
}

class FlashSaleSessionModel {
  final String id;
  final String title;
  final DateTime endsAt;
  final List<FlashSaleItemModel> items;

  const FlashSaleSessionModel({
    required this.id,
    required this.title,
    required this.endsAt,
    required this.items,
  });

  factory FlashSaleSessionModel.fromJson(Map<String, dynamic> json) {
    return FlashSaleSessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      endsAt: DateTime.parse(json['ends_at'] as String),
      items: ((json['items'] as List?) ?? [])
          .map((j) => FlashSaleItemModel.fromJson(j as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FlashSaleModel {
  final FlashSaleSessionModel? currentSession;
  final List<Map<String, dynamic>> upcomingSessions;

  const FlashSaleModel({
    this.currentSession,
    this.upcomingSessions = const [],
  });

  factory FlashSaleModel.fromJson(Map<String, dynamic> json) {
    return FlashSaleModel(
      currentSession: json['current_session'] != null
          ? FlashSaleSessionModel.fromJson(
              json['current_session'] as Map<String, dynamic>)
          : null,
      upcomingSessions: ((json['upcoming_sessions'] as List?) ?? [])
          .map((j) => j as Map<String, dynamic>)
          .toList(),
    );
  }
}
