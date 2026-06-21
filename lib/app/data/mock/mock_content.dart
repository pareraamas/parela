import 'package:flutter/material.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/flash_sale_model.dart';
import 'package:parela/app/data/models/notification_model.dart';
import 'package:parela/app/data/models/order_item_model.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/data/models/user_model.dart';

class MockContent {
  MockContent._();

  // ── User ──────────────────────────────────────────────────────────────────

  static const mockUser = UserModel(
    id: 'u001',
    name: 'Muhammad Farhan',
    email: 'farhan@email.com',
    phone: '+62 812-3456-7890',
    address: 'Jl. Sudirman No. 12, Jakarta Selatan',
    verified: true,
  );

  // ── Sellers ───────────────────────────────────────────────────────────────
  // s001–s002: mall | s003: official | s004–s005: regular

  static final List<SellerModel> mockSellers = [
    SellerModel.fromMap({
      'id': 's001',
      'name': 'ESQA Mall',
      'rating': 4.9,
      'productCount': 312,
      'verified': true,
      'isOfficial': true,
      'location': 'Jakarta Selatan',
      'avatarUrl': 'assets/public/sellers/esqa-mall/avatar.webp',
      'description': 'ESQA adalah brand kosmetik lokal premium yang menghadirkan produk makeup berkualitas tinggi dengan formula vegan dan cruelty-free.',
      'followerCount': 128400,
      'soldCount': 245600,
      'responseRate': '99%',
      'responseTime': '< 1 jam',
      'badges': ['mall', 'top_seller', 'fast_shipping'],
    }),
    SellerModel.fromMap({
      'id': 's002',
      'name': 'IOK Mall',
      'rating': 4.8,
      'productCount': 187,
      'verified': true,
      'isOfficial': true,
      'location': 'Bandung',
      'avatarUrl': 'assets/public/sellers/iok-mall/avatar.webp',
      'description': 'IOK adalah brand fashion dan pakaian olahraga lokal dengan teknologi kain inovatif — anti-UV, penyerap keringat, dan nyaman sepanjang hari.',
      'followerCount': 94200,
      'soldCount': 178300,
      'responseRate': '98%',
      'responseTime': '< 2 jam',
      'badges': ['mall', 'top_seller', 'fast_shipping'],
    }),
    SellerModel.fromMap({
      'id': 's003',
      'name': 'FOC Official',
      'rating': 4.9,
      'productCount': 54,
      'verified': true,
      'isOfficial': true,
      'location': 'Jakarta Pusat',
      'avatarUrl': 'assets/public/sellers/foc-offisial/avatar.webp',
      'description': 'FOC (Fragrance of Choice) adalah toko resmi parfume premium pilihan. Semua produk dijamin 100% original langsung dari brand.',
      'followerCount': 42800,
      'soldCount': 61900,
      'responseRate': '97%',
      'responseTime': '< 3 jam',
      'badges': ['official', 'top_seller'],
    }),
    SellerModel.fromMap({
      'id': 's004',
      'name': 'Toko Serba Ada',
      'rating': 4.5,
      'productCount': 403,
      'verified': true,
      'location': 'Surabaya',
      'description': 'Toko serba ada dengan berbagai kebutuhan sehari-hari. Produk lengkap, harga bersahabat, pengiriman cepat.',
      'followerCount': 18700,
      'soldCount': 92400,
      'responseRate': '95%',
      'responseTime': '< 4 jam',
      'badges': ['fast_shipping'],
    }),
    SellerModel.fromMap({
      'id': 's005',
      'name': 'Warung Digital',
      'rating': 4.4,
      'productCount': 238,
      'verified': false,
      'location': 'Yogyakarta',
      'description': 'Warung Digital hadir menyediakan berbagai kebutuhan produk lifestyle, gadget, dan fashion dengan harga kompetitif.',
      'followerCount': 9300,
      'soldCount': 47200,
      'responseRate': '92%',
      'responseTime': '< 6 jam',
      'badges': [],
    }),
    SellerModel.fromMap({
      'id': 's006',
      'name': 'Morris Official',
      'rating': 4.8,
      'productCount': 45,
      'verified': true,
      'isOfficial': true,
      'location': 'Jakarta Utara',
      'description': 'Morris adalah brand parfum dan fragrance lokal Indonesia dengan kualitas premium. Menghadirkan aroma tahan lama dengan harga yang terjangkau.',
      'followerCount': 31200,
      'soldCount': 54700,
      'responseRate': '98%',
      'responseTime': '< 2 jam',
      'badges': ['official', 'fast_shipping'],
    }),
    SellerModel.fromMap({
      'id': 's007',
      'name': 'WSKEN Store',
      'rating': 4.6,
      'productCount': 127,
      'verified': true,
      'location': 'Semarang',
      'description': 'WSKEN Store menyediakan berbagai aksesoris smartphone premium. Spesialis tempered glass, case, dan aksesoris berkualitas dengan harga kompetitif.',
      'followerCount': 12400,
      'soldCount': 38900,
      'responseRate': '95%',
      'responseTime': '< 4 jam',
      'badges': ['fast_shipping'],
    }),
  ];

  // ── Categories ────────────────────────────────────────────────────────────

  static final List<CategoryModel> mockCategories = [
    const CategoryModel(id: 'c001', label: 'Makeup',    icon: Icons.brush,         color: Color(0xFFFCE4EC), imageUrl: 'assets/public/category/makeup.png'),
    const CategoryModel(id: 'c002', label: 'Skincare',  icon: Icons.spa,            color: Color(0xFFE3F2FD), imageUrl: 'assets/public/category/skincare.png'),
    const CategoryModel(id: 'c003', label: 'Parfume',   icon: Icons.local_florist,  color: Color(0xFFEDE7F6), imageUrl: 'assets/public/category/parfume.png'),
    const CategoryModel(id: 'c004', label: 'Lipstick',  icon: Icons.color_lens,     color: Color(0xFFFFEBEE), imageUrl: 'assets/public/category/lipstick.png'),
    const CategoryModel(id: 'c005', label: 'Hair Care', icon: Icons.content_cut,    color: Color(0xFFFFF8E1), imageUrl: 'assets/public/category/hair_care.png'),
    const CategoryModel(id: 'c006', label: 'Fashion',   icon: Icons.checkroom,      color: Color(0xFFE8EAF6), imageUrl: 'assets/public/category/fashion.png'),
    const CategoryModel(id: 'c007', label: 'Sport',     icon: Icons.sports,         color: Color(0xFFE8F5E9), imageUrl: 'assets/public/category/sport.png'),
    const CategoryModel(id: 'c008', label: 'Aksesoris', icon: Icons.handyman,       color: Color(0xFFFFF3E0), imageUrl: 'assets/public/category/aksesoris.png'),
  ];

