import 'package:flutter/material.dart';

class BannerModel {
  final String tag;
  final String title;
  final String subtitle;
  final Color colorStart;
  final Color colorEnd;

  const BannerModel({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.colorStart,
    required this.colorEnd,
  });
}
