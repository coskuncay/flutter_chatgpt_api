import 'dart:convert';

class PromptContent {
  final String contentType;
  final List<String> parts;

  PromptContent({
    required this.contentType,
    required this.parts,
  });

  Map<String, dynamic> toMap() {
    return {
      'content_type': contentType,
      'parts': parts,
    };
  }

  factory PromptContent.fromMap(Map<String, dynamic> map) {
    return PromptContent(
      contentType: map['content_type'] ?? '',
      parts: List<String>.from(map['parts']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromptContent.fromJson(String source) =>
      PromptContent.fromMap(json.decode(source));
}