  // ── Products ──────────────────────────────────────────────────────────────
  // ESQA Mall (s001): p001–p003
  // FOC Official (s003): p004
  // IOK Mall (s002): p005–p008
  // Regular (s004–s005): p009–p016

  static final List<ProductModel> mockProducts = [
    // ── ESQA Mall ─────────────────────────────────────────────────────────
    const ProductModel(
      id: 'p001',
      brand: 'ESQA',
      name: 'ESQA Glazed HD Powder',
      price: 189000,
      originalPrice: 239000,
      rating: 4.9,
      reviewCount: 3841,
      isBestSeller: true,
      sellerId: 's001',
      categoryId: 'c001',
      colorHex: '#FCE4EC',
      description:
          'Bedak tabur ultra-fine dengan teknologi HD yang memberikan tampilan kulit halus dan cerah. Formula vegan & cruelty-free, cocok untuk semua jenis kulit.',
      colors: [0xFFEDD9BD, 0xFFD7A87B, 0xFFC4956A],
      sizes: ['Light', 'Natural', 'Tan'],
      soldCount: 38410,
      imageUrls: [
        'assets/public/products/esqa-bedak/1.webp',
        'assets/public/products/esqa-bedak/2.webp',
        'assets/public/products/esqa-bedak/3.webp',
      ],
    ),
    const ProductModel(
      id: 'p002',
      brand: 'ESQA',
      name: 'ESQA x Tasya Farasya Eyeshadow Palette',
      price: 279000,
      originalPrice: 349000,
      rating: 4.8,
      reviewCount: 2156,
      isBestSeller: true,
      sellerId: 's001',
      categoryId: 'c001',
      colorHex: '#F8D7E5',
      description:
          'Palette kolaborasi eksklusif ESQA x Tasya Farasya. 12 warna eyeshadow dengan pigmentasi tinggi, dari nude hingga bold. Formula vegan, tahan lama seharian.',
      colors: [0xFFB71C1C, 0xFF6D4C41, 0xFF4A148C, 0xFF880E4F],
      sizes: ['One Size'],
      soldCount: 21560,
      imageUrls: [
        'assets/public/products/esqa-eyeshadow/1.webp',
        'assets/public/products/esqa-eyeshadow/2.webp',
        'assets/public/products/esqa-eyeshadow/3.webp',
      ],
    ),
    const ProductModel(
      id: 'p003',
      brand: 'ESQA',
      name: 'ESQA Lip Matte Cream',
      price: 129000,
      originalPrice: 169000,
      rating: 4.8,
      reviewCount: 4722,
      isBestSeller: true,
      sellerId: 's001',
      categoryId: 'c004',
      colorHex: '#FFCDD2',
      description:
          'Lip matte cream dengan formula ringan dan nyaman di bibir. Warna intens, transfer-proof, dan tahan hingga 8 jam. Tidak membuat bibir kering.',
      colors: [0xFFE91E63, 0xFFAD1457, 0xFFBF360C, 0xFF880E4F, 0xFFB71C1C],
      sizes: ['Chili Red', 'Rose Nude', 'Berry', 'Sienna', 'Coral'],
      soldCount: 47220,
      imageUrls: [
        'assets/public/products/esqa-lipstik/1.webp',
        'assets/public/products/esqa-lipstik/2.webp',
        'assets/public/products/esqa-lipstik/3.webp',
      ],
    ),

    // ── FOC Official ──────────────────────────────────────────────────────
    const ProductModel(
      id: 'p004',
      brand: 'FOC',
      name: 'FOC Meteore Eau de Parfum',
      price: 349000,
      originalPrice: 429000,
      rating: 4.9,
      reviewCount: 1834,
      isBestSeller: true,
      sellerId: 's003',
      categoryId: 'c003',
      colorHex: '#E8EAF6',
      description:
          'Parfume premium dengan aroma woody-aromatic yang elegan. Top note: bergamot & lemon. Heart: vetiver & iris. Base: cedarwood & musk. Tahan 8–12 jam.',
      colors: [0xFF5C6BC0, 0xFF7986CB],
      sizes: ['30ml', '50ml', '100ml'],
      soldCount: 18340,
      imageUrls: [
        'assets/public/products/foc-parfume-meteore/1.webp',
        'assets/public/products/foc-parfume-meteore/2.webp',
        'assets/public/products/foc-parfume-meteore/3.webp',
      ],
    ),

    // ── IOK Mall ──────────────────────────────────────────────────────────
    const ProductModel(
      id: 'p005',
      brand: 'IOK',
      name: 'IOK Celana Olahraga Slim Fit',
      price: 159000,
      originalPrice: 219000,
      rating: 4.7,
      reviewCount: 2891,
      isBestSeller: true,
      sellerId: 's002',
      categoryId: 'c007',
      colorHex: '#E8F5E9',
      description:
          'Celana olahraga slim fit dengan teknologi kain 4-way stretch dan moisture-wicking. Nyaman untuk gym, jogging, atau aktivitas outdoor. Anti-bau dan quick dry.',
      colors: [0xFF212121, 0xFF1A237E, 0xFF1B5E20, 0xFF880E4F],
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      soldCount: 28910,
      imageUrls: [
        'assets/public/products/iok-celana-olahraga/1.webp',
        'assets/public/products/iok-celana-olahraga/2.webp',
      ],
    ),
    const ProductModel(
      id: 'p006',
      brand: 'IOK',
      name: 'IOK Jaket Anti UV UPF50+',
      price: 249000,
      originalPrice: 329000,
      rating: 4.8,
      reviewCount: 1647,
      isBestSeller: true,
      sellerId: 's002',
      categoryId: 'c006',
      colorHex: '#E3F2FD',
      description:
          'Jaket anti-UV dengan proteksi UPF50+ yang menghalangi 98% sinar UV. Bahan ultra-ringan, breathable, dan bisa dilipat masuk saku. Ideal untuk aktivitas outdoor.',
      colors: [0xFF0D47A1, 0xFF1B5E20, 0xFF212121, 0xFFB71C1C],
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      soldCount: 16470,
      imageUrls: [
        'assets/public/products/iok-jaket-antiuv/1.webp',
        'assets/public/products/iok-jaket-antiuv/2.webp',
      ],
    ),
    const ProductModel(
      id: 'p007',
      brand: 'IOK',
      name: 'IOK Shino Pants Casual',
      price: 199000,
      originalPrice: 269000,
      rating: 4.7,
      reviewCount: 1123,
      isBestSeller: false,
      sellerId: 's002',
      categoryId: 'c006',
      colorHex: '#FFF8E1',
      description:
          'Celana shino casual dengan bahan premium lembut dan adem. Potongan slim tappered yang modern, cocok untuk aktivitas sehari-hari maupun semi-formal.',
      colors: [0xFF5D4037, 0xFF37474F, 0xFF1A237E, 0xFFBF360C],
      sizes: ['28', '30', '32', '34', '36'],
      soldCount: 11230,
      imageUrls: [
        'assets/public/products/iok-shino-pants/1.webp',
        'assets/public/products/iok-shino-pants/2.webp',
      ],
    ),
    const ProductModel(
      id: 'p008',
      brand: 'IOK',
      name: 'IOK Shino Shorts',
      price: 149000,
      originalPrice: 199000,
      rating: 4.6,
      reviewCount: 876,
      isBestSeller: false,
      sellerId: 's002',
      categoryId: 'c006',
      colorHex: '#ECEFF1',
      description:
          'Celana pendek shino dengan bahan ringan dan adem. Desain clean minimalis dengan dua saku samping dan satu saku belakang. Cocok untuk casual everyday.',
      colors: [0xFF37474F, 0xFF4E342E, 0xFF212121, 0xFF1A237E],
      sizes: ['28', '30', '32', '34', '36'],
      soldCount: 8760,
      imageUrls: [
        'assets/public/products/iok-shino-pendek/1.webp',
        'assets/public/products/iok-shino-pendek/2.webp',
      ],
    ),

    // ── Regular Sellers (random products) ────────────────────────────────
    const ProductModel(
      id: 'p009',
      brand: 'SmartFit',
      name: 'Smartwatch Pro Series X1',
      price: 399000,
      originalPrice: 549000,
      rating: 4.3,
      reviewCount: 1204,
      isBestSeller: false,
      sellerId: 's004',
      categoryId: 'c008',
      colorHex: '#CFD8DC',
      description:
          'Smartwatch dengan layar AMOLED 1.8 inci, monitor detak jantung, SpO2, 100+ mode olahraga, notifikasi pintar, dan baterai tahan 7 hari. Water-resistant IP68.',
      colors: [0xFF212121, 0xFFB0BEC5, 0xFFB71C1C],
      sizes: ['One Size'],
      soldCount: 12040,
      imageUrls: [
        'assets/public/products/random/smartwatch.webp',
      ],
    ),
    const ProductModel(
      id: 'p010',
      brand: 'Gatsby',
      name: 'Gatsby Water Gloss Pomade',
      price: 42000,
      originalPrice: 55000,
      rating: 4.5,
      reviewCount: 3287,
      isBestSeller: true,
      sellerId: 's004',
      categoryId: 'c005',
      colorHex: '#E8EAF6',
      description:
          'Pomade water-based dengan hold kuat dan shine tinggi. Mudah diaplikasikan, mudah dibersihkan dengan air. Cocok untuk gaya rambut sleek back dan pompadour.',
      colors: [0xFF1A237E],
      sizes: ['75g', '150g'],
      soldCount: 32870,
      imageUrls: [
        'assets/public/products/random/pomade.webp',
      ],
    ),
    const ProductModel(
      id: 'p011',
      brand: 'Wardah',
      name: 'Wardah Hydrating Facial Wash',
      price: 32000,
      originalPrice: 42000,
      rating: 4.6,
      reviewCount: 5412,
      isBestSeller: true,
      sellerId: 's005',
      categoryId: 'c002',
      colorHex: '#E8F5E9',
      description:
          'Sabun muka dengan formula hydrating yang membersihkan kotoran dan minyak tanpa membuat kulit terasa kering. Mengandung aloe vera dan vitamin E. Untuk kulit normal dan kombinasi.',
      colors: [0xFF43A047],
      sizes: ['60ml', '100ml'],
      soldCount: 54120,
      imageUrls: [
        'assets/public/products/random/fasial-wash.webp',
      ],
    ),
    const ProductModel(
      id: 'p012',
      brand: 'Dettol',
      name: 'Dettol Sabun Antibakteri Original',
      price: 18500,
      originalPrice: 24000,
      rating: 4.7,
      reviewCount: 8934,
      isBestSeller: true,
      sellerId: 's005',
      categoryId: 'c002',
      colorHex: '#E8F5E9',
      description:
          'Sabun antibakteri Dettol melindungi dari 100 jenis kuman dan bakteri. Formula lembut dengan moisturizer yang menjaga kelembapan kulit. Cocok untuk seluruh keluarga.',
      colors: [0xFF2E7D32],
      sizes: ['90g', '110g'],
      soldCount: 89340,
      imageUrls: [
        'assets/public/products/random/sabun-detol.webp',
      ],
    ),
    const ProductModel(
      id: 'p013',
      brand: 'Kazbrella',
      name: 'Payung Lipat Anti UV UPF60+',
      price: 89000,
      originalPrice: 129000,
      rating: 4.5,
      reviewCount: 2156,
      isBestSeller: false,
      sellerId: 's004',
      categoryId: 'c008',
      colorHex: '#FFF9C4',
      description:
          'Payung lipat dengan proteksi UPF60+ yang efektif menghalau sinar UV dan panas matahari. Bahan anti-air, ringan hanya 280g, dan bisa terkembang otomatis.',
      colors: [0xFF0D47A1, 0xFFB71C1C, 0xFF1B5E20, 0xFF212121, 0xFF880E4F],
      sizes: ['One Size'],
      soldCount: 21560,
      imageUrls: [
        'assets/public/products/random/payung-anti-uv.webp',
      ],
    ),
    const ProductModel(
      id: 'p014',
      brand: 'Overco',
      name: 'Kaos Oversize Premium Cotton',
      price: 75000,
      originalPrice: 115000,
      rating: 4.4,
      reviewCount: 1893,
      isBestSeller: false,
      sellerId: 's005',
      categoryId: 'c006',
      colorHex: '#ECEFF1',
      description:
          'Kaos oversize dengan bahan cotton combed 30s premium yang lembut dan adem. Potongan boxy yang stylish, tersedia dalam berbagai warna. Tidak mudah melar setelah dicuci.',
      colors: [0xFFFFFFFF, 0xFF212121, 0xFFB0BEC5, 0xFF795548, 0xFFBF360C],
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      soldCount: 18930,
      imageUrls: [
        'assets/public/products/random/kaos-oversize.webp',
      ],
    ),
    const ProductModel(
      id: 'p015',
      brand: 'HydroFit',
      name: 'Botol Minum Tritan 750ml',
      price: 65000,
      originalPrice: 89000,
      rating: 4.6,
      reviewCount: 3102,
      isBestSeller: false,
      sellerId: 's004',
      categoryId: 'c008',
      colorHex: '#E3F2FD',
      description:
          'Botol minum anti-bocor dari bahan Tritan BPA-free yang aman dan tahan lama. Kapasitas 750ml dengan skala ukuran, cocok untuk olahraga maupun aktivitas harian.',
      colors: [0xFF0D47A1, 0xFF1B5E20, 0xFFB71C1C, 0xFF880E4F, 0xFFFF6F00],
      sizes: ['750ml'],
      soldCount: 31020,
      imageUrls: [
        'assets/public/products/random/botol-minum.webp',
      ],
    ),
    const ProductModel(
      id: 'p016',
      brand: 'MirrorMe',
      name: 'Cermin Lipat Dompet LED',
      price: 35000,
      originalPrice: 55000,
      rating: 4.3,
      reviewCount: 1247,
      isBestSeller: false,
      sellerId: 's005',
      categoryId: 'c008',
      colorHex: '#FCE4EC',
      description:
          'Cermin lipat kompak ukuran kartu dengan lampu LED terang. Bisa masuk dompet atau tas, ideal untuk touch up makeup di mana saja. Material aluminium ringan dan tahan karat.',
      colors: [0xFFB0BEC5, 0xFFFFD54F, 0xFFE91E63],
      sizes: ['One Size'],
      soldCount: 12470,
      imageUrls: [
        'assets/public/products/random/cermin-lipat.webp',
      ],
    ),

    // ── Flash Sale Products ───────────────────────────────────────────────
    const ProductModel(
      id: 'fs001',
      brand: 'G-MAX',
      name: 'G-MAX Kopi Ginseng 1 Box 10 Sachet',
      price: 99000,
      originalPrice: 185000,
      rating: 4.7,
      reviewCount: 2341,
      isBestSeller: true,
      sellerId: 's004',
      categoryId: 'c008',
      colorHex: '#FFF8E1',
      description:
          'Kopi ginseng premium G-MAX dengan formula khusus yang menggabungkan kenikmatan kopi pilihan dan manfaat ginseng alami. Memberikan energi ekstra, meningkatkan stamina, dan menjaga vitalitas pria. Tanpa efek samping, cocok dikonsumsi setiap pagi. 1 box isi 10 sachet.',
      colors: [0xFF795548, 0xFF4E342E],
      sizes: ['1 Box (10 Sachet)', '2 Box (20 Sachet)'],
      soldCount: 23410,
      discountPercent: 46,
      imageUrls: [
        'assets/public/flashsale/G-MAX Kopi Kekuatan Alami dari Ginseng Asli ( 1 BOX Isi 10 Sachet ).webp',
      ],
    ),
    const ProductModel(
      id: 'fs002',
      brand: 'METOO',
      name: 'METOO MW-3 Whitening Toothpaste 3x100g',
      price: 65000,
      originalPrice: 120000,
      rating: 4.6,
      reviewCount: 1876,
      isBestSeller: true,
      sellerId: 's005',
      categoryId: 'c002',
      colorHex: '#E3F2FD',
      description:
          'Pasta gigi whitening MW-3 dari METOO dengan formula advanced yang memutihkan gigi secara bertahap dan aman. Mengandung charcoal aktif dan mint extract untuk napas segar sepanjang hari. Paket hemat 3 tube @100g.',
      colors: [0xFFE3F2FD, 0xFF90CAF9],
      sizes: ['3x100g'],
      soldCount: 18760,
      discountPercent: 46,
      imageUrls: [
        'assets/public/flashsale/METOO MW-3 Advanced whitening Toothpaste 3*100g - Gigi Putih.webp',
      ],
    ),
    const ProductModel(
      id: 'fs003',
      brand: 'MORRIS',
      name: 'Morris White Edition Eau de Parfum 100ml',
      price: 219000,
      originalPrice: 349000,
      rating: 4.8,
      reviewCount: 1432,
      isBestSeller: true,
      sellerId: 's006',
      categoryId: 'c003',
      colorHex: '#EDE7F6',
      description:
          'Morris White Edition EDP hadir dengan aroma fresh-woody yang elegan dan maskulin. Top note: bergamot & white tea. Heart: iris & cedarwood. Base: vanilla & white musk. Tahan 6–8 jam, cocok untuk pria aktif modern.',
      colors: [0xFFEDE7F6, 0xFFD1C4E9],
      sizes: ['100ml'],
      soldCount: 14320,
      discountPercent: 37,
      imageUrls: [
        'assets/public/flashsale/Morris Eau De Parfum White Edition 100ml - Parfum Pria.webp',
      ],
    ),
    const ProductModel(
      id: 'fs004',
      brand: 'WSKEN',
      name: 'WSKEN Tempered Glass Auto Align iPhone',
      price: 35000,
      originalPrice: 79000,
      rating: 4.5,
      reviewCount: 3102,
      isBestSeller: false,
      sellerId: 's007',
      categoryId: 'c008',
      colorHex: '#E8F5E9',
      description:
          'Tempered glass premium WSKEN dengan teknologi Auto Align untuk pemasangan yang mudah dan presisi tanpa gelembung. Kejernihan HD 99.9%, perlindungan gores 9H, anti sidik jari. Tersedia untuk berbagai model iPhone.',
      colors: [0xFFE8F5E9],
      sizes: ['iPhone 14/15', 'iPhone 14/15 Pro', 'iPhone 14/15 Plus', 'iPhone 14/15 Pro Max'],
      soldCount: 31020,
      discountPercent: 56,
      imageUrls: [
        'assets/public/flashsale/WSKEN Tempered Glass Clear Privacy Glossy Auto Align Tech Anti Gores Screen Protector Full for iPhone.webp',
      ],
    ),
  ];

