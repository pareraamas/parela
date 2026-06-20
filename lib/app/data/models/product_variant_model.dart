class ProductVariantModel {
  final String id;
  final int color;
  final String colorName;
  final String size;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final int stock;
  final String sku;
  final String? imageUrl;

  const ProductVariantModel({
    required this.id,
    required this.color,
    required this.colorName,
    required this.size,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.stock,
    required this.sku,
    this.imageUrl,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> j) => ProductVariantModel(
        id: j['id'] as String,
        color: (j['color'] as int?) ?? 0xFF000000,
        colorName: (j['color_name'] as String?) ?? '',
        size: (j['size'] as String?) ?? 'One Size',
        price: (j['price'] as num).toDouble(),
        originalPrice: (j['original_price'] as num? ?? j['price'] as num).toDouble(),
        discountPercent: (j['discount_percent'] as int?) ?? 0,
        stock: (j['stock'] as int?) ?? 0,
        sku: (j['sku'] as String?) ?? '',
        imageUrl: j['image_url'] as String?,
      );
}
