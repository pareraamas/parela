import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/theme/app_colors.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kText, size: 20),
          onPressed: Get.back,
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: kText, fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _Section(
              title: 'Delivery Address',
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Change', style: TextStyle(color: kPrimary)),
              ),
              child: Obx(() {
                final addr = controller.addresses[controller.selectedAddressIndex.value];
                return _AddressCard(address: addr);
              }),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Payment Method',
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Change', style: TextStyle(color: kPrimary)),
              ),
              child: Obx(() {
                final pay = controller.paymentMethods[controller.selectedPaymentIndex.value];
                return _PaymentCard(method: pay);
              }),
            ),
            const SizedBox(height: 12),
            _Section(
              title: 'Order Summary',
              child: Obx(
                () => Column(
                  children: [
                    _SummaryRow('Subtotal', controller.subtotal),
                    const SizedBox(height: 6),
                    _SummaryRow('Delivery Fee', controller.deliveryFee),
                    const Divider(color: kBackground, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: kText,
                          ),
                        ),
                        Text(
                          'Rp ${_fmt(controller.total)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: kPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: Colors.white,
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Obx(
                    () => Text(
                      'Place Order • Rp ${_fmt(controller.total)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _fmt(double p) => p.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Section({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: kText,
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on_outlined, color: kPrimary, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    address.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: kText,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (address.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: kPrimaryLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Default',
                        style: TextStyle(
                          color: kPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                address.recipient,
                style: const TextStyle(color: kText, fontSize: 13),
              ),
              Text(
                address.fullAddress,
                style: const TextStyle(color: kSubtext, fontSize: 12, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final PaymentMethodModel method;
  const _PaymentCard({required this.method});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kPrimaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            method.type == 'bank' ? Icons.account_balance : Icons.wallet,
            color: kPrimary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              method.label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: kText,
              ),
            ),
            Text(
              method.number ?? method.last4 ?? '',
              style: const TextStyle(color: kSubtext, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
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
        Text(label, style: const TextStyle(color: kSubtext, fontSize: 13)),
        Text(
          'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
          style: const TextStyle(color: kText, fontSize: 13),
        ),
      ],
    );
  }
}
