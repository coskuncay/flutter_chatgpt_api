import 'package:flutter_chatgpt_api/src/models/message_feedback_result.model.dart';

enum MessageFeedbackTags {
  harmful,
  falseValue, // false is a reserved word
  notHelpful,
}

class MessageFeedbackBody {
  final String conversationId;
  final String messageId;
  final MessageFeedbackResult rating;
  final List<MessageFeedbackTags>? tags;
  final String? text;

  MessageFeedbackBody({
    required this.conversationId,
    required this.messageId,
    required this.rating,
    required this.tags,
    required this.text,
  });
}
