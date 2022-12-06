import 'dart:convert';

import 'package:flutter_chatgpt_api/src/models/models.dart';

class SessionResult {
  final User user;
  final String expires;
  final String accessToken;

  SessionResult({
    required this.user,
    required this.expires,
    required this.accessToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'expires': expires,
      'accessToken': accessToken,
    };
  }

  factory SessionResult.fromMap(Map<String, dynamic> map) {
    return SessionResult(
      user: User.fromMap(map['user']),
      expires: map['expires'] ?? '',
      accessToken: map['accessToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionResult.fromJson(String source) =>
      SessionResult.fromMap(json.decode(source));
}
