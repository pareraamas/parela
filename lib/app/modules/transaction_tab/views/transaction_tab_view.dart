import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/modules/main/widgets/app_header.dart';
import 'package:parela/app/modules/transaction_tab/controllers/transaction_tab_controller.dart';
import 'package:parela/app/routes/app_pages.dart';
import 'package:parela/app/theme/app_colors.dart';

class TransactionTab extends GetView<TransactionTabController> {
  const TransactionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(title: 'My Orders'),
        const _StatusFilterRow(),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: kPrimary));
            }
            if (controller.orders.isEmpty) return const _EmptyOrders();
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.orders.length,
              itemBuilder: (_, i) => _OrderCard(order: controller.orders[i]),
            );
          }),
        ),
      ],
    );
  }
}

class _StatusFilterRow extends StatefulWidget {
  const _StatusFilterRow();

  @override
  State<_StatusFilterRow> createState() => _StatusFilterRowState();
}

class _StatusFilterRowState extends State<_StatusFilterRow> {
  int _selected = 0;
  final _filters = const ['All', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filters.length,
          itemBuilder: (_, i) {
            final isSelected = i == _selected;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimary : kBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : kSubtext,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'shipped':
        return const Color(0xFF2196F3);
      case 'processing':
      case 'waiting_payment':
        return const Color(0xFFFF9800);
      case 'cancelled':
        return Colors.red;
      default:
        return kSubtext;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.ORDER_DETAIL, arguments: order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kText),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(order.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: _statusColor(order.status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(order.date, style: const TextStyle(color: kSubtext, fontSize: 12)),
            const SizedBox(height: 12),
            const Divider(height: 1, color: kBackground),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 16, color: kSubtext),
                    const SizedBox(width: 4),
                    Text(
                      '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                      style: const TextStyle(color: kSubtext, fontSize: 13),
                    ),
                  ],
                ),
                Text(
                  'Rp ${_fmt(order.total)}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: kPrimary, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double price) => price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: kPrimaryLight),
          SizedBox(height: 16),
          Text(
            'No orders yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kText),
          ),
          SizedBox(height: 8),
          Text('Your order history will appear here', style: TextStyle(color: kSubtext)),
        ],
      ),
    );
  }
}
