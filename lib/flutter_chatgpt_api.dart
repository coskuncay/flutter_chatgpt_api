library flutter_chatgpt_api;

import 'dart:convert';

import 'package:flutter_chatgpt_api/src/models/models.dart';
import 'package:flutter_chatgpt_api/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

part 'src/models/chat_message.model.dart';

class ChatGPTApi {
  String sessionToken;
  String? apiBaseUrl;
  String backendApiBaseUrl;
  String userAgent;

  final ExpiryMap<String, String> _accessTokenCache =
      ExpiryMap<String, String>();
  ChatGPTApi({
    required this.sessionToken,
    this.apiBaseUrl = 'https://chat.openai.com/api',
    this.backendApiBaseUrl = 'https://chat.openai.com/backend-api',
    this.userAgent = defaultUserAgent,
  });

  Future<ChatResponse> sendMessage(
    String message, {
    String? conversationId,
    String? parentMessageId,
  }) async {
    final accessToken = await _refreshAccessToken();
    parentMessageId ??= const Uuid().v4();

    final body = ConversationBody(
      action: 'next',
      conversationId: conversationId,
      messages: [
        Prompt(
          content: PromptContent(contentType: 'text', parts: [message]),
          id: const Uuid().v4(),
          role: 'user',
        )
      ],
      model: 'text-davinci-002-render',
      parentMessageId: parentMessageId,
    );

    final url = '$backendApiBaseUrl/conversation';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'user-agent': userAgent,
      },
      body: body.toJson(),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 429) {
        throw Exception('Rate limited');
      } else {
        throw Exception('Failed to send message');
      }
    } else if (_errorMessages.contains(response.body)) {
      throw Exception('OpenAI returned an error');
    }

    String longestLine =
        response.body.split('\n').reduce((a, b) => a.length > b.length ? a : b);

    var result = longestLine.replaceFirst('data: ', '');

    var messageResult = ConversationResponseEvent.fromJson(result);

    var lastResult = messageResult.message?.content.parts.first;

    if (lastResult == null) {
      throw Exception('No response from OpenAI');
    } else {
      return ChatResponse(
        message: lastResult,
        messageId: messageResult.message!.id,
        conversationId: messageResult.conversationId,
      );
    }
  }

  Future<String> _refreshAccessToken() async {
    final cachedAccessToken = _accessTokenCache['KEY_ACCESS_TOKEN'];
    if (cachedAccessToken != null) {
      return cachedAccessToken;
    }

    try {
      final res =
          await http.get(Uri.parse('$apiBaseUrl/auth/session'), headers: {
        'cookie': '__Secure-next-auth.session-token=$sessionToken',
        'user-agent': userAgent,
      });

      if (res.statusCode != 200) {
        throw Exception('Failed to refresh access token');
      }

      final accessToken = jsonDecode(res.body)['accessToken'];

      if (accessToken == null) {
        throw Exception(
            'Failed to refresh access token, token in response is null');
      }

      _accessTokenCache['KEY_ACCESS_TOKEN'] = accessToken;
      return accessToken;
    } catch (err) {
      throw Exception('ChatGPT failed to refresh auth token: $err');
    }
  }
}

const defaultUserAgent =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36';

const _errorMessages = [
  "{\"detail\":\"Hmm...something seems to have gone wrong. Maybe try me again in a little bit.\"}",
];