  // ── Banners ───────────────────────────────────────────────────────────────

  static final List<BannerModel> mockBanners = [
    const BannerModel(
      tag: 'ESQA MALL',
      title: 'Beauty Vegan Series',
      subtitle: 'Diskon hingga 30% produk\nESQA pilihan minggu ini.',
      colorStart: Color(0xFFF8BDD0),
      colorEnd: Color(0xFFFCE4EC),
      imageUrl: 'assets/public/banners/Gemini_Generated_Image_1.webp',
    ),
    const BannerModel(
      tag: 'FLASH SALE',
      title: 'IOK Sport Day',
      subtitle: 'Koleksi olahraga & fashion\nIOK diskon up to 40%.',
      colorStart: Color(0xFFBBDEFB),
      colorEnd: Color(0xFFE3F2FD),
      imageUrl: 'assets/public/banners/Gemini_Generated_Image_2.webp',
    ),
    const BannerModel(
      tag: 'EXCLUSIVE',
      title: 'FOC Parfume Fest',
      subtitle: 'Meteore EDP gratis\npouch eksklusif senilai 75rb.',
      colorStart: Color(0xFFD1C4E9),
      colorEnd: Color(0xFFEDE7F6),
      imageUrl: 'assets/public/banners/Gemini_Generated_Image_3.webp',
    ),
  ];

