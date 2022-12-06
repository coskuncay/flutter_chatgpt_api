class ModerationsResult {
  final bool flagged;
  final bool blocked;
  final String moderationId;

  ModerationsResult({
    required this.flagged,
    required this.blocked,
    required this.moderationId,
  });
}
