import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';
import 'package:flutter_test/flutter_test.dart';

import 'clearance_token.dart';
import 'session_token.dart';

void main() {
  test('do basic prompt', () async {
    final api = ChatGPTApi(
        sessionToken: SESSION_TOKEN, clearanceToken: CLEARANCE_TOKEN);
    const prompt =
        'Write a python version of bubble sort. Do not include example usage.';

    var result = await api.sendMessage(prompt);

    // ignore: avoid_print
    print(result);
  });
}
