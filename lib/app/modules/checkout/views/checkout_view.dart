import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/widgets/shimmer.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kPrimary, size: 20),
          onPressed: Get.back,
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: kText,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _AddressBar(controller: controller),
            const SizedBox(height: 8),
            _ProductsSection(controller: controller),
            const SizedBox(height: 8),
            _PaymentSection(controller: controller),
            const SizedBox(height: 8),
            _SummarySection(controller: controller),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(controller: controller),
    );
  }
}

// ── Address Bar ─────────────────────────────────────────────────────────────

class _AddressBar extends StatelessWidget {
  final CheckoutController controller;
  const _AddressBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final addr = controller.selectedAddress;
      return GestureDetector(
        onTap: () async {
          final currentId = addr?.id ?? '';
          final result = await Get.toNamed(
            Routes.SELECT_ADDRESS,
            arguments: currentId,
          );
          if (result is String) {
            final idx = controller.addresses.indexWhere((a) => a.id == result);
            if (idx != -1) controller.selectedAddressIndex.value = idx;
          }
        },
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: kPrimary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: addr == null
                    ? const Text(
                        'Pilih alamat pengiriman',
                        style: TextStyle(color: kSubtext, fontSize: 14),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                addr.recipient,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: kText,
                                ),
                              ),
                              if (addr.phone.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Text(
                                  addr.phone,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kSubtext,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${addr.street}, ${addr.city}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: kSubtext,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: kSubtext, size: 20),
            ],
          ),
        ),
      );
    });
  }
}

// ── Products Section ─────────────────────────────────────────────────────────

class _ProductsSection extends StatelessWidget {
  final CheckoutController controller;
  const _ProductsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();
    return Obx(() {
      if (!controller.isReady.value) {
        return AppShimmer(
          child: Column(
            children: List.generate(3, (_) => const ShimmerListRow()),
          ),
        );
      }
      final cartItems = main.cartItems;
      if (cartItems.isEmpty) return const SizedBox();

      // group by sellerId
      final groups = <String, List<CartItemModel>>{};
      for (final item in cartItems) {
        final product = controller.productById(item.productId);
        final sellerId = product?.sellerId ?? 'unknown';
        groups.putIfAbsent(sellerId, () => []).add(item);
      }

      return Column(
        children: groups.entries.toList().asMap().entries.map((e) {
          final idx = e.key;
          final entry = e.value;
          final sellerId = entry.key;
          final items = entry.value;
          final seller = main.sellerById(sellerId);
          final sellerName = seller?.name ?? 'Toko';

          return Column(
            children: [
              if (idx > 0) const SizedBox(height: 8),
              Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Row(
                    children: [
                      _SellerAvatar(seller: seller),
                      const SizedBox(width: 8),
                      Text(
                        sellerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: kText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                // Products
                ...items.map((item) {
                  final product = controller.productById(item.productId);
                  return _ProductRow(item: item, product: product);
                }),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                // Shipping row
                _ShippingRow(
                  deliveryFee: controller.deliveryFeeForSeller(sellerId),
                ),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                // Subtotal
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total ${items.length} Produk',
                        style: const TextStyle(fontSize: 13, color: kSubtext),
                      ),
                      Text(
                        _fmt(
                          items.fold(0.0, (s, i) => s + i.price * i.quantity),
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                // Voucher
                _TapRow(label: 'Voucher Toko', hint: 'Gunakan/ masukkan kode'),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                // Note
                _TapRow(label: 'Pesan untuk Penjual', hint: 'Tinggalkan pesan'),
              ],
            ),
          ),
            ],
          );
        }).toList(),
      );
    });
  }

  String _fmt(double p) =>
      'Rp${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

class _SellerAvatar extends StatelessWidget {
  final SellerModel? seller;
  const _SellerAvatar({required this.seller});

  @override
  Widget build(BuildContext context) {
    final url = seller?.avatarUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: url != null
          ? Image.asset(
              url,
              width: 24,
              height: 24,
              fit: BoxFit.cover,
              errorBuilder: (_, e, s) => _fallback(),
            )
          : _fallback(),
    );
  }

  Widget _fallback() => Container(
        width: 24,
        height: 24,
        color: const Color(0xFFF0F0F0),
        child: const Icon(Icons.storefront_outlined, size: 14, color: kSubtext),
      );
}

class _ProductRow extends StatelessWidget {
  final CartItemModel item;
  final ProductModel? product;
  const _ProductRow({required this.item, required this.product});

  @override
  Widget build(BuildContext context) {
    final name = product?.name ?? item.productId;
    final brand = product?.brand ?? '';
    final originalPrice = product?.originalPrice ?? item.price;
    final hasDiscount = originalPrice > item.price;

    Color thumbColor = kPrimaryLight;
    if (product?.colorHex != null) {
      try {
        thumbColor = Color(
          int.parse(product!.colorHex.replaceFirst('#', '0xFF')),
        );
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product != null && product!.imageUrls.isNotEmpty
                ? Image.asset(
                    product!.imageUrls.first,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) =>
                        _ColorBox(color: thumbColor, size: 72),
                  )
                : _ColorBox(color: thumbColor, size: 72),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF333333),
                    height: 1.4,
                  ),
                ),
                if (brand.isNotEmpty)
                  Text(
                    brand,
                    style: const TextStyle(fontSize: 12, color: kSubtext),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _fmt(item.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimary,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 6),
                      Text(
                        _fmt(originalPrice),
                        style: const TextStyle(
                          fontSize: 12,
                          color: kSubtext,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      'x${item.quantity}',
                      style: const TextStyle(fontSize: 13, color: kSubtext),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double p) =>
      'Rp${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

class _ColorBox extends StatelessWidget {
  final Color color;
  final double size;
  const _ColorBox({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, color: color);
  }
}

class _ShippingRow extends StatelessWidget {
  final double deliveryFee;
  const _ShippingRow({required this.deliveryFee});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kurir Regular',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kText,
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 14,
                    color: Color(0xFF00B09B),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Estimasi tiba 2-3 hari',
                    style: TextStyle(fontSize: 12, color: Color(0xFF00B09B)),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Rp${deliveryFee.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kText,
            ),
          ),
        ],
      ),
    );
  }
}

