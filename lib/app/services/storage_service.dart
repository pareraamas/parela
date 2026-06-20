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

  // ── Auth tokens ───────────────────────────────────────────────────────────

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  String? get accessToken => _prefs.getString(_accessTokenKey);
  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  bool get isLoggedIn => accessToken != null;

  // ── Session ───────────────────────────────────────────────────────────────

  Future<void> clearAll() => _prefs.clear();
}
