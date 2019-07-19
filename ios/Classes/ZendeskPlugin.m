#import "ZendeskPlugin.h"

#import <ZDCChat/ZDCChat.h>

#define ARGB_COLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0  alpha:((c>>24)&0xFF)/255.0]


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
      NSNumber *navigationBarColor = call.arguments[@"iosNavigationBarColor"];
      NSNumber *navigationTitleColor = call.arguments[@"iosNavigationTitleColor"];
      
      if ([navigationBarColor isKindOfClass:[NSNull class]] || [navigationTitleColor isKindOfClass:[NSNull class]]) {
          [ZDCChat startChat:nil];
          result(@(true));
          return;
      }
      
      UINavigationController *navVc = [[UINavigationController alloc] init];
      navVc.navigationBar.translucent = NO;
      navVc.navigationBar.barTintColor = ARGB_COLOR([navigationBarColor integerValue]);
      navVc.navigationBar.titleTextAttributes = @{
                                                  NSForegroundColorAttributeName: ARGB_COLOR([navigationTitleColor integerValue])
                                                  };
      
      
      [ZDCChat startChatIn:navVc withConfig:nil];
      
      UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController ;
      [rootVc presentViewController:navVc
                           animated:true
                         completion:^{
                             UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", comment: @"")
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(close:)];
                             
                             [back setTitleTextAttributes:@{ NSForegroundColorAttributeName: ARGB_COLOR([navigationTitleColor integerValue])} forState:UIControlStateNormal];
                             
                             navVc.topViewController.navigationItem.leftBarButtonItem = back;
                             
                         }];

    result(@(true));
  } else if ([@"version" isEqualToString:call.method]) {
      result(ZDC_CHAT_SDK_VERSION);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)close:(id)sender {
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
}

@end
