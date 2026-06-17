import 'package:flutter/material.dart';
import 'package:parela/app/theme/app_colors.dart';

class MockContent {
  MockContent._();

  static const Map<String, dynamic> mockUser = {
    'id': 'u001',
    'name': 'Muhammad Farhan',
    'email': 'farhan@email.com',
    'phone': '+62 812-3456-7890',
    'address': 'Jl. Sudirman No. 12, Jakarta Selatan',
    'verified': true,
    'avatarColor': 0xFFD4548A,
  };

  static final List<Map<String, dynamic>> mockProducts = [
    {
      'id': 'p001',
      'brand': 'BOURJOIS',
      'name': 'Bourjois Twist Up The Volume',
      'price': 189000.0,
      'originalPrice': 250000.0,
      'rating': 4.8,
      'reviewCount': 1240,
      'isBestSeller': true,
      'sellerId': 's001',
      'categoryId': 'c001',
      'color': kPrimaryLight,
      'description':
          'A volumizing mascara with a twist-up brush. Perfect for dramatic lashes that last all day without smudging.',
      'colors': [0xFF000000, 0xFF4A1010, 0xFF1A237E],
      'sizes': ['5ml', '10ml'],
    },
    {
      'id': 'p002',
      'brand': 'MAYBELLINE',
      'name': 'Maybelline Grippy Serum +2%',
      'price': 220000.0,
      'originalPrice': 280000.0,
      'rating': 4.6,
      'reviewCount': 876,
      'isBestSeller': true,
      'sellerId': 's002',
      'categoryId': 'c004',
      'color': Color(0xFFE8F5E9),
      'description':
          'A lightweight serum that grips pigment for long-lasting color. Infused with 2% niacinamide for radiant skin.',
      'colors': [0xFFE91E63, 0xFF9C27B0, 0xFFFF5722],
      'sizes': ['30ml', '50ml'],
    },
    {
      'id': 'p003',
      'brand': 'LOREAL',
      'name': "L'Oréal Paris Infallible Foundation",
      'price': 165000.0,
      'originalPrice': 200000.0,
      'rating': 4.5,
      'reviewCount': 2341,
      'isBestSeller': false,
      'sellerId': 's001',
      'categoryId': 'c001',
      'color': Color(0xFFFFF9C4),
      'description':
          'Full-coverage foundation with up to 24-hour wear. Lightweight formula that blends seamlessly.',
      'colors': [0xFFD7A87B, 0xFFC4956A, 0xFFB07B50],
      'sizes': ['N10', 'N20', 'N30', 'N40'],
    },
    {
      'id': 'p004',
      'brand': 'NYX',
      'name': 'NYX Professional Lip Liner',
      'price': 95000.0,
      'originalPrice': 120000.0,
      'rating': 4.7,
      'reviewCount': 654,
      'isBestSeller': true,
      'sellerId': 's003',
      'categoryId': 'c001',
      'color': Color(0xFFFCE4EC),
      'description':
          'Define and line your lips with this long-lasting pencil. Creamy formula glides on effortlessly.',
      'colors': [0xFFE91E63, 0xFFAD1457, 0xFFBF360C],
      'sizes': ['One Size'],
    },
    {
      'id': 'p005',
      'brand': 'CETAPHIL',
      'name': 'Cetaphil Moisturizing Cream',
      'price': 145000.0,
      'originalPrice': 175000.0,
      'rating': 4.9,
      'reviewCount': 3456,
      'isBestSeller': true,
      'sellerId': 's004',
      'categoryId': 'c004',
      'color': Color(0xFFE3F2FD),
      'description':
          'Rich, non-greasy moisturizer for dry to very dry skin. Clinically proven to restore skin barrier.',
      'colors': [0xFFFFFFFF],
      'sizes': ['250g', '500g'],
    },
    {
      'id': 'p006',
      'brand': 'INNISFREE',
      'name': 'Innisfree Green Tea Serum',
      'price': 310000.0,
      'originalPrice': 390000.0,
      'rating': 4.7,
      'reviewCount': 987,
      'isBestSeller': false,
      'sellerId': 's005',
      'categoryId': 'c004',
      'color': Color(0xFFE8F5E9),
      'description':
          'Intensive hydrating serum with fresh Jeju green tea. Provides 72-hour moisturization.',
      'colors': [0xFF4CAF50],
      'sizes': ['50ml', '80ml'],
    },
    {
      'id': 'p007',
      'brand': 'MAC',
      'name': 'MAC Studio Fix Powder',
      'price': 425000.0,
      'originalPrice': 520000.0,
      'rating': 4.8,
      'reviewCount': 1890,
      'isBestSeller': true,
      'sellerId': 's002',
      'categoryId': 'c001',
      'color': Color(0xFFFFF8E1),
      'description':
          'Matte finish powder with SPF 15. Provides buildable, natural-looking coverage.',
      'colors': [0xFFD7A87B, 0xFFC4956A, 0xFFEDD9BD],
      'sizes': ['NW15', 'NW25', 'NW35', 'NW45'],
    },
    {
      'id': 'p008',
      'brand': 'SKINTIFIC',
      'name': 'Skintific 5X Ceramide Barrier Serum',
      'price': 199000.0,
      'originalPrice': 250000.0,
      'rating': 4.6,
      'reviewCount': 2100,
      'isBestSeller': false,
      'sellerId': 's005',
      'categoryId': 'c004',
      'color': Color(0xFFF3E5F5),
      'description':
          'Strengthens skin barrier with 5 types of ceramide. Reduces redness and sensitivity.',
      'colors': [0xFFCE93D8],
      'sizes': ['20ml', '40ml'],
    },
    {
      'id': 'p009',
      'brand': 'REVLON',
      'name': 'Revlon ColorStay Eyeliner',
      'price': 85000.0,
      'originalPrice': 115000.0,
      'rating': 4.4,
      'reviewCount': 543,
      'isBestSeller': false,
      'sellerId': 's003',
      'categoryId': 'c002',
      'color': Color(0xFFEEEEEE),
      'description':
          'Smudge-proof eyeliner with built-in sharpener. Lasts up to 24 hours.',
      'colors': [0xFF000000, 0xFF212121, 0xFF1A237E],
      'sizes': ['One Size'],
    },
    {
      'id': 'p010',
      'brand': 'THE BODY SHOP',
      'name': 'The Body Shop Himalayan Charcoal',
      'price': 275000.0,
      'originalPrice': 340000.0,
      'rating': 4.5,
      'reviewCount': 765,
      'isBestSeller': false,
      'sellerId': 's004',
      'categoryId': 'c004',
      'color': Color(0xFFECEFF1),
      'description':
          'Purifying glow mask with Himalayan charcoal and bamboo. Draws out pore-clogging impurities.',
      'colors': [0xFF607D8B],
      'sizes': ['75ml'],
    },
  ];

