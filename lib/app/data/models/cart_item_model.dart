class CartItemModel {
  final String productId;
  int quantity;
  final int color;
  final String size;
  final double price;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.color,
    required this.size,
    required this.price,
  });

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        productId: productId,
        quantity: quantity ?? this.quantity,
        color: color,
        size: size,
        price: price,
      );

  double get subtotal => price * quantity;

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'quantity': quantity,
        'color': color,
        'size': size,
        'price': price,
      };

  factory CartItemModel.fromMap(Map<String, dynamic> m) => CartItemModel(
        productId: m['productId'] as String,
        quantity: m['quantity'] as int,
        color: m['color'] as int,
        size: m['size'] as String,
        price: (m['price'] as num).toDouble(),
      );
}
