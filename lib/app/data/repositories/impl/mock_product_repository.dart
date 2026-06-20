import 'package:parela/app/data/mock/mock_database.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import '../product_repository.dart';

class MockProductRepository implements ProductRepository {
  final _db = MockDatabase.instance;

  static Future<void> _delay([int ms = 700]) =>
      Future.delayed(Duration(milliseconds: ms));

  @override
  Future<({List<ProductModel> data, bool hasMore})> getAll(
      {int page = 1, int limit = 10}) async {
    await _delay(page == 1 ? 800 : 600);
    return _db.paginate(_db.products, page: page, limit: limit);
  }

  @override
  Future<List<ProductModel>> getByCategory(String categoryId) async {
    await _delay();
    final filtered = _db.products.where((p) => p.categoryId == categoryId).toList();
    return filtered.isEmpty ? _db.products : filtered;
  }

  @override
  Future<List<ProductModel>> getBySeller(String sellerId) async {
    await _delay();
    final filtered = _db.products.where((p) => p.sellerId == sellerId).toList();
    return filtered.isEmpty ? _db.products.take(4).toList() : filtered;
  }

  @override
  Future<ProductModel?> getById(String id) async {
    await _delay(400);
    return _db.products.where((p) => p.id == id).firstOrNull;
  }

  @override
  Future<List<ReviewModel>> getReviewsFor(String productId) async {
    await _delay(400);
    return _db.reviews.where((r) => r.productId == productId).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async => _db.categories;

  @override
  Future<List<BannerModel>> getBanners() async => _db.banners;

  @override
  Future<List<Map<String, dynamic>>> getStories() async => _db.stories;

  @override
  Future<List<Map<String, dynamic>>> getVideoFeed() async => _db.videoFeed;
}
