enum AvailableModerationModels {
  textModerationPlayground,
}

class ModerationsBody {
  final String input;
  final AvailableModerationModels model;

  ModerationsBody({
    required this.input,
    required this.model,
  });
}
