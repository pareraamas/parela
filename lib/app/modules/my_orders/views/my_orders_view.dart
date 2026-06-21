import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────────────────
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
              'Pesanan Saya',
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

          // ── Summary card ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() => _SummaryCard(controller: controller)),
          ),

          // ── Sticky chip bar ──────────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _ChipBarDelegate(controller),
          ),

          // ── Order list ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              final list = controller.filteredOrders;
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(
                    child: CircularProgressIndicator(color: kPrimary),
                  ),
                );
              }
              if (list.isEmpty) return const _EmptyState();
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                child: Column(
                  children: list
                      .map((o) => _OrderCard(
                            order: o,
                            controller: controller,
                          ))
                      .toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Summary Card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final MyOrdersController controller;
  const _SummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ringkasan Belanja',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kSubtext,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: kText,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              children: [
                _StatItem(
                  value: '${controller.totalOrders}',
                  label: 'Total Pesanan',
                  valueSuffix: ' pesanan',
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                ),
                _StatItem(
                  value: _fmtShort(controller.totalSpent),
                  label: 'Total Belanja',
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                ),
                _StatItem(
                  value: _fmtShort(controller.totalSaved),
                  label: 'Total Hemat',
                  valueColor: const Color(0xFF2E7D32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtShort(double v) {
    if (v >= 1000000) {
      return 'Rp${(v / 1000000).toStringAsFixed(1)}jt';
    }
    if (v >= 1000) {
      return 'Rp${(v / 1000).toStringAsFixed(0)}rb';
    }
    return 'Rp${v.toStringAsFixed(0)}';
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final String? valueSuffix;
  final Color? valueColor;

  const _StatItem({
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? kText,
                  ),
                ),
                if (valueSuffix != null)
                  TextSpan(
                    text: valueSuffix,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: valueColor ?? kSubtext,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: kSubtext),
          ),
        ],
      ),
    );
  }
}

// ── Chip Bar Delegate ─────────────────────────────────────────────────────────

class _ChipBarDelegate extends SliverPersistentHeaderDelegate {
  final MyOrdersController controller;
  const _ChipBarDelegate(this.controller);

  static const _h = 52.0;

  @override
  double get minExtent => _h;

  @override
  double get maxExtent => _h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      elevation: shrinkOffset > 0 ? 2 : 0,
      shadowColor: Colors.black12,
      child: Obx(() => SizedBox(
            height: _h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: MyOrdersController.tabs.length,
              separatorBuilder: (_, i) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final tab = MyOrdersController.tabs[i];
                final selected = controller.selectedTab.value == tab;
                return GestureDetector(
                  onTap: () => controller.selectedTab.value = tab,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? kPrimary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? kPrimary : const Color(0xFFDDDDDD),
                      ),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selected ? Colors.white : kSubtext,
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }

  @override
  bool shouldRebuild(covariant _ChipBarDelegate old) => false;
}

// ── Order Card ────────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final MyOrdersController controller;

  const _OrderCard({required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    final color = controller.statusColor(order.status);
    final label = controller.statusLabel(order.status);

    return GestureDetector(
      onTap: () => controller.goToDetail(order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: kSubtext,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),

            // Items
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: order.items.take(2).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
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
                              fontSize: 13,
                              color: Color(0xFF444444),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'x${item.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Text(
                    '${order.items.length} produk',
                    style: const TextStyle(fontSize: 12, color: kSubtext),
                  ),
                  const Spacer(),
                  Text(
                    _fmt(order.total),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 16, color: kSubtext),
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
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 56, color: Color(0xFFDDDDDD)),
          SizedBox(height: 16),
          Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: kSubtext,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Pesanan kamu akan muncul di sini',
            style: TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
          ),
        ],
      ),
    );
  }
}
