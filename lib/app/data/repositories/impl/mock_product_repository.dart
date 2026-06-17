import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import '../product_repository.dart';

class MockProductRepository implements ProductRepository {
  @override
  List<ProductModel> getAll() => MockContent.mockProducts;

  @override
  List<ProductModel> getByCategory(String categoryId) {
    final filtered =
        MockContent.mockProducts.where((p) => p.categoryId == categoryId).toList();
    return filtered.isEmpty ? MockContent.mockProducts : filtered;
  }

  @override
  List<ProductModel> getBySeller(String sellerId) {
    final filtered =
        MockContent.mockProducts.where((p) => p.sellerId == sellerId).toList();
    return filtered.isEmpty
        ? MockContent.mockProducts.take(4).toList()
        : filtered;
  }

  @override
  ProductModel? getById(String id) =>
      MockContent.mockProducts.where((p) => p.id == id).firstOrNull;

  @override
  List<ReviewModel> getReviewsFor(String productId) =>
      MockContent.mockReviews.where((r) => r.productId == productId).toList();

  @override
  List<CategoryModel> getCategories() => MockContent.mockCategories;

  @override
  List<BannerModel> getBanners() => MockContent.mockBanners;

  @override
  List<Map<String, dynamic>> getStories() => MockContent.mockStories;
}
