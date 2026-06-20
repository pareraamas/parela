import 'package:flutter/material.dart';

class BannerModel {
  final String? id;
  final String tag;
  final String title;
  final String subtitle;
  final Color colorStart;
  final Color colorEnd;
  final String? imageUrl;
  final String? actionUrl;

  const BannerModel({
    this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.colorStart,
    required this.colorEnd,
    this.imageUrl,
    this.actionUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> j) => BannerModel(
        id: j['id'] as String?,
        tag: (j['tag'] as String?) ?? '',
        title: j['title'] as String,
        subtitle: (j['subtitle'] as String?) ?? '',
        colorStart: _colorFromHex((j['color_start'] as String?) ?? '#F8D7E5'),
        colorEnd: _colorFromHex((j['color_end'] as String?) ?? '#FCE4EC'),
        imageUrl: j['image_url'] as String?,
        actionUrl: j['action_url'] as String?,
      );

  static Color _colorFromHex(String hex) {
    try {
      final clean = hex.replaceFirst('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return const Color(0xFFF8D7E5);
    }
  }
}
