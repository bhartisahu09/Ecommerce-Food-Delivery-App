class UserModel {
  final String id;
  String name;
  String email;
  final List<String> favorites;
  String? imagePath;
  String? phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.favorites,
    this.imagePath,
    this.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      favorites: List<String>.from(map['favorites'] ?? []),
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'favorites': favorites,
    };
  }
}