  static final List<Map<String, dynamic>> mockCategories = [
    {'id': 'c001', 'label': 'Makeup', 'icon': Icons.brush},
    {'id': 'c002', 'label': 'EyeLash', 'icon': Icons.remove_red_eye},
    {'id': 'c003', 'label': 'Parfume', 'icon': Icons.local_florist},
    {'id': 'c004', 'label': 'Beauty', 'icon': Icons.face},
    {'id': 'c005', 'label': 'Skincare', 'icon': Icons.spa},
    {'id': 'c006', 'label': 'Hair Care', 'icon': Icons.content_cut},
    {'id': 'c007', 'label': 'Lipstick', 'icon': Icons.color_lens},
    {'id': 'c008', 'label': 'Tools', 'icon': Icons.handyman},
  ];

  static final List<Map<String, dynamic>> mockBanners = [
    {
      'tag': 'BRAND',
      'title': 'Feminine Care',
      'subtitle': 'Lorem ipsum dolor sit amet\nconsectetur adipiscing elit.',
      'colorStart': const Color(0xFFF8BDD0),
      'colorEnd': const Color(0xFFFCE4EC),
    },
    {
      'tag': 'PROMO',
      'title': 'Summer Sale 50%',
      'subtitle': 'Up to 50% off on all skincare\nproducts this weekend.',
      'colorStart': const Color(0xFFBBDEFB),
      'colorEnd': const Color(0xFFE3F2FD),
    },
    {
      'tag': 'NEW',
      'title': 'Glow Collection',
      'subtitle': 'Discover the new season\nbeauty collection.',
      'colorStart': const Color(0xFFE1BEE7),
      'colorEnd': const Color(0xFFF3E5F5),
    },
  ];

