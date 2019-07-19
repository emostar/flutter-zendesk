#import "ZendeskPlugin.h"

#import <ZDCChat/ZDCChat.h>

@implementation ZendeskPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.codeheadlabs.zendesk"
            binaryMessenger:[registrar messenger]];
  ZendeskPlugin* instance = [[ZendeskPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
    [ZDCChat initializeWithAccountKey:call.arguments[@"accountKey"]];
    result(@(true));
  } else if ([@"setVisitorInfo" isEqualToString:call.method]) {
      NSString *email = call.arguments[@"email"];
      NSString *phoneNumber = call.arguments[@"phoneNumber"];
      NSString *name = call.arguments[@"name"];
      NSString *note = call.arguments[@"note"];

      [ZDCChat updateVisitor:^(ZDCVisitorInfo *user) {
          if (![phoneNumber isKindOfClass:[NSNull class]]) {
              user.phone = phoneNumber;
          }

          if (![email isKindOfClass:[NSNull class]]) {
              user.email = email;
          }

          if (![name isKindOfClass:[NSNull class]]) {
              user.name = name;
          }
          
          if (![note isKindOfClass:[NSNull class]]) {
              [user addNote:note];
          }
      }];
      result(@(true));
  } else if ([@"startChat" isEqualToString:call.method]) {
    [ZDCChat startChat:nil];
    result(@(true));
  } else if ([@"version" isEqualToString:call.method]) {
      result(ZDC_CHAT_SDK_VERSION);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
