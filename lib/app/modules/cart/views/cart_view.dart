import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/widgets/cached_image.dart';
import '../controllers/cart_controller.dart';

// ─── Data carriers ────────────────────────────────────────────────────────────

class _Entry {
  final int index;
  final CartItemModel item;
  final ProductModel product;
  _Entry({required this.index, required this.item, required this.product});
}

class _SellerGroup {
  final SellerModel? seller;
  final String sellerId;
  final List<_Entry> entries;
  _SellerGroup({
    required this.seller,
    required this.sellerId,
    required this.entries,
  });
}

// ─── View ─────────────────────────────────────────────────────────────────────

class CartView extends GetView<CartController> {
  const CartView({super.key});

  List<_SellerGroup> _buildGroups() {
    final items = controller.main.cartItems;
    final products = controller.home.products;
    final map = <String, List<_Entry>>{};
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final product = products.firstWhereOrNull((p) => p.id == item.productId);
      if (product == null) continue;
      map.putIfAbsent(product.sellerId, () => []);
      map[product.sellerId]!.add(
        _Entry(index: i, item: item, product: product),
      );
    }
    return map.entries
        .map(
          (e) => _SellerGroup(
            sellerId: e.key,
            seller: controller.main.sellerById(e.key),
            entries: e.value,
          ),
        )
        .toList();
  }

  static String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kText,
            size: 18,
          ),
        ),
        title: Obx(
          () => Text(
            'Keranjang (${controller.main.cartItems.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        final items = controller.main.cartItems;
        if (items.isEmpty) return const _EmptyCart();

        final groups = _buildGroups();
        final selectedCount = controller.selectedCount;
        final selectedTotal = controller.selectedTotal;
        final selectedDiscount = controller.selectedDiscount;

        return Column(
          children: [
            // ── Selection bar ─────────────────────────────────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: selectedCount > 0
                  ? Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$selectedCount produk terpilih',
                            style: const TextStyle(
                              fontSize: 13,
                              color: kSubtext,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.removeSelected,
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // ── Item list ─────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: groups.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, gi) =>
                    _SellerGroupCard(group: groups[gi], ctrl: controller),
              ),
            ),

            // ── Bottom bar ────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              padding: EdgeInsets.fromLTRB(
                12,
                10,
                12,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: controller.toggleAll,
                    child: Row(
                      children: [
                        Obx(
                          () => _AnimCheckbox(checked: controller.allSelected),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Semua',
                          style: TextStyle(fontSize: 12, color: kText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: selectedCount > 0
                          ? () => _PromoSheet.show(
                              context,
                              controller,
                              selectedTotal,
                              selectedDiscount,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Rp ${_fmt(selectedTotal)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: kPrimary,
                                ),
                              ),
                              if (selectedCount > 0) ...[
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 16,
                                  color: kPrimary,
                                ),
                              ],
                            ],
                          ),
                          if (selectedCount > 0 && selectedDiscount > 0)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                'Hemat Rp ${_fmt(selectedDiscount)}',
                                key: ValueKey(selectedDiscount),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF43A047),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: selectedCount > 0
                          ? () => Get.toNamed(Routes.CHECKOUT)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        disabledBackgroundColor: kPrimaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        elevation: 0,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          selectedCount > 0 ? 'Beli ($selectedCount)' : 'Beli',
                          key: ValueKey(selectedCount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
}

// ─── Seller group card ────────────────────────────────────────────────────────

class _SellerGroupCard extends StatelessWidget {
  final _SellerGroup group;
  final CartController ctrl;
  const _SellerGroupCard({required this.group, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final seller = group.seller;
    final indices = group.entries.map((e) => e.index).toList();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seller header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: () => ctrl.selectGroup(
                      indices,
                      !indices.every(ctrl.selectedIndices.contains),
                    ),
                    child: _AnimCheckbox(
                      checked: indices.every(ctrl.selectedIndices.contains),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _SellerAvatar(seller: seller, sellerId: group.sellerId),
                const SizedBox(width: 6),
                if (seller?.isMall == true) ...[
                  _Badge(
                    label: 'Mall',
                    bg: const Color(0xFFFFEBEE),
                    fg: const Color(0xFFE53935),
                    icon: Icons.store_rounded,
                  ),
                  const SizedBox(width: 4),
                ] else if (seller?.isOfficial == true) ...[
                  _Badge(
                    label: 'Official',
                    bg: const Color(0xFFE3F2FD),
                    fg: const Color(0xFF1E88E5),
                    icon: Icons.verified_rounded,
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    seller?.name ?? group.sellerId,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (seller?.badges.contains('fast_shipping') == true)
                  const Text(
                    'GRATIS ONGKIR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00897B),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            indent: 12,
            endIndent: 12,
            color: kBackground,
          ),

          // Products — animated removal
          ...group.entries.map((e) => _ProductItem(entry: e, ctrl: ctrl)),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Product item row ─────────────────────────────────────────────────────────

class _ProductItem extends StatelessWidget {
  final _Entry entry;
  final CartController ctrl;
  const _ProductItem({required this.entry, required this.ctrl});

  static String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    final p = entry.product;
    final item = entry.item;
    final hasDiscount = p.originalPrice > p.price;
    final discountPct = p.discountPercent > 0
        ? p.discountPercent
        : ((p.originalPrice - p.price) / p.originalPrice * 100).round();

    return Obx(() {
      final isSelected = ctrl.isSelected(entry.index);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: GestureDetector(
                onTap: () => ctrl.toggle(entry.index),
                child: _AnimCheckbox(checked: isSelected),
              ),
            ),
            const SizedBox(width: 10),
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedImage(
                    url: p.imageUrls.isNotEmpty ? p.imageUrls.first : null,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    fallbackColor: p.color,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: const BoxDecoration(
                      color: Color(0xCC000000),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sisa 5',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: kText,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Variant chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Color(item.color),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                        Text(
                          item.size,
                          style: const TextStyle(fontSize: 11, color: kText),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 14,
                          color: kSubtext,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rp ${_fmt(item.price)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: kText,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          'Rp ${_fmt(p.originalPrice)}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: kSubtext,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: kSubtext,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$discountPct%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Delete + qty
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () => ctrl.removeAt(entry.index),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: kSubtext,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _QtyRow(
                        qty: item.quantity,
                        onDecrement: () =>
                            ctrl.updateQty(entry.index, item.quantity - 1),
                        onIncrement: () =>
                            ctrl.updateQty(entry.index, item.quantity + 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── Animated checkbox ────────────────────────────────────────────────────────

class _AnimCheckbox extends StatelessWidget {
  final bool checked;
  const _AnimCheckbox({required this.checked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked ? kPrimary : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: checked ? kPrimary : const Color(0xFFCCCCCC),
          width: 1.5,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: checked
            ? const Icon(
                Icons.check_rounded,
                key: ValueKey(true),
                size: 13,
                color: Colors.white,
              )
            : const SizedBox.shrink(key: ValueKey(false)),
      ),
    );
  }
}

// ─── Qty stepper ──────────────────────────────────────────────────────────────

class _QtyRow extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const _QtyRow({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement, left: true),
        Container(
          width: 36,
          height: 28,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Color(0xFFDDDDDD)),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(scale: anim, child: child),
            ),
            child: Text(
              '$qty',
              key: ValueKey(qty),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kText,
              ),
            ),
          ),
        ),
        _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement, left: false),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool left;
  const _QtyBtn({required this.icon, required this.onTap, required this.left});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: left
              ? const BorderRadius.horizontal(left: Radius.circular(6))
              : const BorderRadius.horizontal(right: Radius.circular(6)),
        ),
        child: Icon(icon, size: 14, color: kPrimary),
      ),
    );
  }
}

// ─── Seller avatar ────────────────────────────────────────────────────────────

class _SellerAvatar extends StatelessWidget {
  final SellerModel? seller;
  final String sellerId;
  const _SellerAvatar({required this.seller, required this.sellerId});

  @override
  Widget build(BuildContext context) {
    if (seller?.avatarUrl != null) {
      return ClipOval(
        child: CachedImage(
          url: seller!.avatarUrl,
          width: 20,
          height: 20,
          fit: BoxFit.cover,
          fallbackColor: kPrimaryLight,
        ),
      );
    }
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: kPrimaryLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          (seller?.name ?? sellerId)[0],
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: kPrimary,
          ),
        ),
      ),
    );
  }
}

// ─── Seller badge ─────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color bg, fg;
  final IconData icon;
  const _Badge({
    required this.label,
    required this.bg,
    required this.fg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: fg),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: kPrimaryLight,
          ),
          const SizedBox(height: 16),
          const Text(
            'Keranjang kosong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Yuk, mulai belanja produk pilihanmu',
            style: TextStyle(color: kSubtext, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: Get.back,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              elevation: 0,
            ),
            child: const Text('Lanjut Belanja'),
          ),
        ],
      ),
    );
  }
}

