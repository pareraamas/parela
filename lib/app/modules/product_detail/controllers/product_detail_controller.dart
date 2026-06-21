import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/data/repositories/seller_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';

class ProductDetailController extends GetxController {
  late final ProductRepository _repo;
  late final SellerRepository _sellerRepo;
  late final ProductModel product;
  final selectedColorIndex = 0.obs;
  final selectedSizeIndex = 0.obs;
  final quantity = 1.obs;
  final reviews = <ReviewModel>[].obs;
  final isLoadingReviews = false.obs;
  final seller = Rx<SellerModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<ProductRepository>();
    _sellerRepo = Get.find<SellerRepository>();
    product = Get.arguments as ProductModel;
    _loadReviews();
    _loadSeller();
  }

  Future<void> _loadReviews() async {
    try {
      isLoadingReviews.value = true;
      reviews.assignAll(await _repo.getReviewsFor(product.id));
    } catch (_) {
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> _loadSeller() async {
    try {
      seller.value = await _sellerRepo.getById(product.sellerId);
    } catch (_) {}
  }

  void incrementQty() => quantity.value++;
  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    final main = Get.find<MainController>();
    final color = product.colors.isNotEmpty
        ? product.colors[selectedColorIndex.value]
        : 0xFF000000;
    final size = product.sizes.isNotEmpty
        ? product.sizes[selectedSizeIndex.value]
        : 'One Size';
    main.addToCart(
      CartItemModel(
        productId: product.id,
        quantity: quantity.value,
        color: color,
        size: size,
        price: product.price,
      ),
    );
  }

  void toggleWishlist() =>
      Get.find<MainController>().toggleWishlist(product.id);

  bool get isWishlisted =>
      Get.find<MainController>().wishlistIds.contains(product.id);
}
