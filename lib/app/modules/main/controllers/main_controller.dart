import 'package:get/get.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/repositories/cart_repository.dart';
import 'package:parela/app/data/repositories/product_repository.dart';

class MainController extends GetxController {
  late final CartRepository _cartRepo;
  late final ProductRepository _productRepo;

  final tabIndex = 0.obs;
  final cartCount = 0.obs;
  final wishlistIds = <String>[].obs;
  final cartItems = <CartItemModel>[].obs;

  late final List<ProductModel> products;
  late final List<CategoryModel> categories;
  late final List<BannerModel> banners;
  late final List<Map<String, dynamic>> stories;

  @override
  void onInit() {
    super.onInit();
    _cartRepo = Get.find<CartRepository>();
    _productRepo = Get.find<ProductRepository>();

    products = _productRepo.getAll();
    categories = _productRepo.getCategories();
    banners = _productRepo.getBanners();
    stories = _productRepo.getStories();

    final saved = _cartRepo.loadCart();
    cartItems.assignAll(saved.isNotEmpty ? saved : _cartRepo.getInitialCart());
    wishlistIds.assignAll(_cartRepo.loadWishlist());
    cartCount.value = cartItems.length;
  }

  void changeTab(int index) => tabIndex.value = index;

  void addToCart(CartItemModel item) {
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
