import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';

class ProductSearchController extends GetxController {
  final recentSearches = <String>[].obs;

  void addSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    recentSearches.remove(q);
    recentSearches.insert(0, q);
    if (recentSearches.length > 8) recentSearches.removeLast();
  }

  void removeSearch(String query) => recentSearches.remove(query);

  void clearAll() => recentSearches.clear();

  List<ProductModel> getSuggestions(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    return Get.find<HomeTabController>()
        .products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q))
        .take(6)
        .toList();
  }
}
