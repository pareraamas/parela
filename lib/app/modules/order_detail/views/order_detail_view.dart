import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/order_item_model.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/widgets/shimmer.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.order;
    final statusColor = _statusColor(order.status);
    final statusLabel = _statusLabel(order.status);
    final statusIcon = _statusIcon(order.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
              onPressed: Get.back,
            ),
            title: const Text(
              'Detail Pesanan',
              style: TextStyle(
                color: kText,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // ── Status Banner ─────────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 10),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _statusDesc(order.status),
                        style: const TextStyle(fontSize: 11, color: kSubtext),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Status Timeline ───────────────────────────────────────
                _StatusTimeline(order: order),

                const SizedBox(height: 8),

                // ── Order Info ────────────────────────────────────────────
                _InfoCard(
                  children: [
                    _InfoRow(label: 'No. Pesanan', value: order.id),
                    _InfoRow(label: 'Tanggal', value: order.date),
                    if (order.tracking.isNotEmpty)
                      _InfoRow(label: 'No. Resi', value: order.tracking),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Products ──────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: Text(
                          'Produk',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kText,
                          ),
                        ),
                      ),
                      Obx(() {
                        final loading = controller.isLoading.value;
                        final products = controller.orderProducts;
                        if (loading) {
                          return const ShimmerProductList(count: 2);
                        }
                        return Column(
                          children: order.items.map((item) {
                            final product = products.firstWhereOrNull(
                              (p) => p.id == item.productId,
                            );
                            return _ProductRow(
                              item: item,
                              imageUrl: product?.imageUrls.firstOrNull,
                              productColor: product?.color,
                            );
                          }).toList(),
                        );
                      }),
                      const Divider(height: 1, color: Color(0xFFF5F5F5)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${order.items.length} produk',
                              style: const TextStyle(
                                fontSize: 12,
                                color: kSubtext,
                              ),
                            ),
                            Text(
                              'Total: ${_fmt(order.total)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Address ───────────────────────────────────────────────
                Obx(() {
                  final addr = controller.address.value;
                  if (addr == null) return const SizedBox.shrink();
                  return _SectionCard(
                    title: 'Alamat Pengiriman',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: kPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addr.recipient,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kText,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                addr.fullAddress,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kSubtext,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 8),

                // ── Payment Summary ───────────────────────────────────────
                Obx(() {
                  final pay = controller.payment.value;
                  return _SectionCard(
                    title: 'Ringkasan Pembayaran',
                    child: Column(
                      children: [
                        if (pay != null)
                          _SummaryRow(
                            label: 'Metode Pembayaran',
                            value: pay.label,
                          ),
                        _SummaryRow(
                          label: 'Subtotal Produk',
                          value: _fmt(order.total * 0.9),
                        ),
                        _SummaryRow(
                          label: 'Ongkos Kirim',
                          value: _fmt(order.total * 0.1),
                        ),
                        const Divider(height: 20, color: Color(0xFFF0F0F0)),
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
                              _fmt(order.total),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: kPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // ── Action Button ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: _ActionButton(order: order),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(double p) =>
      'Rp${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  static Color _statusColor(String status) {
    switch (status) {
      case 'delivered':
      case 'completed':
        return const Color(0xFF2E7D32);
      case 'shipped':
        return const Color(0xFF1565C0);
      case 'processing':
        return const Color(0xFFF57C00);
      case 'waiting_payment':
        return const Color(0xFFE65100);
      case 'cancelled':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF757575);
    }
  }

  static String _statusLabel(String status) {
    switch (status) {
      case 'delivered':
      case 'completed':
        return 'Selesai';
      case 'shipped':
        return 'Dikirim';
      case 'processing':
        return 'Diproses';
      case 'waiting_payment':
        return 'Menunggu Pembayaran';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  static String _statusDesc(String status) {
    switch (status) {
      case 'delivered':
      case 'completed':
        return 'Pesanan telah diterima';
      case 'shipped':
        return 'Paket sedang dalam perjalanan';
      case 'processing':
        return 'Penjual sedang memproses pesanan';
      case 'waiting_payment':
        return 'Selesaikan pembayaranmu';
      case 'cancelled':
        return 'Pesanan telah dibatalkan';
      default:
        return '';
    }
  }

  static IconData _statusIcon(String status) {
    switch (status) {
      case 'delivered':
      case 'completed':
        return Icons.check_circle_outline_rounded;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'processing':
        return Icons.inventory_2_outlined;
      case 'waiting_payment':
        return Icons.access_time_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }
}

// ── Status Timeline ───────────────────────────────────────────────────────────

class _StatusTimeline extends StatelessWidget {
  final OrderModel order;
  const _StatusTimeline({required this.order});

  static const _steps = [
    (Icons.receipt_outlined, 'Dipesan'),
    (Icons.payments_outlined, 'Dibayar'),
    (Icons.inventory_2_outlined, 'Diproses'),
    (Icons.local_shipping_outlined, 'Dikirim'),
    (Icons.check_circle_outline_rounded, 'Selesai'),
  ];

  int get _activeIndex {
    switch (order.status) {
      case 'waiting_payment':
        return 0;
      case 'processing':
        return 2;
      case 'shipped':
        return 3;
      case 'delivered':
      case 'completed':
        return 4;
      case 'cancelled':
        return -1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (order.status == 'cancelled') return const SizedBox.shrink();
    final active = _activeIndex;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Pesanan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              // Connector Line Layer (aligned with the centers of circles)
              Positioned(
                left: 0,
                right: 0,
                top: 16, // Center vertical of the 32px height circle
                child: Row(
                  children: [
                    const Spacer(flex: 1),
                    ...List.generate(_steps.length - 1, (i) {
                      final done = i < active;
                      return Expanded(
                        flex: 2,
                        child: Container(
                          height: 2,
                          color: done ? kPrimary : const Color(0xFFEEEEEE),
                        ),
                      );
                    }),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
              // Steps Layer (Circles + Labels)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_steps.length, (i) {
                  final done = i <= active;
                  final isActive = i == active;
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: done ? kPrimary : const Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: kPrimary.withAlpha(80),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            _steps[i].$1,
                            size: 16,
                            color: done ? Colors.white : kSubtext,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _steps[i].$2,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: done
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: done ? kText : kSubtext,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Product Row ───────────────────────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  final OrderItemModel item;
  final String? imageUrl;
  final Color? productColor;
  const _ProductRow({required this.item, this.imageUrl, this.productColor});

  @override
  Widget build(BuildContext context) {
    final bg = productColor ?? kPrimaryLight;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: bg.withAlpha(40),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: bg.withAlpha(60)),
            ),
            clipBehavior: Clip.hardEdge,
            child: imageUrl != null
                ? Image.asset(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.shopping_bag_outlined,
                      color: kPrimary,
                      size: 24,
                    ),
                  )
                : const Icon(
                    Icons.shopping_bag_outlined,
                    color: kPrimary,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.variant,
                  style: const TextStyle(fontSize: 11, color: kSubtext),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'x${item.quantity}',
                      style: const TextStyle(fontSize: 12, color: kSubtext),
                    ),
                    Text(
                      _fmt(item.price),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kPrimary,
                      ),
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

  static String _fmt(double p) =>
      'Rp${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

// ── Section Card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Info Card ─────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: kSubtext),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kText,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: kSubtext)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kText,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final OrderModel order;
  const _ActionButton({required this.order});

  @override
  Widget build(BuildContext context) {
    if (order.status == 'cancelled') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.shopping_bag_outlined, size: 18),
          label: const Text('Beli Lagi'),
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }
    if (order.status == 'delivered' || order.status == 'completed') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.rate_review_outlined, size: 16),
              label: const Text('Beri Ulasan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: kPrimary,
                side: const BorderSide(color: kPrimary),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_bag_outlined, size: 16),
              label: const Text('Beli Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (order.status == 'shipped') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: const Text('Konfirmasi Penerimaan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
