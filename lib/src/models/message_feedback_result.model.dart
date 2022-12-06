enum MessageFeedbackRating {
  thumbsUp,
  thumbsDown,
}

class MessageFeedbackResult {
  final String messageId;
  final String conversationId;
  final String userId;
  final MessageFeedbackRating rating;
  final String? text;

  MessageFeedbackResult({
    required this.messageId,
    required this.conversationId,
    required this.userId,
    required this.rating,
    required this.text,
  });
}
