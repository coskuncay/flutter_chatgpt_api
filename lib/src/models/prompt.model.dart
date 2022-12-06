import 'dart:convert';

import 'package:flutter_chatgpt_api/src/models/models.dart';

class Prompt {
  final PromptContent content;
  final String id;
  final String role;

  Prompt({
    required this.content,
    required this.id,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content.toMap(),
      'id': id,
      'role': role,
    };
  }

  factory Prompt.fromMap(Map<String, dynamic> map) {
    return Prompt(
      content: PromptContent.fromMap(map['content']),
      id: map['id'] ?? '',
      role: map['role'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Prompt.fromJson(String source) => Prompt.fromMap(json.decode(source));
}
