import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final selectedNavIndex = 0.obs;

  final stories = [
    {'label': 'Story Na..', 'color': const Color(0xFFFFCDD2)},
    {'label': 'Story Na..', 'color': const Color(0xFFF8BBD0)},
    {'label': 'Story Na..', 'color': const Color(0xFFE1BEE7)},
    {'label': 'Story Na..', 'color': const Color(0xFFBBDEFB)},
    {'label': 'Story Na..', 'color': const Color(0xFFB2EBF2)},
  ];

  final categories = [
    {'label': 'Makeup', 'icon': Icons.brush},
    {'label': 'Parfume', 'icon': Icons.local_florist},
    {'label': 'EyeLash', 'icon': Icons.remove_red_eye},
    {'label': 'Beauty', 'icon': Icons.face},
    {'label': 'Makeup', 'icon': Icons.brush},
    {'label': 'Parfume', 'icon': Icons.local_florist},
  ];

  final products = [
    {
      'brand': 'BOURJOIS',
      'name': 'Bourjois Twist Up The Volume',
      'isBestSeller': true,
    },
    {
      'brand': 'MAYBELLINE',
      'name': 'Maybelline Grippy Serum +2%',
      'isBestSeller': true,
    },
    {
      'brand': 'LOREAL',
      'name': "L'Oréal Paris Infallible Foundation",
      'isBestSeller': false,
    },
    {
      'brand': 'NYX',
      'name': 'NYX Professional Lip Liner',
      'isBestSeller': true,
    },
  ];

}
