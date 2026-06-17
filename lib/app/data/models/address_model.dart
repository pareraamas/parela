class AddressModel {
  final String id;
  final String label;
  final String recipient;
  final String phone;
  final String street;
  final String city;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.recipient,
    required this.phone,
    required this.street,
    required this.city,
    required this.isDefault,
  });

  String get fullAddress => '$street, $city';

  factory AddressModel.fromMap(Map<String, dynamic> m) => AddressModel(
        id: m['id'] as String,
        label: m['label'] as String,
        recipient: m['recipient'] as String,
        phone: m['phone'] as String,
        street: m['street'] as String,
        city: m['city'] as String,
        isDefault: m['isDefault'] as bool,
      );
}
