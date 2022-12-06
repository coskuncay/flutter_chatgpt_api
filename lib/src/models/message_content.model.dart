import 'dart:convert';

class MessageContent {
  final String contentType;
  final List<String> parts;
  MessageContent({
    required this.contentType,
    required this.parts,
  });

  Map<String, dynamic> toMap() {
    return {
      'content_type': contentType,
      'parts': parts,
    };
  }

  factory MessageContent.fromMap(Map<String, dynamic> map) {
    return MessageContent(
      contentType: map['content_type'] ?? '',
      parts: List<String>.from(map['parts']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageContent.fromJson(String source) =>
      MessageContent.fromMap(json.decode(source));
}
