import 'dart:convert';

class ChatResponse {
  final String message;
  final String messageId;
  final String conversationId;

  ChatResponse({
    required this.message,
    required this.messageId,
    required this.conversationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'message_id': messageId,
      'conversation_id': conversationId,
    };
  }

  factory ChatResponse.fromMap(Map<String, dynamic> map) {
    return ChatResponse(
      message: map['message'] ?? '',
      messageId: map['message_id'] ?? '',
      conversationId: map['conversation_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatResponse.fromJson(String source) =>
      ChatResponse.fromMap(json.decode(source));
}
