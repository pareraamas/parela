class PaymentMethodModel {
  final String id;
  final String label;
  final String type;
  final String number;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.label,
    required this.type,
    required this.number,
    required this.isDefault,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> m) =>
      PaymentMethodModel(
        id: m['id'] as String,
        label: m['label'] as String,
        type: m['type'] as String,
        number: m['number'] as String,
        isDefault: m['isDefault'] as bool,
      );
}