// ─── Promo detail bottom sheet ────────────────────────────────────────────────

class _PromoSheet extends StatelessWidget {
  final double total;
  final double discount;
  final double originalTotal;

  const _PromoSheet({
    required this.total,
    required this.discount,
    required this.originalTotal,
  });

  static void show(
    BuildContext context,
    CartController ctrl,
    double total,
    double discount,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _PromoSheet(
        total: total,
        discount: discount,
        originalTotal: total + discount,
      ),
    );
  }

  static String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        32 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rincian Promosi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kText,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close_rounded,
                  size: 22,
                  color: kSubtext,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: kBackground),
          const SizedBox(height: 12),
          _SheetRow(label: 'Total', value: 'Rp ${_fmt(originalTotal)}'),
          const SizedBox(height: 12),
          const Divider(height: 1, color: kBackground),
          const SizedBox(height: 12),
          if (discount > 0)
            _SheetRow(
              label: 'Diskon Produk',
              value: '-Rp ${_fmt(discount)}',
              valueColor: const Color(0xFFE53935),
            ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: kBackground),
          const SizedBox(height: 12),
          _SheetRow(
            label: 'Hemat',
            value: '-Rp ${_fmt(discount)}',
            labelBold: true,
            valueColor: const Color(0xFFE53935),
          ),
          const SizedBox(height: 8),
          _SheetRow(
            label: 'Jumlah Total',
            value: 'Rp ${_fmt(total)}',
            labelBold: true,
            valueBold: true,
          ),
          const SizedBox(height: 8),
          const Text(
            '*Harga untuk dibayar akan ditampilkan saat checkout',
            style: TextStyle(fontSize: 11, color: kSubtext),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  final String label;
  final String value;
  final bool labelBold;
  final bool valueBold;
  final Color? valueColor;

  const _SheetRow({
    required this.label,
    required this.value,
    this.labelBold = false,
    this.valueBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: kText,
            fontWeight: labelBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor ?? kText,
            fontWeight: valueBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
