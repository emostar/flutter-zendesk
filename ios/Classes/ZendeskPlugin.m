#import "ZendeskPlugin.h"

#import <ChatSDK/ChatSDK.h>
#import <MessagingSDK/MessagingSDK.h>
#import <ChatProvidersSDK/ChatProvidersSDK.h>

#define ARGB_COLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0  alpha:((c>>24)&0xFF)/255.0]


@implementation ZendeskPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.codeheadlabs.zendesk"
            binaryMessenger:[registrar messenger]];
  ZendeskPlugin* instance = [[ZendeskPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (id) null:(id)input or:(id)defaultValue {
    if ([input isEqual:[NSNull null]]) {
        return defaultValue;
    } else {
        return input;
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        NSString *accountKey = call.arguments[@"accountKey"];
        [ZDKChat initializeWithAccountKey:accountKey queue:dispatch_get_main_queue()];
        
        result(@(true));
    } else if ([@"setVisitorInfo" isEqualToString:call.method]) {
        NSString *department = [self null:call.arguments[@"department"] or:@""];
        NSString *email = [self null:call.arguments[@"email"] or:@""];
        NSString *phoneNumber = [self null:call.arguments[@"phoneNumber"] or:@""];
        NSString *name = [self null:call.arguments[@"name"] or:@""];
        
        
        ZDKChatAPIConfiguration *chatAPIConfiguration = [[ZDKChatAPIConfiguration alloc] init];
        if (department.length > 0) {
            chatAPIConfiguration.department = department;
        }
        chatAPIConfiguration.visitorInfo = [[ZDKVisitorInfo alloc] initWithName:name
                                                                          email:email
                                                                    phoneNumber:phoneNumber];
        
        ZDKChat.instance.configuration = chatAPIConfiguration;
        
        result(@(true));
    } else if ([@"appendNote" isEqualToString:call.method]) {
        NSString *note = [self null:call.arguments[@"note"] or:@""];
        [ZDKChat.instance.profileProvider appendNote:note completion:^(NSString * _Nullable res, NSError * _Nullable error) {
            if (error) {
                result([FlutterError errorWithCode:@"appendNote" message:error.description details:nil]);
            } else {
                result(res);
            }
        }];
    } else if ([@"setNote" isEqualToString:call.method]) {
        NSString *note = [self null:call.arguments[@"note"] or:@""];
        [ZDKChat.instance.profileProvider setNote:note completion:^(NSString * _Nullable res, NSError * _Nullable error) {
            if (error) {
                result([FlutterError errorWithCode:@"appendNote" message:error.description details:nil]);
            } else {
                result(res);
            }
        }];
    } else if ([@"addTags" isEqualToString:call.method]) {
        NSArray<NSString*> *tags = [self null:call.arguments[@"tags"] or:@[]];
        [ZDKChat.instance.profileProvider addTags:tags completion:^(NSArray<NSString*> * _Nullable res, NSError * _Nullable error) {
            if (error) {
                result([FlutterError errorWithCode:@"appendNote" message:error.description details:nil]);
            } else {
                result(res);
            }
        }];
    } else if ([@"removeTags" isEqualToString:call.method]) {
        NSArray<NSString*> *tags = [self null:call.arguments[@"tags"] or:@[]];
        [ZDKChat.instance.profileProvider removeTags:tags completion:^(NSArray<NSString*> * _Nullable res, NSError * _Nullable error) {
            if (error) {
                result([FlutterError errorWithCode:@"appendNote" message:error.description details:nil]);
            } else {
                result(res);
            }
        }];
    } else if ([@"startChat" isEqualToString:call.method]) {
        NSNumber *navigationBarColor = call.arguments[@"iosNavigationBarColor"];
        NSNumber *navigationTitleColor = call.arguments[@"iosNavigationTitleColor"];
        
        NSString *backButtonTitle = [self null:call.arguments[@"iosBackButtonTitle"]
                                            or:NSLocalizedString(@"Back", "")];
        NSString *messagingName = [self null:call.arguments[@"name"] or:@"Chat Bot"];
        
        ZDKMessagingConfiguration *messagingConfiguration = [[ZDKMessagingConfiguration alloc] init];
        messagingConfiguration.name = messagingName;
        
        ZDKChatConfiguration *chatConfiguration = [[ZDKChatConfiguration alloc] init];
        
        chatConfiguration.isPreChatFormEnabled = [[self null:call.arguments[@"isPreChatFormEnabled"]
                                                          or:@(chatConfiguration.isPreChatFormEnabled)] boolValue];
        chatConfiguration.isOfflineFormEnabled = [[self null:call.arguments[@"isOfflineFormEnabled"]
                                                          or:@(chatConfiguration.isOfflineFormEnabled)] boolValue];
        chatConfiguration.isAgentAvailabilityEnabled = [[self null:call.arguments[@"isAgentAvailabilityEnabled"]
                                                                or:@(chatConfiguration.isAgentAvailabilityEnabled)] boolValue];
        chatConfiguration.isChatTranscriptPromptEnabled = [[self null:call.arguments[@"isChatTranscriptPromptEnabled"]
                                                                   or:@(chatConfiguration.isChatTranscriptPromptEnabled)] boolValue];

        NSError *error = nil;
        ZDKChatEngine* chatEngine = [ZDKChatEngine engineAndReturnError: &error];
        UIViewController *viewController = [ZDKMessaging.instance buildUIWithEngines:@[chatEngine]
                                                                             configs:@[messagingConfiguration, chatConfiguration]
                                                                               error:&error];

      UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:viewController];
      navVc.navigationBar.translucent = NO;
        if (![navigationBarColor isEqual:[NSNull null]]) {
            navVc.navigationBar.barTintColor = ARGB_COLOR([navigationBarColor integerValue]);
        }
                                                
      if (![navigationTitleColor isEqual:[NSNull null]]) {
      navVc.navigationBar.titleTextAttributes = @{
                                                  NSForegroundColorAttributeName: ARGB_COLOR([navigationTitleColor integerValue])
                                                  };
      }
      
              
      UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController ;
      [rootVc presentViewController:navVc
                           animated:true
                         completion:^{
                             UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(close:)];
                             if (![navigationTitleColor isEqual:[NSNull null]]) {

                             [back setTitleTextAttributes:@{ NSForegroundColorAttributeName: ARGB_COLOR([navigationTitleColor integerValue])} forState:UIControlStateNormal];
                             }
                             
                             navVc.topViewController.navigationItem.leftBarButtonItem = back;
                         }];

    result(@(true));
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)close:(id)sender {
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
}

@end
