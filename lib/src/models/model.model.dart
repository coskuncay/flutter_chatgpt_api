import 'dart:convert';

class Model {
  final String slug;
  final int maxTokens;
  final bool isSpecial;

  Model({
    required this.slug,
    required this.maxTokens,
    required this.isSpecial,
  });

  Map<String, dynamic> toMap() {
    return {
      'slug': slug,
      'maxTokens': maxTokens,
      'isSpecial': isSpecial,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      slug: map['slug'] ?? '',
      maxTokens: map['maxTokens']?.toInt() ?? 0,
      isSpecial: map['isSpecial'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Model.fromJson(String source) => Model.fromMap(json.decode(source));
}
