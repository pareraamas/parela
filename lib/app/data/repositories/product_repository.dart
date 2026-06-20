import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';

abstract class ProductRepository {
  Future<({List<ProductModel> data, bool hasMore})> getAll({int page = 1, int limit = 10});
  Future<List<ProductModel>> getByCategory(String categoryId);
  Future<List<ProductModel>> getBySeller(String sellerId);
  Future<ProductModel?> getById(String id);
  Future<List<ReviewModel>> getReviewsFor(String productId);
  Future<List<CategoryModel>> getCategories();
  Future<List<BannerModel>> getBanners();
  Future<List<Map<String, dynamic>>> getStories();
}
