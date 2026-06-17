class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final bool verified;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.verified,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      verified: verified,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'verified': verified,
      };

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as String,
        name: m['name'] as String,
        email: m['email'] as String,
        phone: m['phone'] as String,
        address: m['address'] as String,
        verified: m['verified'] as bool,
      );
}
