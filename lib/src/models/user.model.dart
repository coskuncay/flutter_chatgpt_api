import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String image;
  final String picture;
  final List<String> groups;
  final List<String> features;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.picture,
    required this.groups,
    required this.features,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'picture': picture,
      'groups': groups,
      'features': features,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      image: map['image'] ?? '',
      picture: map['picture'] ?? '',
      groups: List<String>.from(map['groups']),
      features: List<String>.from(map['features']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
