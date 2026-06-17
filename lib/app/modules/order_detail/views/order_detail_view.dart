import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.order;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
          onPressed: Get.back,
        ),
        title: Text(
          order.id,
          style: const TextStyle(
            color: kText,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _Card(
              title: 'Order Status',
              child: Column(
                children: List.generate(
                  controller.statusSteps.length,
                  (i) => _StatusStep(
                    label: controller.statusSteps[i],
                    isDone: i <= order.statusIndex,
                    isLast: i == controller.statusSteps.length - 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              title: 'Items',
              child: Column(
                children: controller.orderProducts.map((p) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: p.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.image, color: kPrimary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.brand,
                                style: const TextStyle(
                                  color: kSubtext,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                p.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: kText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Rp ${p.formattedPrice}',
                          style: const TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              title: 'Delivery Address',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.address.recipient,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.address.fullAddress,
                    style: const TextStyle(color: kSubtext, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              title: 'Payment & Total',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment',
                        style: TextStyle(color: kSubtext, fontSize: 13),
                      ),
                      Text(
                        controller.payment.label,
                        style: const TextStyle(
                          color: kText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kText,
                        ),
                      ),
                      Text(
                        'Rp ${order.formattedTotal}',
                        style: const TextStyle(
                          color: kPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: kText,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isLast;
  const _StatusStep({
    required this.label,
    required this.isDone,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDone ? kPrimary : kBackground,
                shape: BoxShape.circle,
                border: isDone ? null : Border.all(color: kSubtext),
              ),
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isDone ? kPrimary : kBackground,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            label,
            style: TextStyle(
              color: isDone ? kText : kSubtext,
              fontWeight: isDone ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
