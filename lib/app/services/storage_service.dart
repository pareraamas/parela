import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parela/app/data/models/cart_item_model.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance!;

  late final SharedPreferences _prefs;

  StorageService._(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = StorageService._(prefs);
    return _instance!;
  }

  // ── Cart ──────────────────────────────────────────────────────────────────

  static const _cartKey = 'cart_items';

  List<CartItemModel> loadCart() {
    final raw = _prefs.getStringList(_cartKey) ?? [];
    return raw
        .map((s) => CartItemModel.fromMap(json.decode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCart(List<CartItemModel> items) async {
    final raw = items.map((i) => json.encode(i.toMap())).toList();
    await _prefs.setStringList(_cartKey, raw);
  }

  Future<void> clearCart() => _prefs.remove(_cartKey);

  // ── Wishlist ──────────────────────────────────────────────────────────────

  static const _wishlistKey = 'wishlist_ids';

  List<String> loadWishlist() => _prefs.getStringList(_wishlistKey) ?? [];

  Future<void> saveWishlist(List<String> ids) async =>
      _prefs.setStringList(_wishlistKey, ids);

  // ── Session ───────────────────────────────────────────────────────────────

  static const _loggedInKey = 'is_logged_in';

  bool get isLoggedIn => _prefs.getBool(_loggedInKey) ?? false;

  Future<void> setLoggedIn(bool value) => _prefs.setBool(_loggedInKey, value);

  Future<void> clearAll() => _prefs.clear();
}
