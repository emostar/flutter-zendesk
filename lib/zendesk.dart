import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class Zendesk {
  static const MethodChannel _channel =
      const MethodChannel('com.codeheadlabs.zendesk');

  Future<void> init(String accountKey) async {
    await _channel.invokeMethod('init', <String, String>{
      'accountKey': accountKey,
    });
  }

  Future<void> setVisitorInfo(
      {String name, String email, String phoneNumber, String note}) async {
    await _channel.invokeMethod('setVisitorInfo', <String, String>{
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'note': note,
    });
  }

  Future<void> startChat({
    Color iosNavigationBarColor,
    Color iosNavigationTitleColor,
  }) async {
    await _channel.invokeMethod('startChat', {
      'iosNavigationBarColor': iosNavigationBarColor?.value,
      'iosNavigationTitleColor': iosNavigationTitleColor?.value,
    });
  }

  Future<String> version() async {
    return _channel.invokeMethod<String>('version');
  }
}
