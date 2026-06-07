class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String imageUrl;
  final String referralCode;
  final int points;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl = '',
    this.referralCode = '',
    this.points = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      referralCode: map['referralCode'] ?? '',
      points: map['points'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'referralCode': referralCode,
      'points': points,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