  static final List<Map<String, dynamic>> mockStories = [
    {'label': 'Lipstick', 'color': const Color(0xFFFFCDD2)},
    {'label': 'Foundation', 'color': const Color(0xFFF8BBD0)},
    {'label': 'Serum', 'color': const Color(0xFFE1BEE7)},
    {'label': 'Eye Care', 'color': const Color(0xFFBBDEFB)},
    {'label': 'Moisturizer', 'color': const Color(0xFFB2EBF2)},
  ];

  static final List<Map<String, dynamic>> mockCartItems = [
    {
      'productId': 'p001',
      'quantity': 2,
      'color': 0xFF000000,
      'size': '10ml',
      'price': 189000.0,
    },
    {
      'productId': 'p004',
      'quantity': 1,
      'color': 0xFFE91E63,
      'size': 'One Size',
      'price': 95000.0,
    },
    {
      'productId': 'p007',
      'quantity': 1,
      'color': 0xFFD7A87B,
      'size': 'NW25',
      'price': 425000.0,
    },
  ];

  static final List<Map<String, dynamic>> mockOrders = [
    {
      'id': 'ORD-20240601',
      'date': '1 Jun 2024',
      'status': 'Delivered',
      'statusIndex': 3,
      'total': 898000.0,
      'items': ['p001', 'p004'],
      'tracking': 'JNE-123456789',
    },
    {
      'id': 'ORD-20240525',
      'date': '25 May 2024',
      'status': 'Shipped',
      'statusIndex': 2,
      'total': 475000.0,
      'items': ['p007'],
      'tracking': 'SICEPAT-987654321',
    },
    {
      'id': 'ORD-20240510',
      'date': '10 May 2024',
      'status': 'Processing',
      'statusIndex': 1,
      'total': 310000.0,
      'items': ['p006'],
      'tracking': '-',
    },
    {
      'id': 'ORD-20240501',
      'date': '1 May 2024',
      'status': 'Delivered',
      'statusIndex': 3,
      'total': 220000.0,
      'items': ['p002'],
      'tracking': 'ANTERAJA-567891234',
    },
    {
      'id': 'ORD-20240420',
      'date': '20 Apr 2024',
      'status': 'Delivered',
      'statusIndex': 3,
      'total': 145000.0,
      'items': ['p005'],
      'tracking': 'JNE-112233445',
    },
  ];

  static final List<Map<String, dynamic>> mockNotifications = [
    {
      'id': 'n001',
      'title': 'Order Shipped!',
      'body': 'Your order ORD-20240525 has been picked up by SiCepat.',
      'isRead': false,
      'time': '2m ago',
      'type': 'order',
    },
    {
      'id': 'n002',
      'title': 'Flash Sale Today!',
      'body': 'Up to 70% off on makeup products. Limited time only!',
      'isRead': false,
      'time': '1h ago',
      'type': 'promo',
    },
    {
      'id': 'n003',
      'title': 'Order Delivered',
      'body': 'Your order ORD-20240601 has been delivered successfully.',
      'isRead': true,
      'time': '2d ago',
      'type': 'order',
    },
    {
      'id': 'n004',
      'title': 'New Arrivals',
      'body': 'Check out the latest beauty products from your favourite brands.',
      'isRead': true,
      'time': '3d ago',
      'type': 'promo',
    },
    {
      'id': 'n005',
      'title': 'Review Your Purchase',
      'body': 'How was Bourjois Twist Up The Volume? Leave a review!',
      'isRead': true,
      'time': '5d ago',
      'type': 'system',
    },
    {
      'id': 'n006',
      'title': 'Points Earned',
      'body': 'You earned 89 points from your last purchase.',
      'isRead': true,
      'time': '5d ago',
      'type': 'system',
    },
    {
      'id': 'n007',
      'title': 'Weekend Deals',
      'body': 'Special weekend promo — buy 2 get 1 free on selected items.',
      'isRead': true,
      'time': '1w ago',
      'type': 'promo',
    },
    {
      'id': 'n008',
      'title': 'Profile Updated',
      'body': 'Your profile information has been updated successfully.',
      'isRead': true,
      'time': '2w ago',
      'type': 'system',
    },
  ];

