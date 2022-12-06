import 'dart:convert';

import 'package:flutter_chatgpt_api/src/models/models.dart';

class ConversationResponseEvent {
  final Message? message;
  final String conversationId;
  final String? error;

  ConversationResponseEvent({
    required this.message,
    required this.conversationId,
    required this.error,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message?.toMap(),
      'conversation_id': conversationId,
      'error': error,
    };
  }

  factory ConversationResponseEvent.fromMap(Map<String, dynamic> map) {
    return ConversationResponseEvent(
      message: map['message'] != null ? Message.fromMap(map['message']) : null,
      conversationId: map['conversation_id'] ?? '',
      error: map['error'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationResponseEvent.fromJson(String source) =>
      ConversationResponseEvent.fromMap(json.decode(source));
}
