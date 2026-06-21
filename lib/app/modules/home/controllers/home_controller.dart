import 'package:get/get.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';

class HomeTabController extends GetxController {
  late final ProductRepository _productRepo;

  static const _limit = 12;

  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final banners = <BannerModel>[].obs;
  final stories = <Map<String, dynamic>>[].obs;

  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    _productRepo = Get.find<ProductRepository>();
  }

  @override
  void onReady() {
    super.onReady();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    try {
      isLoading.value = true;
      _page = 1;
      hasMore.value = true;
      products.clear();

      final results = await Future.wait([
        _productRepo.getAll(page: 1, limit: _limit),
        _productRepo.getCategories(),
        _productRepo.getBanners(),
        _productRepo.getStories(),
      ]);

      final paged = results[0] as ({List<ProductModel> data, bool hasMore});
      products.assignAll(paged.data);
      hasMore.value = paged.hasMore;
      _page = 2;

      categories.assignAll(results[1] as List<CategoryModel>);
      banners.assignAll(results[2] as List<BannerModel>);
      stories.assignAll(results[3] as List<Map<String, dynamic>>);
    } catch (_) {
      // keep existing data on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;
    try {
      isLoadingMore.value = true;
      final paged = await _productRepo.getAll(page: _page, limit: _limit);
      products.addAll(paged.data);
      hasMore.value = paged.hasMore;
      _page++;
    } catch (_) {
      // keep existing products on error
    } finally {
      isLoadingMore.value = false;
    }
  }
}
