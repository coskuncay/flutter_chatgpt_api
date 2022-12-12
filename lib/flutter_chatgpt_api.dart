library flutter_chatgpt_api;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_chatgpt_api/src/models/models.dart';
import 'package:flutter_chatgpt_api/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

part 'src/models/chat_message.model.dart';

class ChatGPTApi {
  String sessionToken;
  String clearanceToken;
  String? apiBaseUrl;
  String backendApiBaseUrl;
  String userAgent;

  final ExpiryMap<String, String> _accessTokenCache =
      ExpiryMap<String, String>();

  ChatGPTApi({
    required this.sessionToken,
    required this.clearanceToken,
    this.apiBaseUrl = 'https://chat.openai.com/api',
    this.backendApiBaseUrl = 'https://chat.openai.com/backend-api',
    this.userAgent = defaultUserAgent,
  });

  Map<String, String> defaultHeaders = {
    'user-agent': defaultUserAgent,
    'x-openai-assistant-app-id': '',
    'accept-language': 'en-US,en;q=0.9',
    HttpHeaders.accessControlAllowOriginHeader: 'https://chat.openai.com',
    HttpHeaders.refererHeader: 'https://chat.openai.com/chat',
    'sec-ch-ua':
        '"Not?A_Brand";v="8", "Chromium";v="108", "Google Chrome";v="108"',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
  };

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
        'user-agent': defaultUserAgent,
        'x-openai-assistant-app-id': '',
        'accept-language': 'en-US,en;q=0.9',
        HttpHeaders.accessControlAllowOriginHeader: 'https://chat.openai.com',
        HttpHeaders.refererHeader: 'https://chat.openai.com/chat',
        'sec-ch-ua':
            '"Not?A_Brand";v="8", "Chromium";v="108", "Google Chrome";v="108"',
        'sec-ch-ua-platform': '"Windows"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream',
        'Cookie': 'cf_clearance=$clearanceToken'
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
      final res = await http.get(
        Uri.parse('$apiBaseUrl/auth/session'),
        headers: {
          'cookie':
              'cf_clearance=$clearanceToken;__Secure-next-auth.session-token=$sessionToken',
          'accept': '*/*',
          ...defaultHeaders,
        },
      );

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
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36';

const _errorMessages = [
  "{\"detail\":\"Hmm...something seems to have gone wrong. Maybe try me again in a little bit.\"}",
];
