class SellerModel {
  final String id;
  final String name;
  final double rating;
  final int productCount;
  final bool verified;
  final String location;

  const SellerModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.productCount,
    required this.verified,
    required this.location,
  });

  factory SellerModel.fromMap(Map<String, dynamic> m) => SellerModel(
        id: m['id'] as String,
        name: m['name'] as String,
        rating: (m['rating'] as num).toDouble(),
        productCount: m['productCount'] as int,
        verified: m['verified'] as bool,
        location: m['location'] as String,
      );
}
