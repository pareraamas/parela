class OrderModel {
  final String id;
  final String date;
  final String status;
  final int statusIndex;
  final double total;
  final List<String> items;
  final String tracking;

  const OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.statusIndex,
    required this.total,
    required this.items,
    required this.tracking,
  });

  String get formattedTotal => total
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  factory OrderModel.fromMap(Map<String, dynamic> m) => OrderModel(
        id: m['id'] as String,
        date: m['date'] as String,
        status: m['status'] as String,
        statusIndex: m['statusIndex'] as int,
        total: (m['total'] as num).toDouble(),
        items: List<String>.from(m['items'] as List),
        tracking: m['tracking'] as String,
      );
}
