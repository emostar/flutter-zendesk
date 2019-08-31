import 'dart:async';

import 'package:flutter/services.dart';

class Zendesk {
  static const MethodChannel _channel =
      const MethodChannel('com.codeheadlabs.zendesk');

  Future<void> init(String accountKey, {String department, String appName}) async {
    await _channel.invokeMethod('init', <String, String>{
      'accountKey': accountKey,
      'department': department,
      'appName': appName,
    });
  }

  Future<void> setVisitorInfo({String name, String email, String phoneNumber, String note}) async {
    await _channel.invokeMethod('setVisitorInfo', <String, String>{
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'note': note,
    });
  }

  Future<void> startChat() async {
    await _channel.invokeMethod('startChat');
  }
}
