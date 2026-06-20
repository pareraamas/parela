import 'package:get/get.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/user_model.dart';
import 'package:parela/app/data/repositories/cart_repository.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/routes/app_pages.dart';

class MainController extends GetxController {
  late final CartRepository _cartRepo;
  late final ProductRepository _productRepo;

  final tabIndex = 0.obs;
  final cartCount = 0.obs;
  final wishlistIds = <String>[].obs;
  final cartItems = <CartItemModel>[].obs;
  final isLoggedIn = false.obs;
  final isLoading = true.obs;
  final currentUser = Rxn<UserModel>();

  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final banners = <BannerModel>[].obs;
  final stories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _cartRepo = Get.find<CartRepository>();
    _productRepo = Get.find<ProductRepository>();
  }

  @override
  void onReady() {
    super.onReady();
    _loadPublicData();
  }

  Future<void> _loadPublicData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _productRepo.getAll(),
        _productRepo.getCategories(),
        _productRepo.getBanners(),
        _productRepo.getStories(),
      ]);
      products.assignAll(results[0] as List<ProductModel>);
      categories.assignAll(results[1] as List<CategoryModel>);
      banners.assignAll(results[2] as List<BannerModel>);
      stories.assignAll(results[3] as List<Map<String, dynamic>>);
    } catch (_) {
      // keep existing data on error
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) => tabIndex.value = index;

  void setUser(UserModel user) {
    currentUser.value = user;
    isLoggedIn.value = true;
    final saved = _cartRepo.loadCart();
    cartItems.assignAll(saved.isNotEmpty ? saved : _cartRepo.getInitialCart());
    wishlistIds.assignAll(_cartRepo.loadWishlist());
    cartCount.value = cartItems.length;
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    cartItems.clear();
    wishlistIds.clear();
    cartCount.value = 0;
    Get.offAllNamed(Routes.MAIN);
  }

  bool _requireAuth() {
    if (isLoggedIn.value) return true;
    Get.toNamed(Routes.LOGIN);
    return false;
  }

  void addToCart(CartItemModel item) {
    if (!_requireAuth()) return;
    final idx = cartItems.indexWhere(
      (i) => i.productId == item.productId && i.color == item.color && i.size == item.size,
    );
    if (idx >= 0) {
      cartItems[idx] = cartItems[idx].copyWith(quantity: cartItems[idx].quantity + item.quantity);
    } else {
      cartItems.add(item);
    }
    cartCount.value = cartItems.length;
    _persist();
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
    cartCount.value = cartItems.length;
    _persist();
  }

  void updateQuantity(int index, int qty) {
    if (qty <= 0) {
      removeFromCart(index);
    } else {
      cartItems[index] = cartItems[index].copyWith(quantity: qty);
      _persist();
    }
  }

  void clearCart() {
    cartItems.clear();
    cartCount.value = 0;
    _cartRepo.clearCart();
  }

  void toggleWishlist(String productId) {
    if (!_requireAuth()) return;
    if (wishlistIds.contains(productId)) {
      wishlistIds.remove(productId);
    } else {
      wishlistIds.add(productId);
    }
    _cartRepo.saveWishlist(wishlistIds.toList());
  }

  double get cartSubtotal => cartItems.fold(0, (sum, item) => sum + item.subtotal);

  void _persist() => _cartRepo.saveCart(cartItems.toList());
}
