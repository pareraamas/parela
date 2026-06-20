class PaymentMethodModel {
  final String id;
  final String label;
  final String type;
  final String? number;
  final String? last4;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.label,
    required this.type,
    this.number,
    this.last4,
    required this.isDefault,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> m) =>
      PaymentMethodModel(
        id: m['id'] as String,
        label: m['label'] as String,
        type: m['type'] as String,
        number: m['number'] as String?,
        last4: m['last4'] as String?,
        isDefault: (m['isDefault'] as bool?) ?? false,
      );

  factory PaymentMethodModel.fromJson(Map<String, dynamic> j) =>
      PaymentMethodModel(
        id: j['id'] as String,
        label: j['label'] as String,
        type: j['type'] as String,
        last4: j['last4'] as String?,
        isDefault: (j['is_default'] as bool?) ?? false,
      );
}
