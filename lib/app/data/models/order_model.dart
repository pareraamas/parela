import 'package:parela/app/data/models/order_item_model.dart';

class OrderModel {
  final String id;
  final String? invoiceId;
  final String date;
  final String status;
  final int statusIndex;
  final double total;
  final List<OrderItemModel> items;
  final String tracking;
  final String? courier;
  final bool canReview;
  final bool canReturn;

  const OrderModel({
    required this.id,
    this.invoiceId,
    required this.date,
    required this.status,
    required this.statusIndex,
    required this.total,
    required this.items,
    required this.tracking,
    this.courier,
    this.canReview = false,
    this.canReturn = false,
  });

  String get formattedTotal => total
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  factory OrderModel.fromMap(Map<String, dynamic> m) => OrderModel(
        id: m['id'] as String,
        invoiceId: m['invoiceId'] as String?,
        date: m['date'] as String,
        status: m['status'] as String,
        statusIndex: (m['statusIndex'] as int?) ?? 0,
        total: (m['total'] as num).toDouble(),
        items: (m['items'] as List?)
                ?.map((i) => i is Map<String, dynamic>
                    ? OrderItemModel.fromJson(i)
                    : OrderItemModel(productId: i.toString(), productName: i.toString(), variant: '', quantity: 1, price: 0))
                .toList() ??
            [],
        tracking: (m['tracking'] as String?) ?? '',
        courier: m['courier'] as String?,
      );

  factory OrderModel.fromJson(Map<String, dynamic> j) {
    final statusMap = <String, int>{
      'waiting_payment': 0,
      'processing': 1,
      'shipped': 2,
      'delivered': 3,
      'completed': 4,
      'cancelled': -1,
      'return_requested': -2,
      'returned': -3,
    };
    final status = j['status'] as String? ?? '';
    return OrderModel(
      id: j['id'] as String,
      invoiceId: j['invoice_id'] as String?,
      date: (j['date'] as String?) ?? '',
      status: status,
      statusIndex: statusMap[status] ?? 0,
      total: (j['total'] as num? ?? 0).toDouble(),
      items: ((j['items'] as List?) ?? []).map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>)).toList(),
      tracking: (j['tracking_number'] as String?) ?? '-',
      courier: j['courier'] as String?,
      canReview: (j['can_review'] as bool?) ?? false,
      canReturn: (j['can_return'] as bool?) ?? false,
    );
  }
}
