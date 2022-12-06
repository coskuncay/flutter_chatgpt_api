import 'dart:convert';

import 'package:flutter_chatgpt_api/src/models/message_content.model.dart';

class Message {
  final String id;
  final MessageContent content;
  final String role;
  final String? user;
  //final dynamic endTurn;
  final double weight;
  final String recipient;
  //final dynamic metadata;

  Message({
    required this.id,
    required this.content,
    required this.role,
    required this.user,
    required this.weight,
    required this.recipient,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content.toMap(),
      'role': role,
      'user': user,
      'weight': weight,
      'recipient': recipient,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      content: MessageContent.fromMap(map['content']),
      role: map['role'] ?? '',
      user: map['user'],
      weight: map['weight']?.toDouble() ?? 0.0,
      recipient: map['recipient'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
