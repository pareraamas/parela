import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';

abstract class ProductRepository {
  List<ProductModel> getAll();
  List<ProductModel> getByCategory(String categoryId);
  List<ProductModel> getBySeller(String sellerId);
  ProductModel? getById(String id);
  List<ReviewModel> getReviewsFor(String productId);
  List<CategoryModel> getCategories();
  List<BannerModel> getBanners();
  List<Map<String, dynamic>> getStories();
}
