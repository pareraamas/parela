import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String label;
  final IconData icon;
  final String? imageUrl;
  final int productCount;

  const CategoryModel({
    required this.id,
    required this.label,
    required this.icon,
    this.imageUrl,
    this.productCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
        id: j['id'] as String,
        label: j['label'] as String,
        icon: _iconFromName((j['icon'] as String?) ?? ''),
        imageUrl: j['image_url'] as String?,
        productCount: (j['product_count'] as int?) ?? 0,
      );

  static IconData _iconFromName(String name) {
    const map = <String, IconData>{
      'water_drop': Icons.water_drop,
      'visibility': Icons.visibility,
      'local_florist': Icons.local_florist,
      'face': Icons.face,
      'spa': Icons.spa,
      'content_cut': Icons.content_cut,
      'color_lens': Icons.color_lens,
      'handyman': Icons.handyman,
      'brush': Icons.brush,
      'remove_red_eye': Icons.remove_red_eye,
      'star': Icons.star,
      'favorite': Icons.favorite,
      'shopping_bag': Icons.shopping_bag,
    };
    return map[name] ?? Icons.category;
  }
}
