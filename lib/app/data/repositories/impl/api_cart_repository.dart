import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/repositories/cart_repository.dart';
import 'package:parela/app/services/storage_service.dart';

// Cart operations via API require auth and use variant_id.
// Local persistence (StorageService) remains as fallback / offline cache.
class ApiCartRepository implements CartRepository {
  @override
  List<CartItemModel> getInitialCart() => [];

  @override
  List<CartItemModel> loadCart() => StorageService.instance.loadCart();

  @override
  Future<void> saveCart(List<CartItemModel> items) =>
      StorageService.instance.saveCart(items);

  @override
  Future<void> clearCart() => StorageService.instance.clearCart();

  @override
  List<String> loadWishlist() => StorageService.instance.loadWishlist();

  @override
  Future<void> saveWishlist(List<String> ids) =>
      StorageService.instance.saveWishlist(ids);
}
