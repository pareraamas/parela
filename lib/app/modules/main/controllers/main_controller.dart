import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/data/models/user_model.dart';
import 'package:parela/app/data/repositories/cart_repository.dart';
import 'package:parela/app/data/repositories/seller_repository.dart';
import 'package:parela/app/data/repositories/user_repository.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/services/storage_service.dart';

class MainController extends GetxController {
  late final CartRepository _cartRepo;
  late final SellerRepository _sellerRepo;

  final tabIndex = 0.obs;
  final cartCount = 0.obs;
  final wishlistIds = <String>[].obs;
  final cartItems = <CartItemModel>[].obs;
  final isLoggedIn = false.obs;
  final currentUser = Rxn<UserModel>();

  final _sellersById = <String, SellerModel>{};
  int? _pendingTabAfterLogin;

  SellerModel? sellerById(String id) => _sellersById[id];

  @override
  void onInit() {
    super.onInit();
    _cartRepo = Get.find<CartRepository>();
    _sellerRepo = Get.find<SellerRepository>();
    _loadSellers();
    if (StorageService.instance.isLoggedIn) {
      _initUser();
    }
  }

  Future<void> _initUser() async {
    try {
      final user = await Get.find<UserRepository>().getUser();
      setUser(user);
    } catch (_) {
      await StorageService.instance.clearTokens();
    }
  }

  Future<void> _loadSellers() async {
    final list = await _sellerRepo.getAll();
    for (final s in list) {
      _sellersById[s.id] = s;
    }
  }

  void changeTab(int index) {
    tabIndex.value = index;
  }

  void setUser(UserModel user) {
    currentUser.value = user;
    isLoggedIn.value = true;
    final saved = _cartRepo.loadCart();
    cartItems.assignAll(saved.isNotEmpty ? saved : _cartRepo.getInitialCart());
    wishlistIds.assignAll(_cartRepo.loadWishlist());
    cartCount.value = cartItems.length;
    if (_pendingTabAfterLogin != null) {
      tabIndex.value = _pendingTabAfterLogin!;
      _pendingTabAfterLogin = null;
    }
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    cartItems.clear();
    wishlistIds.clear();
    cartCount.value = 0;
    
    // Clear persistent session tokens
    StorageService.instance.clearTokens();
    
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
      (i) =>
          i.productId == item.productId &&
          i.color == item.color &&
          i.size == item.size,
    );
    if (idx >= 0) {
      cartItems[idx] = cartItems[idx].copyWith(
        quantity: cartItems[idx].quantity + item.quantity,
      );
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

  double get cartSubtotal =>
      cartItems.fold(0, (sum, item) => sum + item.subtotal);

  void _persist() => _cartRepo.saveCart(cartItems.toList());
}
