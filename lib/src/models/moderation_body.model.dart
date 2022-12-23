import 'dart:convert';

class ModerationsBody {
  final String input;
  final String model;

  ModerationsBody({
    required this.input,
    required this.model,
  });

  Map<String, dynamic> toMap() {
    return {
      'input': input,
      'model': model,
    };
  }

  String toJson() => json.encode(toMap());
}
