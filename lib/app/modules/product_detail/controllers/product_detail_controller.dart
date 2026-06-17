import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';

class ProductDetailController extends GetxController {
  late final ProductRepository _repo;
  late final ProductModel product;
  final selectedColorIndex = 0.obs;
  final selectedSizeIndex = 0.obs;
  final quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<ProductRepository>();
    product = Get.arguments as ProductModel? ?? _repo.getAll().first;
  }

  List<ReviewModel> get reviews => _repo.getReviewsFor(product.id);

  void incrementQty() => quantity.value++;
  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    final main = Get.find<MainController>();
    main.addToCart(CartItemModel(
      productId: product.id,
      quantity: quantity.value,
      color: product.colors[selectedColorIndex.value],
      size: product.sizes[selectedSizeIndex.value],
      price: product.price,
    ));
    Get.snackbar(
      'Added to Cart',
      '${product.name} added successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void toggleWishlist() => Get.find<MainController>().toggleWishlist(product.id);

  bool get isWishlisted => Get.find<MainController>().wishlistIds.contains(product.id);
}
