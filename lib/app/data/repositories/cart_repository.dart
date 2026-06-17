import 'package:parela/app/data/models/cart_item_model.dart';

abstract class CartRepository {
  List<CartItemModel> getInitialCart();
  List<CartItemModel> loadCart();
  Future<void> saveCart(List<CartItemModel> items);
  Future<void> clearCart();
  List<String> loadWishlist();
  Future<void> saveWishlist(List<String> ids);
}
