import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/modules/home/controllers/home_controller.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    final homeTab = Get.find<HomeTabController>();
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new, color: kText, size: 20),
        ),
        title: Obx(
          () => Text(
            'My Cart (${main.cartItems.length})',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (main.cartItems.isEmpty) {
          return const _EmptyCart();
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: main.cartItems.length,
                itemBuilder: (context, index) {
                  final item = main.cartItems[index];
                  final product = homeTab.products.firstWhere(
                    (p) => p.id == item.productId,
                    orElse: () => homeTab.products.first,
                  );
                  return _CartItemRow(
                    product: product,
                    item: item,
                    index: index,
                    controller: main,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: kBackground, width: 1.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(color: kSubtext)),
                      Text(
                        'Rp ${_fmt(main.cartSubtotal)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kText,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(Routes.CHECKOUT),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _fmt(double price) => price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

class _CartItemRow extends StatelessWidget {
  final ProductModel product;
  final CartItemModel item;
  final int index;
  final MainController controller;

  const _CartItemRow({
    required this.product,
    required this.item,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: product.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.image, color: kPrimary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.brand,
                    style: const TextStyle(fontSize: 10, color: kSubtext)),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: kText),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _ColorDot(item.color),
                    const SizedBox(width: 6),
                    _Tag(item.size),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${_fmt(item.price)}',
                  style: const TextStyle(
                      color: kPrimary, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => controller.removeFromCart(index),
                child: const Icon(Icons.delete_outline, color: kSubtext, size: 20),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: () => controller.updateQuantity(index, item.quantity - 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () => controller.updateQuantity(index, item.quantity + 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double price) => price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

class _ColorDot extends StatelessWidget {
  final int colorValue;
  const _ColorDot(this.colorValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Color(colorValue),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: 1),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, color: kSubtext)),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: kPrimary),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 80, color: kPrimaryLight),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kText),
          ),
          const SizedBox(height: 8),
          const Text('Start adding items to your cart',
              style: TextStyle(color: kSubtext)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: Get.back,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              elevation: 0,
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
