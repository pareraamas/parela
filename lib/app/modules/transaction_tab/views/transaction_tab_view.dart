import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/mock/mock_database.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';
import 'package:parela/app/modules/main/widgets/app_header.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import 'package:parela/app/widgets/shimmer.dart';
import '../controllers/transaction_tab_controller.dart';

class TransactionTab extends GetView<TransactionTabController> {
  const TransactionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(title: 'Transaksi'),
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Summary card — scrolls away
              SliverToBoxAdapter(child: _SummaryCard(controller: controller)),

              // Chip bar — sticky
              SliverPersistentHeader(
                pinned: true,
                delegate: _ChipBarDelegate(controller),
              ),
              SliverToBoxAdapter(child: Divider(color: kBackground, height: 4)),
              // Order list
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const ShimmerOrderList();
                  }
                  final list = controller.filteredOrders;
                  if (list.isEmpty) return const _EmptyState();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                    child: Column(
                      children: list
                          .map(
                            (o) => _OrderCard(order: o, controller: controller),
                          )
                          .toList(),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Summary Card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final TransactionTabController controller;
  const _SummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/public/banners/summary_card_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.auto_awesome,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Ringkasan Belanja',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (Get.find<MainController>().isLoggedIn.value) {
                    Get.toNamed(Routes.NOTIFICATIONS);
                  } else {
                    Get.toNamed(Routes.LOGIN);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF5C1233),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Obx(() {
              final orders = controller.orders;
              final spent = orders.fold(0.0, (s, o) => s + o.total);
              return IntrinsicHeight(
                child: Row(
                  children: [
                    _StatItem(
                      imagePath:
                          'assets/public/banners/summary_icon_orders.png',
                      value: '${orders.length}',
                      label: 'Total Pesanan',
                      valueSuffix: ' pcs',
                    ),
                    VerticalDivider(
                      width: 24,
                      thickness: 1,
                      color: const Color(0xFF5C1233).withOpacity(0.15),
                    ),
                    _StatItem(
                      imagePath: 'assets/public/banners/summary_icon_spent.png',
                      value: _fmtShort(spent),
                      label: 'Total Belanja',
                    ),
                    VerticalDivider(
                      width: 24,
                      thickness: 1,
                      color: const Color(0xFF5C1233).withOpacity(0.15),
                    ),
                    _StatItem(
                      imagePath: 'assets/public/banners/summary_icon_saved.png',
                      value: _fmtShort(spent * 0.082),
                      label: 'Total Hemat',
                      valueColor: const Color(0xFF2E7D32),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static String _fmtShort(double v) {
    if (v >= 1000000) return 'Rp${(v / 1000000).toStringAsFixed(1)}jt';
    if (v >= 1000) return 'Rp${(v / 1000).toStringAsFixed(0)}rb';
    return 'Rp${v.toStringAsFixed(0)}';
  }
}

class _StatItem extends StatelessWidget {
  final String imagePath;
  final String value;
  final String label;
  final String? valueSuffix;
  final Color? valueColor;

  const _StatItem({
    required this.imagePath,
    required this.value,
    required this.label,
    this.valueSuffix,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(imagePath, width: 28, height: 28, fit: BoxFit.contain),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? const Color(0xFF5C1233),
                  ),
                ),
                if (valueSuffix != null)
                  TextSpan(
                    text: valueSuffix,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color:
                          valueColor?.withOpacity(0.8) ??
                          const Color(0xFF5C1233).withOpacity(0.8),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5C1233),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip Bar Delegate ─────────────────────────────────────────────────────────

class _ChipBarDelegate extends SliverPersistentHeaderDelegate {
  final TransactionTabController controller;
  const _ChipBarDelegate(this.controller);

  static const _h = 52.0;

  @override
  double get minExtent => _h;
  @override
  double get maxExtent => _h;

  IconData _tabIcon(String tab) {
    switch (tab) {
      case 'Semua':
        return Icons.all_inbox_outlined;
      case 'Menunggu':
        return Icons.hourglass_empty_outlined;
      case 'Diproses':
        return Icons.sync_outlined;
      case 'Dikirim':
        return Icons.local_shipping_outlined;
      case 'Selesai':
        return Icons.check_circle_outline_rounded;
      case 'Dibatalkan':
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Colors.white,
      elevation: shrinkOffset > 0 ? 2 : 0,
      shadowColor: Colors.black12,
      child: Obx(() {
        final currentTab = controller.selectedTab.value;
        return SizedBox(
          height: _h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: TransactionTabController.tabs.length,
            separatorBuilder: (_, i) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final tab = TransactionTabController.tabs[i];
              final selected = currentTab == tab;
              return GestureDetector(
                onTap: () => controller.selectedTab.value = tab,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? kPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? kPrimary : const Color(0xFFDDDDDD),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _tabIcon(tab),
                        size: 15,
                        color: selected ? Colors.white : kSubtext,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tab,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected ? Colors.white : kSubtext,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  @override
  bool shouldRebuild(covariant _ChipBarDelegate old) => false;
}

// ── Order Card ────────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final TransactionTabController controller;

  const _OrderCard({required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    final color = controller.statusColor(order.status);
    final label = controller.statusLabel(order.status);

    return GestureDetector(
      onTap: () => controller.goToDetail(order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
              decoration: BoxDecoration(color: color.withOpacity(.07)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: color,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.date,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: color.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          controller.statusIcon(order.status),
                          size: 11,
                          color: color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),

            // Items
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                children: order.items.take(2).map((item) {
                  final productList = MockDatabase.instance.products.where(
                    (p) => p.id == item.productId,
                  );
                  final imageUrl = productList.isNotEmpty
                      ? productList.first.imageUrls.firstOrNull
                      : null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(1),
                          ),
                          child: imageUrl != null
                              ? Image.asset(
                                  imageUrl,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 14,
                                  color: kSubtext,
                                ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${item.productName} — ${item.variant}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'x${item.quantity}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: kSubtext,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Icon(
                    Icons.widgets_outlined,
                    size: 14,
                    color: kSubtext.withOpacity(0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${order.items.length} produk',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: kSubtext,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _fmt(order.total),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: kPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 10, color: color),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double p) =>
      'Rp${p.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kBackground.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: kPrimary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pesanan kamu akan muncul di sini',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: kSubtext,
            ),
          ),
        ],
      ),
    );
  }
}
