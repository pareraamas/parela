class OrderItemModel {
  final String productId;
  final String productName;
  final String variant;
  final String? imageUrl;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.variant,
    this.imageUrl,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> j) => OrderItemModel(
        productId: j['product_id'] as String,
        productName: (j['product_name'] as String?) ?? '',
        variant: (j['variant'] as String?) ?? '',
        imageUrl: j['image_url'] as String?,
        quantity: (j['quantity'] as int?) ?? 1,
        price: (j['price'] as num? ?? j['unit_price'] as num? ?? 0).toDouble(),
      );
}
