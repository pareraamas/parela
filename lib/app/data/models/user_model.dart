class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final bool verified;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.verified,
    this.avatarUrl,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      verified: verified,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'verified': verified,
        'avatarUrl': avatarUrl,
      };

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as String,
        name: m['name'] as String,
        email: m['email'] as String,
        phone: (m['phone'] as String?) ?? '',
        address: (m['address'] as String?) ?? '',
        verified: (m['verified'] as bool?) ?? false,
        avatarUrl: m['avatarUrl'] as String?,
      );

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: j['id'] as String,
        name: j['name'] as String,
        email: j['email'] as String,
        phone: (j['phone'] as String?) ?? '',
        address: (j['address'] as String?) ?? '',
        verified: (j['verified'] as bool?) ?? false,
        avatarUrl: j['avatar_url'] as String?,
      );
}