void _showAllPayments(CheckoutController controller) {
  Get.bottomSheet(
    DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: kText,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Expanded(
              child: Obx(() => ListView.separated(
                    controller: scrollController,
                    itemCount: controller.paymentMethods.length,
                    separatorBuilder: (_, i) => const Divider(
                      height: 1,
                      indent: 64,
                      color: Color(0xFFF0F0F0),
                    ),
                    itemBuilder: (_, idx) {
                      final method = controller.paymentMethods[idx];
                      final isSelected =
                          controller.selectedPaymentIndex.value == idx;
                      return InkWell(
                        onTap: () {
                          controller.selectedPaymentIndex.value = idx;
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(
                                  method.type == 'bank'
                                      ? Icons.account_balance_outlined
                                      : method.type == 'qris'
                                          ? Icons.qr_code_2
                                          : Icons.wallet_outlined,
                                  size: 14,
                                  color: kSubtext,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method.label,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: kText,
                                      ),
                                    ),
                                    if ((method.number ?? '').isNotEmpty)
                                      Text(
                                        method.number!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: kSubtext,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              _CheckRadio(selected: isSelected),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

class _TapRow extends StatelessWidget {
  final String label;
  final String hint;
  const _TapRow({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: kText)),
          Row(
            children: [
              Text(hint, style: const TextStyle(fontSize: 13, color: kSubtext)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 16, color: kSubtext),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Payment Section ──────────────────────────────────────────────────────────

class _PaymentSection extends StatelessWidget {
  final CheckoutController controller;
  const _PaymentSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.paymentMethods.isEmpty) return const SizedBox();
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: kText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showAllPayments(controller),
                    child: const Row(
                      children: [
                        Text(
                          'Lihat Semua',
                          style: TextStyle(fontSize: 13, color: kSubtext),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right, size: 16, color: kSubtext),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (controller.selectedPayment != null)
              _PaymentOption(
                method: controller.selectedPayment!,
                isSelected: true,
                onTap: () => _showAllPayments(controller),
                showDivider: false,
              ),
            const SizedBox(height: 4),
          ],
        ),
      );
    });
  }
}

class _PaymentOption extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _PaymentOption({
    required this.method,
    required this.isSelected,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    method.type == 'bank'
                        ? Icons.account_balance_outlined
                        : method.type == 'ewallet'
                        ? Icons.wallet_outlined
                        : Icons.qr_code_2,
                    size: 14,
                    color: kSubtext,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kText,
                        ),
                      ),
                      if ((method.number ?? method.last4 ?? '').isNotEmpty)
                        Text(
                          method.number ?? method.last4 ?? '',
                          style: const TextStyle(fontSize: 12, color: kSubtext),
                        ),
                    ],
                  ),
                ),
                _CheckRadio(selected: isSelected),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 64, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

class _CheckRadio extends StatelessWidget {
  final bool selected;
  const _CheckRadio({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? kPrimary : Colors.transparent,
        border: Border.all(
          color: selected ? kPrimary : const Color(0xFFCCCCCC),
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, color: Colors.white, size: 14)
          : null,
    );
  }
}

// ── Summary Section ──────────────────────────────────────────────────────────

class _SummarySection extends StatelessWidget {
  final CheckoutController controller;
  const _SummarySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rincian Pembayaran',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: kText,
              ),
            ),
            const SizedBox(height: 12),
            _SummaryRow('Subtotal Pesanan', controller.subtotal),
            const SizedBox(height: 8),
            _SummaryRow('Subtotal Pengiriman', controller.totalDeliveryFee),
            const SizedBox(height: 8),
            _SummaryRow('Biaya Layanan', controller.serviceFee),
            if (controller.isReady.value && controller.savings > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Hemat',
                    style: TextStyle(fontSize: 13, color: Color(0xFF00A86B)),
                  ),
                  Text(
                    '-${_fmt(controller.savings)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF00A86B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF0F0F0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kText,
                  ),
                ),
                Text(
                  _fmt(controller.total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double p) =>
      'Rp${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  const _SummaryRow(this.label, this.amount);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: kSubtext)),
        Text(
          'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
          style: const TextStyle(fontSize: 13, color: kText),
        ),
      ],
    );
  }
}

// ── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final CheckoutController controller;
  const _BottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 6,
        top: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 11, color: kSubtext),
                  ),
                  Text(
                    _fmt(controller.total),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: kPrimary,
                    ),
                  ),
                  if (controller.isReady.value && controller.savings > 0)
                    Text(
                      'Hemat ${_fmt(controller.savings)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF00A86B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Buat Pesanan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double p) =>
      'Rp${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}
