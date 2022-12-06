import 'dart:convert';

import 'package:flutter_chatgpt_api/src/models/models.dart';

class ConversationBody {
  final String? action;
  final String? conversationId;
  final List<Prompt>? messages;
  final String model;
  final String parentMessageId;

  ConversationBody({
    required this.action,
    required this.conversationId,
    required this.messages,
    required this.model,
    required this.parentMessageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'conversation_id': conversationId,
      'messages': messages?.map((x) => x.toMap()).toList(),
      'model': model,
      'parent_message_id': parentMessageId,
    };
  }

  factory ConversationBody.fromMap(Map<String, dynamic> map) {
    return ConversationBody(
      action: map['action'],
      conversationId: map['conversation_id'],
      messages: map['messages'] != null
          ? List<Prompt>.from(map['messages']?.map((x) => Prompt.fromMap(x)))
          : null,
      model: map['model'] ?? '',
      parentMessageId: map['parent_message_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationBody.fromJson(String source) =>
      ConversationBody.fromMap(json.decode(source));
}