  // ── Video Feed ────────────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> mockVideoFeed = [
    {
      'username': '@esqa.cosmetics',
      'sellerId': 's001',
      'avatarUrl': 'assets/public/sellers/esqa-mall/avatar.webp',
      'description':
          'Tutorial pakai ESQA Lip Matte Cream — intens, transfer-proof, tahan 8 jam! 💄 #esqa #lipsticktutorial #makeupnatural #fyp',
      'productId': 'p003',
      'product': 'ESQA Lip Matte Cream',
      'likes': '124.2K',
      'comments': '1.2K',
      'shares': '892',
      'music': 'Original Sound - ESQA Cosmetics',
      'videoUrl': 'assets/public/videos/esqa-lipstik-story/video.mp4',
      'colorTop': Color(0xFFFFCDD2),
      'colorBottom': Color(0xFFF06292),
    },
    {
      'username': '@iok.indonesia',
      'sellerId': 's002',
      'avatarUrl': 'assets/public/sellers/iok-mall/avatar.webp',
      'description':
          'IOK Jaket Anti UV UPF50+! Ultra ringan, proteksi 98% sinar UV, bisa dilipat masuk saku 🧥 #iok #jaket #outdoor #antiuv',
      'productId': 'p006',
      'product': 'IOK Jaket Anti UV UPF50+',
      'likes': '45.6K',
      'comments': '534',
      'shares': '678',
      'music': 'As It Was - Harry Styles',
      'videoUrl': 'assets/public/videos/iok-jaket-story/video.mp4',
      'colorTop': Color(0xFFDCEDC8),
      'colorBottom': Color(0xFF33691E),
    },
    {
      'username': '@foc.official',
      'sellerId': 's003',
      'avatarUrl': 'assets/public/sellers/foc-offisial/avatar.webp',
      'description':
          'FOC Meteore EDP — aroma woody-aromatic premium, tahan 8–12 jam! 💫 #foc #parfume #meteore #woody',
      'productId': 'p004',
      'product': 'FOC Meteore Eau de Parfum',
      'likes': '67.3K',
      'comments': '912',
      'shares': '445',
      'music': 'Stay - Justin Bieber',
      'videoUrl': 'assets/public/videos/foc-parfume-story/video.mp4',
      'colorTop': Color(0xFFD1C4E9),
      'colorBottom': Color(0xFF311B92),
    },
    {
      'username': '@iok.indonesia',
      'sellerId': 's002',
      'avatarUrl': 'assets/public/sellers/iok-mall/avatar.webp',
      'description':
          'IOK Celana Olahraga Slim Fit — 4-way stretch, moisture-wicking, anti-bau! 🏃 #iok #activewear #gym #olahraga',
      'productId': 'p005',
      'product': 'IOK Celana Olahraga Slim Fit',
      'likes': '78.4K',
      'comments': '1.3K',
      'shares': '987',
      'music': 'Flowers - Miley Cyrus',
      'videoUrl': 'assets/public/videos/iok-celana-story/video.mp4',
      'colorTop': Color(0xFFBBDEFB),
      'colorBottom': Color(0xFF1565C0),
    },
    {
      'username': '@esqa.cosmetics',
      'sellerId': 's001',
      'avatarUrl': 'assets/public/sellers/esqa-mall/avatar.webp',
      'description':
          'ESQA x Tasya Farasya Eyeshadow Palette — 12 warna pigmentasi tinggi, vegan & cruelty-free 🎨 #esqa #tasya #eyeshadow',
      'productId': 'p002',
      'product': 'ESQA x Tasya Farasya Eyeshadow',
      'likes': '89.5K',
      'comments': '756',
      'shares': '1.1K',
      'music': 'Chill Vibes - lofi mix',
      'videoUrl': 'assets/public/videos/esqa-eyeshadow-story/video.mp4',
      'colorTop': Color(0xFFF8BBD0),
      'colorBottom': Color(0xFF4A148C),
    },
    {
      'username': '@iok.indonesia',
      'sellerId': 's002',
      'avatarUrl': 'assets/public/sellers/iok-mall/avatar.webp',
      'description':
          'IOK Shino Shorts — bahan ringan, desain clean minimalis, cocok buat casual everyday ✌️ #iok #shino #casualwear #fashion',
      'productId': 'p008',
      'product': 'IOK Shino Shorts',
      'likes': '33.2K',
      'comments': '421',
      'shares': '312',
      'music': 'Levitating - Dua Lipa',
      'videoUrl': 'assets/public/videos/iok-shino-pendek-story/video.mp4',
      'colorTop': Color(0xFFCFD8DC),
      'colorBottom': Color(0xFF37474F),
    },
  ];

  // ── Stories ───────────────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> mockStories = [
    {
      'label': 'ESQA Lip',
      'color': Color(0xFFFFCDD2),
      'sellerId': 's001',
      'avatarUrl': 'assets/public/sellers/esqa-mall/avatar.webp',
      'videoUrl': 'assets/public/videos/esqa-lipstik-story/video.mp4',
    },
    {
      'label': 'ESQA Eyes',
      'color': Color(0xFFF8BBD0),
      'sellerId': 's001',
      'avatarUrl': 'assets/public/sellers/esqa-mall/avatar.webp',
      'videoUrl': 'assets/public/videos/esqa-eyeshadow-story/video.mp4',
    },
    {
      'label': 'FOC Meteore',
      'color': Color(0xFFD1C4E9),
      'sellerId': 's003',
      'avatarUrl': 'assets/public/sellers/foc-offisial/avatar.webp',
      'videoUrl': 'assets/public/videos/foc-parfume-story/video.mp4',
    },
    {
      'label': 'IOK Jaket',
      'color': Color(0xFFBBDEFB),
      'sellerId': 's002',
      'avatarUrl': 'assets/public/sellers/iok-mall/avatar.webp',
      'videoUrl': 'assets/public/videos/iok-jaket-story/video.mp4',
    },
    {
      'label': 'IOK Sport',
      'color': Color(0xFFB2EBF2),
      'sellerId': 's002',
      'avatarUrl': 'assets/public/sellers/iok-mall/avatar.webp',
      'videoUrl': 'assets/public/videos/iok-celana-story/video.mp4',
    },
    {
      'label': 'IOK Shino',
      'color': Color(0xFFDCEDC8),
      'sellerId': 's002',
      'avatarUrl': 'assets/public/sellers/iok-mall/avatar.webp',
      'videoUrl': 'assets/public/videos/iok-shino-pendek-story/video.mp4',
    },
  ];

  // ── Cart ──────────────────────────────────────────────────────────────────

  static final List<CartItemModel> mockCartItems = [
    CartItemModel(productId: 'p001', quantity: 1, color: 0xFFEDD9BD, size: 'Natural', price: 189000),
    CartItemModel(productId: 'p003', quantity: 2, color: 0xFFE91E63, size: 'Chili Red', price: 129000),
    CartItemModel(productId: 'p005', quantity: 1, color: 0xFF212121, size: 'L', price: 159000),
  ];

  // ── Orders ────────────────────────────────────────────────────────────────

  static final List<OrderModel> mockOrders = [
    OrderModel(
      id: 'ORD-20240618',
      date: '18 Jun 2024',
      status: 'shipped',
      statusIndex: 2,
      total: 537000,
      tracking: 'JNE-998877665',
      items: [
        const OrderItemModel(productId: 'p004', productName: 'FOC Meteore EDP', variant: '50ml', quantity: 1, price: 349000),
        const OrderItemModel(productId: 'p003', productName: 'ESQA Lip Matte Cream', variant: 'Chili Red', quantity: 1, price: 129000),
      ],
    ),
    OrderModel(
      id: 'ORD-20240610',
      date: '10 Jun 2024',
      status: 'delivered',
      statusIndex: 3,
      total: 408000,
      tracking: 'SICEPAT-112233444',
      items: [
        const OrderItemModel(productId: 'p006', productName: 'IOK Jaket Anti UV UPF50+', variant: 'Navy / L', quantity: 1, price: 249000),
        const OrderItemModel(productId: 'p010', productName: 'Gatsby Water Gloss Pomade', variant: '75g', quantity: 2, price: 42000),
      ],
    ),
    OrderModel(
      id: 'ORD-20240601',
      date: '1 Jun 2024',
      status: 'delivered',
      statusIndex: 3,
      total: 468000,
      tracking: 'JNE-123456789',
      items: [
        const OrderItemModel(productId: 'p002', productName: 'ESQA x Tasya Eyeshadow Palette', variant: 'One Size', quantity: 1, price: 279000),
        const OrderItemModel(productId: 'p011', productName: 'Wardah Hydrating Facial Wash', variant: '100ml', quantity: 2, price: 32000),
      ],
    ),
    OrderModel(
      id: 'ORD-20240520',
      date: '20 Mei 2024',
      status: 'delivered',
      statusIndex: 3,
      total: 318000,
      tracking: 'ANTERAJA-567891234',
      items: [
        const OrderItemModel(productId: 'p005', productName: 'IOK Celana Olahraga Slim Fit', variant: 'Hitam / M', quantity: 1, price: 159000),
        const OrderItemModel(productId: 'p013', productName: 'Payung Lipat Anti UV UPF60+', variant: 'Navy', quantity: 1, price: 89000),
      ],
    ),
    OrderModel(
      id: 'ORD-20240510',
      date: '10 Mei 2024',
      status: 'processing',
      statusIndex: 1,
      total: 189000,
      tracking: '-',
      items: [
        const OrderItemModel(productId: 'p001', productName: 'ESQA Glazed HD Powder', variant: 'Natural', quantity: 1, price: 189000),
      ],
    ),
    OrderModel(
      id: 'ORD-20240425',
      date: '25 Apr 2024',
      status: 'delivered',
      statusIndex: 3,
      total: 100500,
      tracking: 'JNE-445566778',
      items: [
        const OrderItemModel(productId: 'p012', productName: 'Dettol Sabun Antibakteri', variant: '110g', quantity: 3, price: 18500),
        const OrderItemModel(productId: 'p016', productName: 'Cermin Lipat Dompet LED', variant: 'Silver', quantity: 1, price: 35000),
      ],
    ),
  ];

  // ── Notifications ─────────────────────────────────────────────────────────

  static List<NotificationModel> get mockNotifications => [
        NotificationModel(id: 'n001', title: 'Pesanan Dikirim!', body: 'Pesanan ORD-20240618 sudah dijemput oleh JNE. Lacak pengirimanmu sekarang.', isRead: false, time: '5m ago', type: 'order'),
        NotificationModel(id: 'n002', title: 'Flash Sale Siang Ini!', body: 'ESQA Lip Matte Cream diskon 40% hanya 2 jam lagi. Jangan sampai kehabisan!', isRead: false, time: '30m ago', type: 'promo'),
        NotificationModel(id: 'n003', title: 'IOK Mall — Koleksi Baru', body: 'Shino Shorts varian warna Navy kini tersedia. Dapatkan sebelum kehabisan.', isRead: false, time: '2h ago', type: 'promo'),
        NotificationModel(id: 'n004', title: 'Pesanan Tiba!', body: 'Pesanan ORD-20240610 sudah diterima. Yuk tinggalkan ulasanmu!', isRead: true, time: '1d ago', type: 'order'),
        NotificationModel(id: 'n005', title: 'Beri Ulasan Produk', body: 'Bagaimana IOK Jaket Anti UV? Ulasanmu sangat berarti bagi pembeli lain.', isRead: true, time: '2d ago', type: 'system'),
        NotificationModel(id: 'n006', title: 'FOC Parfume Fest', body: 'Beli FOC Meteore 50ml sekarang dan dapatkan pouch eksklusif gratis senilai 75rb.', isRead: true, time: '3d ago', type: 'promo'),
        NotificationModel(id: 'n007', title: 'Poin Kamu Bertambah!', body: 'Selamat! Kamu mendapatkan 189 poin dari pesanan ORD-20240601.', isRead: true, time: '5d ago', type: 'system'),
        NotificationModel(id: 'n008', title: 'ESQA x Tasya Diulas', body: 'Review ESQA x Tasya Farasya Eyeshadow milikmu mendapat 42 tanda "Helpful".', isRead: true, time: '6d ago', type: 'system'),
        NotificationModel(id: 'n009', title: 'Weekend Sale', body: 'Diskon ekstra 10% untuk semua produk IOK Mall akhir pekan ini. Kode: IOK10.', isRead: true, time: '1w ago', type: 'promo'),
        NotificationModel(id: 'n010', title: 'Profil Diperbarui', body: 'Informasi profil kamu telah berhasil diperbarui.', isRead: true, time: '2w ago', type: 'system'),
      ];

  // ── Addresses ─────────────────────────────────────────────────────────────

  static final List<AddressModel> mockAddresses = [
    AddressModel.fromMap({'id': 'a001', 'label': 'Rumah', 'recipient': 'Muhammad Farhan', 'phone': '+62 812-3456-7890', 'street': 'Jl. Sudirman No. 12, RT 01/RW 03', 'city': 'Jakarta Selatan, DKI Jakarta 12190', 'isDefault': true}),
    AddressModel.fromMap({'id': 'a002', 'label': 'Kantor', 'recipient': 'Muhammad Farhan', 'phone': '+62 812-3456-7890', 'street': 'Jl. HR Rasuna Said Kav. 62', 'city': 'Jakarta Selatan, DKI Jakarta 12940', 'isDefault': false}),
  ];

  // ── Payment Methods ───────────────────────────────────────────────────────

  static final List<PaymentMethodModel> mockPaymentMethods = [
    PaymentMethodModel.fromMap({'id': 'pm001', 'label': 'BCA Virtual Account',      'type': 'bank', 'number': '126 0859 1065 2911 2', 'isDefault': true}),
    PaymentMethodModel.fromMap({'id': 'pm002', 'label': 'Mandiri Virtual Account',  'type': 'bank', 'number': '889 0859 1065 2911 0', 'isDefault': false}),
    PaymentMethodModel.fromMap({'id': 'pm003', 'label': 'BNI Virtual Account',      'type': 'bank', 'number': '988 5510 6529 112',    'isDefault': false}),
    PaymentMethodModel.fromMap({'id': 'pm004', 'label': 'BRI Virtual Account',      'type': 'bank', 'number': '260 8590 1065 2912',   'isDefault': false}),
    PaymentMethodModel.fromMap({'id': 'pm005', 'label': 'CIMB Virtual Account',     'type': 'bank', 'number': '702 0859 1065 2911',   'isDefault': false}),
    PaymentMethodModel.fromMap({'id': 'pm006', 'label': 'Permata Virtual Account',  'type': 'bank', 'number': '820 8591 0652 9112',   'isDefault': false}),
    PaymentMethodModel.fromMap({'id': 'pm007', 'label': 'Danamon Virtual Account',  'type': 'bank', 'number': '158 0859 1065 2911',   'isDefault': false}),
    PaymentMethodModel.fromMap({'id': 'pm008', 'label': 'QRIS',                     'type': 'qris', 'number': '',                     'isDefault': false}),
  ];

  // ── Reviews ───────────────────────────────────────────────────────────────

  static final List<ReviewModel> mockReviews = [
    // ESQA Glazed HD Powder (p001)
    ReviewModel.fromMap({'id': 'r001', 'user': 'Sarah K.', 'rating': 5.0, 'comment': 'Bedaknya halus banget, coverage bagus dan nggak bikin kulit kelihatan cakey. Cocok banget untuk kulit kombinasiku!', 'date': '15 Jun 2024', 'productId': 'p001'}),
    ReviewModel.fromMap({'id': 'r002', 'user': 'Dewi R.', 'rating': 5.0, 'comment': 'Sudah pakai ESQA powder ini selama 3 bulan dan jadi favorit. Tahan lama dan finish-nya natural banget.', 'date': '10 Jun 2024', 'productId': 'p001'}),
    ReviewModel.fromMap({'id': 'r003', 'user': 'Rizka A.', 'rating': 4.0, 'comment': 'Produknya oke, tapi shade Light agak kurang cocok di kulitku yang kuning langsat. Selebihnya oke banget!', 'date': '3 Jun 2024', 'productId': 'p001'}),

    // ESQA Eyeshadow Palette (p002)
    ReviewModel.fromMap({'id': 'r004', 'user': 'Anita S.', 'rating': 5.0, 'comment': 'Palette ini luar biasa! Pigmentasinya sangat bagus, warnanya blend dengan mulus. Worth every penny!', 'date': '12 Jun 2024', 'productId': 'p002'}),
    ReviewModel.fromMap({'id': 'r005', 'user': 'Putri M.', 'rating': 4.5, 'comment': 'Warnanya cantik-cantik dan tahan lama tanpa primer. Kemasannya juga mewah banget. Recommended!', 'date': '8 Jun 2024', 'productId': 'p002'}),

    // ESQA Lip Matte (p003)
    ReviewModel.fromMap({'id': 'r006', 'user': 'Linda W.', 'rating': 5.0, 'comment': 'Formula-nya ringan di bibir dan warnanya intens! Chili Red cocok banget untuk kulit sawo matang.', 'date': '17 Jun 2024', 'productId': 'p003'}),
    ReviewModel.fromMap({'id': 'r007', 'user': 'Maya P.', 'rating': 4.5, 'comment': 'Tahan lama dan nggak bikin bibir kering. Sudah coba 3 shade dan semuanya bagus!', 'date': '14 Jun 2024', 'productId': 'p003'}),

    // FOC Meteore (p004)
    ReviewModel.fromMap({'id': 'r008', 'user': 'Budi S.', 'rating': 5.0, 'comment': 'Wanginya elegan banget, maskulin tapi tidak terlalu berat. Tahan sampai 10 jam di kulitku. Highly recommended!', 'date': '11 Jun 2024', 'productId': 'p004'}),
    ReviewModel.fromMap({'id': 'r009', 'user': 'Arif D.', 'rating': 4.5, 'comment': 'Parfum lokal yang kualitasnya tidak kalah dengan brand internasional. Sillage-nya bagus dan ketahanannya lama.', 'date': '9 Jun 2024', 'productId': 'p004'}),

    // IOK Celana Olahraga (p005)
    ReviewModel.fromMap({'id': 'r010', 'user': 'Reza F.', 'rating': 5.0, 'comment': 'Bahan celana ini top banget! Nyaman dipakai lari pagi, keringat cepat kering dan nggak gerah. Sudah beli 3 warna.', 'date': '13 Jun 2024', 'productId': 'p005'}),
    ReviewModel.fromMap({'id': 'r011', 'user': 'Hendra K.', 'rating': 4.5, 'comment': 'Kualitas bagus untuk harganya. Setelah 5x cuci masih tidak melar dan warnanya tidak pudar.', 'date': '7 Jun 2024', 'productId': 'p005'}),

    // IOK Jaket Anti UV (p006)
    ReviewModel.fromMap({'id': 'r012', 'user': 'Sinta L.', 'rating': 5.0, 'comment': 'Jaketnya ringan banget, hampir nggak berasa dipake. Proteksi UV-nya nyata, kulit tidak gosong setelah seharian outdoor.', 'date': '16 Jun 2024', 'productId': 'p006'}),
    ReviewModel.fromMap({'id': 'r013', 'user': 'Dian M.', 'rating': 4.0, 'comment': 'Keren dan fungsional. Bisa dilipat kecil masuk tas. Sedikit minus: ritsleting agak keras diawal pemakaian.', 'date': '5 Jun 2024', 'productId': 'p006'}),

    // Smartwatch (p009)
    ReviewModel.fromMap({'id': 'r014', 'user': 'Tono W.', 'rating': 4.0, 'comment': 'Monitor detak jantung cukup akurat dibanding band lain. Layarnya terang dan baterai memang tahan 7 hari.', 'date': '4 Jun 2024', 'productId': 'p009'}),

    // Pomade (p010)
    ReviewModel.fromMap({'id': 'r015', 'user': 'Fajar A.', 'rating': 4.5, 'comment': 'Water-based jadi enak dibersihkan. Hold-nya kuat tapi nggak bikin rambut kaku. Classic!', 'date': '6 Jun 2024', 'productId': 'p010'}),

    // Facial Wash (p011)
    ReviewModel.fromMap({'id': 'r016', 'user': 'Citra N.', 'rating': 5.0, 'comment': 'Kulit bersih tanpa rasa ketarik setelah cuci muka. Sudah pakai berulang kali dan jadi staple skincare harianku.', 'date': '18 Jun 2024', 'productId': 'p011'}),

    // G-MAX Kopi Ginseng (fs001)
    ReviewModel.fromMap({'id': 'r017', 'user': 'Surya K.', 'rating': 5.0, 'comment': 'Kopi ini beneran bikin badan segar dan semangat! Udah pesan ke-3 kali dan nggak bisa stop. Rasa kopinya enak nggak terlalu pahit.', 'date': '17 Jun 2024', 'productId': 'fs001'}),
    ReviewModel.fromMap({'id': 'r018', 'user': 'Bambang W.', 'rating': 4.5, 'comment': 'Mantap, stamina lebih terjaga setelah rutin minum tiap pagi. Harga flash sale ini sangat worth it untuk kualitasnya.', 'date': '14 Jun 2024', 'productId': 'fs001'}),

    // METOO Toothpaste (fs002)
    ReviewModel.fromMap({'id': 'r019', 'user': 'Fitriani S.', 'rating': 5.0, 'comment': 'Gigi saya jadi lebih putih setelah 2 minggu pakai! Busa-nya banyak dan rasa mint-nya segar. Recommended banget!', 'date': '16 Jun 2024', 'productId': 'fs002'}),
    ReviewModel.fromMap({'id': 'r020', 'user': 'Nanda P.', 'rating': 4.0, 'comment': 'Hasilnya lumayan, gigi memang lebih cerah. Harga promo sangat murah untuk dapat 3 tube sekaligus.', 'date': '11 Jun 2024', 'productId': 'fs002'}),

    // Morris White Edition (fs003)
    ReviewModel.fromMap({'id': 'r021', 'user': 'Rizal A.', 'rating': 5.0, 'comment': 'Wanginya clean dan elegan, dapat banyak pujian dari teman-teman. Ketahanannya bagus, sampai 7 jam di kulitku. Harga flash sale sangat worth it!', 'date': '15 Jun 2024', 'productId': 'fs003'}),
    ReviewModel.fromMap({'id': 'r022', 'user': 'Dimas F.', 'rating': 4.5, 'comment': 'Cocok untuk daily wear, tidak terlalu strong dan tidak terlalu light. Botolnya elegan dan desainnya premium.', 'date': '10 Jun 2024', 'productId': 'fs003'}),

    // WSKEN Tempered Glass (fs004)
    ReviewModel.fromMap({'id': 'r023', 'user': 'Kevin L.', 'rating': 5.0, 'comment': 'Pemasangan auto-align-nya gampang banget, nggak ada gelembung sama sekali! Layar tetap responsif dan jernih. Sangat worth it untuk harganya.', 'date': '18 Jun 2024', 'productId': 'fs004'}),
    ReviewModel.fromMap({'id': 'r024', 'user': 'Andi S.', 'rating': 4.0, 'comment': 'Kualitas bagus, anti gores oke dan touchscreen tetap lancar. Pengiriman cepat. Sedikit kurang: edge-nya agak tajam saat pertama pasang.', 'date': '12 Jun 2024', 'productId': 'fs004'}),
  ];

  // ── Flash Sale ────────────────────────────────────────────────────────────

  static FlashSaleModel get mockFlashSale => FlashSaleModel(
        currentSession: FlashSaleSessionModel(
          id: 'fs_session_001',
          title: 'Flash Sale Siang',
          endsAt: DateTime.now().add(const Duration(hours: 2, minutes: 47)),
          items: const [
            FlashSaleItemModel(
              productId: 'fs001',
              productName: 'G-MAX Kopi Ginseng 1 Box 10 Sachet',
              brand: 'G-MAX',
              sellerId: 's004',
              sellerName: 'G-MAX Official',
              imageUrl: 'assets/public/flashsale/G-MAX Kopi Kekuatan Alami dari Ginseng Asli ( 1 BOX Isi 10 Sachet ).webp',
              originalPrice: 185000,
              flashSalePrice: 99000,
              discountPercent: 46,
              flashSaleStock: 100,
              soldCount: 82,
              soldPercent: 82,
              color: Color(0xFFFFF8E1),
            ),
            FlashSaleItemModel(
              productId: 'fs002',
              productName: 'METOO MW-3 Whitening Toothpaste 3x100g',
              brand: 'METOO',
              sellerId: 's005',
              sellerName: 'METOO Store',
              imageUrl: 'assets/public/flashsale/METOO MW-3 Advanced whitening Toothpaste 3*100g - Gigi Putih.webp',
              originalPrice: 120000,
              flashSalePrice: 65000,
              discountPercent: 46,
              flashSaleStock: 80,
              soldCount: 61,
              soldPercent: 76,
              color: Color(0xFFE3F2FD),
            ),
            FlashSaleItemModel(
              productId: 'fs003',
              productName: 'Morris White Edition EDP 100ml',
              brand: 'MORRIS',
              sellerId: 's006',
              sellerName: 'Morris Official',
              imageUrl: 'assets/public/flashsale/Morris Eau De Parfum White Edition 100ml - Parfum Pria.webp',
              originalPrice: 349000,
              flashSalePrice: 219000,
              discountPercent: 37,
              flashSaleStock: 30,
              soldCount: 17,
              soldPercent: 57,
              color: Color(0xFFEDE7F6),
            ),
            FlashSaleItemModel(
              productId: 'fs004',
              productName: 'WSKEN Tempered Glass Auto Align iPhone',
              brand: 'WSKEN',
              sellerId: 's007',
              sellerName: 'WSKEN Store',
              imageUrl: 'assets/public/flashsale/WSKEN Tempered Glass Clear Privacy Glossy Auto Align Tech Anti Gores Screen Protector Full for iPhone.webp',
              originalPrice: 79000,
              flashSalePrice: 35000,
              discountPercent: 56,
              flashSaleStock: 200,
              soldCount: 148,
              soldPercent: 74,
              color: Color(0xFFE8F5E9),
            ),
          ],
        ),
      );

  // ── Onboarding ────────────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> mockOnboardingSlides = [
    {'icon': Icons.local_mall, 'color': Color(0xFFFFCDD2), 'title': 'Discover Beauty Products', 'subtitle': 'Browse thousands of beauty & skincare products from top brands worldwide.'},
    {'icon': Icons.local_shipping_outlined, 'color': Color(0xFFBBDEFB), 'title': 'Fast & Secure Delivery', 'subtitle': 'Get your orders delivered to your doorstep safely and on time.'},
    {'icon': Icons.star_outline, 'color': Color(0xFFE1BEE7), 'title': 'Trusted by Millions', 'subtitle': 'Join over 2 million happy customers who trust Parela for their beauty needs.'},
  ];
}
