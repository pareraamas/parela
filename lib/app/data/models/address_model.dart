class AddressModel {
  final String id;
  final String label;
  final String recipient;
  final String phone;
  final String street;
  final String city;
  final String? province;
  final String? postalCode;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.recipient,
    required this.phone,
    required this.street,
    required this.city,
    this.province,
    this.postalCode,
    required this.isDefault,
  });

  String get fullAddress => '$street, $city';

  factory AddressModel.fromMap(Map<String, dynamic> m) => AddressModel(
        id: m['id'] as String,
        label: m['label'] as String,
        recipient: m['recipient'] as String,
        phone: (m['phone'] as String?) ?? '',
        street: m['street'] as String,
        city: m['city'] as String,
        province: m['province'] as String?,
        postalCode: m['postalCode'] as String?,
        isDefault: (m['isDefault'] as bool?) ?? false,
      );

  factory AddressModel.fromJson(Map<String, dynamic> j) => AddressModel(
        id: j['id'] as String,
        label: j['label'] as String,
        recipient: j['recipient'] as String,
        phone: (j['phone'] as String?) ?? '',
        street: j['street'] as String,
        city: j['city'] as String,
        province: j['province'] as String?,
        postalCode: j['postal_code'] as String?,
        isDefault: (j['is_default'] as bool?) ?? false,
      );
}