  static final List<Map<String, dynamic>> mockSellers = [
    {
      'id': 's001',
      'name': 'Beauty Official Store',
      'rating': 4.9,
      'productCount': 124,
      'verified': true,
      'location': 'Jakarta',
    },
    {
      'id': 's002',
      'name': 'Glamour Beauty',
      'rating': 4.7,
      'productCount': 89,
      'verified': true,
      'location': 'Bandung',
    },
    {
      'id': 's003',
      'name': 'Pro Cosmetics',
      'rating': 4.6,
      'productCount': 56,
      'verified': false,
      'location': 'Surabaya',
    },
    {
      'id': 's004',
      'name': 'Skincare Clinic',
      'rating': 4.8,
      'productCount': 73,
      'verified': true,
      'location': 'Bali',
    },
    {
      'id': 's005',
      'name': 'K-Beauty Corner',
      'rating': 4.7,
      'productCount': 210,
      'verified': true,
      'location': 'Jakarta',
    },
  ];

  static final List<Map<String, dynamic>> mockAddresses = [
    {
      'id': 'a001',
      'label': 'Home',
      'recipient': 'Muhammad Farhan',
      'phone': '+62 812-3456-7890',
      'street': 'Jl. Sudirman No. 12, RT 01/RW 03',
      'city': 'Jakarta Selatan, DKI Jakarta 12190',
      'isDefault': true,
    },
    {
      'id': 'a002',
      'label': 'Office',
      'recipient': 'Muhammad Farhan',
      'phone': '+62 812-3456-7890',
      'street': 'Jl. HR Rasuna Said Kav. 62',
      'city': 'Jakarta Selatan, DKI Jakarta 12940',
      'isDefault': false,
    },
  ];

  static final List<Map<String, dynamic>> mockPaymentMethods = [
    {
      'id': 'pm001',
      'label': 'BCA Virtual Account',
      'type': 'bank',
      'number': '8277-XXXX-XXXX',
      'isDefault': true,
    },
    {
      'id': 'pm002',
      'label': 'GoPay',
      'type': 'ewallet',
      'number': '+62 812-3456-XXXX',
      'isDefault': false,
    },
    {
      'id': 'pm003',
      'label': 'OVO',
      'type': 'ewallet',
      'number': '+62 812-3456-XXXX',
      'isDefault': false,
    },
  ];

  static final List<Map<String, dynamic>> mockReviews = [
    {
      'id': 'r001',
      'user': 'Sarah K.',
      'rating': 5.0,
      'comment':
          'Amazing product! The formula is so smooth and the color payoff is incredible. Highly recommend!',
      'date': '15 May 2024',
      'productId': 'p001',
    },
    {
      'id': 'r002',
      'user': 'Dewi R.',
      'rating': 4.5,
      'comment':
          'Good quality. The packaging is elegant and it lasts all day on my skin.',
      'date': '10 May 2024',
      'productId': 'p001',
    },
    {
      'id': 'r003',
      'user': 'Anita S.',
      'rating': 4.0,
      'comment':
          'Pretty good but slightly expensive. The texture is lightweight which I love.',
      'date': '2 May 2024',
      'productId': 'p002',
    },
    {
      'id': 'r004',
      'user': 'Putri M.',
      'rating': 5.0,
      'comment':
          'This is my holy grail serum! My skin feels so hydrated and glowy.',
      'date': '28 Apr 2024',
      'productId': 'p002',
    },
  ];

  static final List<Map<String, dynamic>> mockOnboardingSlides = [
    {
      'icon': Icons.local_mall,
      'color': const Color(0xFFFFCDD2),
      'title': 'Discover Beauty Products',
      'subtitle':
          'Browse thousands of beauty & skincare products from top brands worldwide.',
    },
    {
      'icon': Icons.local_shipping_outlined,
      'color': const Color(0xFFBBDEFB),
      'title': 'Fast & Secure Delivery',
      'subtitle':
          'Get your orders delivered to your doorstep safely and on time.',
    },
    {
      'icon': Icons.star_outline,
      'color': const Color(0xFFE1BEE7),
      'title': 'Trusted by Millions',
      'subtitle':
          'Join over 2 million happy customers who trust Parela for their beauty needs.',
    },
  ];
}
