import 'dart:ui';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/services/api_client.dart';

class ApiProductRepository implements ProductRepository {
  final _client = ApiClient.instance;

  @override
  Future<({List<ProductModel> data, bool hasMore})> getAll({int page = 1, int limit = 10}) async {
    final res = await _client.get('/products', query: {'page': page, 'limit': limit}, auth: false);
    final data = ((res['data'] as List?) ?? [])
        .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
        .toList();
    final meta = res['meta'] as Map<String, dynamic>?;
    final hasMore = meta != null
        ? (meta['current_page'] as int? ?? page) < (meta['last_page'] as int? ?? 1)
        : data.length >= limit;
    return (data: data, hasMore: hasMore);
  }

  @override
  Future<List<ProductModel>> getByCategory(String categoryId) async {
    final res = await _client.get('/categories/$categoryId/products', auth: false);
    return ((res['data'] as List?) ?? [])
        .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getBySeller(String sellerId) async {
    final res = await _client.get('/sellers/$sellerId/products', auth: false);
    return ((res['data'] as List?) ?? [])
        .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel?> getById(String id) async {
    final res = await _client.get('/products/$id', auth: false);
    final data = res['data'];
    if (data == null) return null;
    return ProductModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<ReviewModel>> getReviewsFor(String productId) async {
    final res = await _client.get('/products/$productId/reviews', auth: false);
    return ((res['data'] as List?) ?? [])
        .map((j) => ReviewModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final res = await _client.get('/categories', auth: false);
    return ((res['data'] as List?) ?? [])
        .map((j) => CategoryModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    final res = await _client.get('/banners', auth: false);
    return ((res['data'] as List?) ?? [])
        .map((j) => BannerModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getStories() async {
    final res = await _client.get('/stories', auth: false);
    return ((res['data'] as List?) ?? [])
        .map((j) => <String, dynamic>{
              'label': j['label'] as String? ?? '',
              'color': _colorFromHex(j['color_hex'] as String? ?? 'FFE1BEE7'),
              'image_url': j['image_url'],
            })
        .toList();
  }

  static Color _colorFromHex(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
  }
}
