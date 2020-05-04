import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class Zendesk {
  static const MethodChannel _channel =
      const MethodChannel('com.codeheadlabs.zendesk');

  Future<void> init(
    String accountKey, {
    String department,
    String appName,
  }) async {
    await _channel.invokeMethod<void>('init', <String, String>{
      'accountKey': accountKey,
      'department': department,
      'appName': appName,
    });
  }

  Future<void> setVisitorInfo({
    String name,
    String email,
    String phoneNumber,
    String department,
  }) async {
    await _channel.invokeMethod<void>('setVisitorInfo', <String, String>{
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'department': department,
    });
  }

  Future<String> appendNote(String note) async {
    return await _channel.invokeMethod<String>('appendNote', <String, String>{
      'note': note,
    });
  }

  Future<String> setNote(String note) async {
    return await _channel.invokeMethod<String>('setNote', <String, String>{
      'note': note,
    });
  }

  Future<List<String>> addTags(List<String> tags) async {
    return await _channel.invokeListMethod<String>('addTags', <String, dynamic>{
      'tags': tags,
    });
  }

  Future<List<String>> removeTags(List<String> tags) async {
    return await _channel
        .invokeListMethod<String>('removeTags', <String, dynamic>{
      'tags': tags,
    });
  }

  Future<void> startChat({
    bool isPreChatFormEnabled,
    bool isOfflineFormEnabled,
    bool isAgentAvailabilityEnabled,
    bool isChatTranscriptPromptEnabled,
    String messagingName,
    String iosBackButtonTitle,
    Color iosNavigationBarColor,
    Color iosNavigationTitleColor,
  }) async {
    await _channel.invokeMethod<void>('startChat', {
      'isPreChatFormEnabled': isPreChatFormEnabled,
      'isOfflineFormEnabled': isOfflineFormEnabled,
      'isAgentAvailabilityEnabled': isAgentAvailabilityEnabled,
      'isChatTranscriptPromptEnabled': isChatTranscriptPromptEnabled,
      'messagingName': messagingName,
      'iosBackButtonTitle': iosBackButtonTitle,
      'iosNavigationBarColor': iosNavigationBarColor?.value,
      'iosNavigationTitleColor': iosNavigationTitleColor?.value,
    });
  }
}
