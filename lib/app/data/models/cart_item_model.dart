class CartItemModel {
  final String? id;
  final String productId;
  final String? variantId;
  int quantity;
  final int color;
  final String size;
  final double price;

  CartItemModel({
    this.id,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.color,
    required this.size,
    required this.price,
  });

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        id: id,
        productId: productId,
        variantId: variantId,
        quantity: quantity ?? this.quantity,
        color: color,
        size: size,
        price: price,
      );

  double get subtotal => price * quantity;

  Map<String, dynamic> toMap() => {
        'id': id,
        'productId': productId,
        'variantId': variantId,
        'quantity': quantity,
        'color': color,
        'size': size,
        'price': price,
      };

  factory CartItemModel.fromMap(Map<String, dynamic> m) => CartItemModel(
        id: m['id'] as String?,
        productId: m['productId'] as String,
        variantId: m['variantId'] as String?,
        quantity: m['quantity'] as int,
        color: (m['color'] as int?) ?? 0xFF000000,
        size: (m['size'] as String?) ?? '',
        price: (m['price'] as num).toDouble(),
      );

  factory CartItemModel.fromJson(Map<String, dynamic> j) {
    final variant = j['variant'] as Map<String, dynamic>?;
    return CartItemModel(
      id: j['id'] as String?,
      productId: j['product_id'] as String,
      variantId: j['variant_id'] as String?,
      quantity: (j['quantity'] as int?) ?? 1,
      color: (variant?['color'] as int?) ?? 0xFF000000,
      size: (variant?['size'] as String?) ?? '',
      price: (variant?['price'] as num? ?? j['subtotal'] as num? ?? 0).toDouble() /
          ((j['quantity'] as int?) ?? 1),
    );
  }
}
