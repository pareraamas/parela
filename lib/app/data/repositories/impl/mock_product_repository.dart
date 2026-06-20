import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import '../product_repository.dart';

class MockProductRepository implements ProductRepository {
  @override
  Future<List<ProductModel>> getAll() async => MockContent.mockProducts;

  @override
  Future<List<ProductModel>> getByCategory(String categoryId) async {
    final filtered = MockContent.mockProducts.where((p) => p.categoryId == categoryId).toList();
    return filtered.isEmpty ? MockContent.mockProducts : filtered;
  }

  @override
  Future<List<ProductModel>> getBySeller(String sellerId) async {
    final filtered = MockContent.mockProducts.where((p) => p.sellerId == sellerId).toList();
    return filtered.isEmpty ? MockContent.mockProducts.take(4).toList() : filtered;
  }

  @override
  Future<ProductModel?> getById(String id) async =>
      MockContent.mockProducts.where((p) => p.id == id).firstOrNull;

  @override
  Future<List<ReviewModel>> getReviewsFor(String productId) async =>
      MockContent.mockReviews.where((r) => r.productId == productId).toList();

  @override
  Future<List<CategoryModel>> getCategories() async => MockContent.mockCategories;

  @override
  Future<List<BannerModel>> getBanners() async => MockContent.mockBanners;

  @override
  Future<List<Map<String, dynamic>>> getStories() async => MockContent.mockStories;
}
