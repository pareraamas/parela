import 'package:get/get.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';

class CartController extends GetxController {
  late final MainController _main;
  late final HomeTabController _home;

  // UI-only: set of cart indices that are selected
  final selectedIndices = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _main = Get.find<MainController>();
    _home = Get.find<HomeTabController>();
  }

  // ── Convenience getters ──────────────────────────────────────────────────

  MainController get main => _main;
  HomeTabController get home => _home;

  bool isSelected(int index) => selectedIndices.contains(index);

  bool get allSelected =>
      _main.cartItems.isNotEmpty &&
      List.generate(_main.cartItems.length, (i) => i)
          .every(selectedIndices.contains);

  int get selectedCount => selectedIndices.length;

  double get selectedTotal => selectedIndices.fold<double>(
        0,
        (sum, i) =>
            sum + (i < _main.cartItems.length ? _main.cartItems[i].subtotal : 0),
      );

  double get selectedOriginalTotal => selectedIndices.fold<double>(0, (sum, i) {
        if (i >= _main.cartItems.length) return sum;
        final item = _main.cartItems[i];
        final product = _home.products.firstWhereOrNull(
          (p) => p.id == item.productId,
        );
        final originalPrice =
            product != null && product.originalPrice > item.price
                ? product.originalPrice
                : item.price;
        return sum + originalPrice * item.quantity;
      });

  double get selectedDiscount => selectedOriginalTotal - selectedTotal;

  ProductModel? productFor(String productId) =>
      _home.products.firstWhereOrNull((p) => p.id == productId);

  // ── Selection mutations ──────────────────────────────────────────────────

  void toggle(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
    } else {
      selectedIndices.add(index);
    }
  }

  void toggleAll() {
    if (allSelected) {
      selectedIndices.clear();
    } else {
      selectedIndices.addAll(
          List.generate(_main.cartItems.length, (i) => i));
    }
  }

  void selectGroup(List<int> indices, bool value) {
    for (final i in indices) {
      if (value) {
        selectedIndices.add(i);
      } else {
        selectedIndices.remove(i);
      }
    }
  }

  // ── Cart mutations (delegate to MainController) ──────────────────────────

  void removeAt(int index) {
    _main.removeFromCart(index);
    // Shift selected indices above the removed item
    final rebuilt = <int>{};
    for (final s in selectedIndices) {
      if (s < index) rebuilt.add(s);
      if (s > index) rebuilt.add(s - 1);
    }
    selectedIndices
      ..clear()
      ..addAll(rebuilt);
  }

  void removeSelected() {
    final sorted = selectedIndices.toList()..sort((a, b) => b.compareTo(a));
    for (final i in sorted) {
      _main.removeFromCart(i);
    }
    selectedIndices.clear();
  }

  void updateQty(int index, int qty) => _main.updateQuantity(index, qty);
}
