import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/services/storage_service.dart';
import '../cart_repository.dart';

class MockCartRepository implements CartRepository {
  @override
  List<CartItemModel> getInitialCart() => MockContent.mockCartItems;

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
