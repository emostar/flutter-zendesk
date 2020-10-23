#import "ZendeskPlugin.h"

#import <ChatSDK/ChatSDK.h>
#import <MessagingSDK/MessagingSDK.h>
#import <ChatProvidersSDK/ChatProvidersSDK.h>

#import "zendesk.pigeon.h"

#define ARGB_COLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0  alpha:((c>>24)&0xFF)/255.0]

@implementation ZendeskPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    ZendeskPlugin* instance = [[ZendeskPlugin alloc] init];
    ChatApiSetup([registrar messenger], instance);
}

- (id) null:(id)input or:(id)defaultValue {
    if (input == nil || [input isEqual:[NSNull null]]) {
        return defaultValue;
    } else {
        return input;
    }
}

- (void)close:(id)sender {
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)initialize:(nonnull InitializeRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [ZDKChat initializeWithAccountKey:input.accountKey queue:dispatch_get_main_queue()];
}

- (void)setDepartment:(nonnull SetDepartmentRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    ZDKChat.instance.configuration.department = input.department;
}

- (void)startChat:(nonnull StartChatRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSNumber *navigationBarColor = input.iosNavigationBarColor;
    NSNumber *navigationTitleColor = input.iosNavigationTitleColor;
    
    NSString *backButtonTitle = [self null:input.iosBackButtonTitle
                                        or:NSLocalizedString(@"Back", "")];
    NSString *messagingName = [self null:input.messagingName or:@"Chat Bot"];
    
    ZDKMessagingConfiguration *messagingConfiguration = [[ZDKMessagingConfiguration alloc] init];
    messagingConfiguration.name = messagingName;
    
    ZDKChatConfiguration *chatConfiguration = [[ZDKChatConfiguration alloc] init];
    
    chatConfiguration.isPreChatFormEnabled = [[self null:input.isPreChatFormEnabled
                                                      or:@(chatConfiguration.isPreChatFormEnabled)] boolValue];
    chatConfiguration.isOfflineFormEnabled = [[self null:input.isOfflineFormEnabled
                                                      or:@(chatConfiguration.isOfflineFormEnabled)] boolValue];
    chatConfiguration.isAgentAvailabilityEnabled = [[self null:input.isAgentAvailabilityEnabled
                                                            or:@(chatConfiguration.isAgentAvailabilityEnabled)] boolValue];
    chatConfiguration.isChatTranscriptPromptEnabled = [[self null:input.isChatTranscriptPromptEnabled
                                                               or:@(chatConfiguration.isChatTranscriptPromptEnabled)] boolValue];
    
    NSError *localError = nil;
    
    NSArray *engines = @[
        (id <ZDKEngine>) [ZDKChatEngine engineAndReturnError:&localError]
    ];
    UIViewController *viewController = [ZDKMessaging.instance buildUIWithEngines:engines
                                                                         configs:@[messagingConfiguration, chatConfiguration]
                                                                           error:&localError];
    
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:viewController];
    navVc.navigationBar.translucent = NO;
    if (navigationBarColor != nil) {
        navVc.navigationBar.barTintColor = ARGB_COLOR([navigationBarColor integerValue]);
    }
    
    if (navigationTitleColor != nil) {
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
        if (navigationTitleColor != nil) {
            [back setTitleTextAttributes:@{ NSForegroundColorAttributeName:ARGB_COLOR([navigationTitleColor integerValue])} forState:UIControlStateNormal];
        }
        
        navVc.topViewController.navigationItem.leftBarButtonItem = back;
    }];
    
}

- (void)addVisitorTags:(nonnull VisitorTagsRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [ZDKChat.instance.profileProvider addTags:input.tags completion:nil];
}

- (void)appendVisitorNote:(nonnull VisitorNoteRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [ZDKChat.instance.profileProvider appendNote:input.note completion:nil];
}

- (void)clearVisitorNotes:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [ZDKChat.instance.profileProvider setNote:@"" completion:nil];
}

- (void)removeVisitorTags:(nonnull VisitorTagsRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [ZDKChat.instance.profileProvider removeTags:input.tags completion:nil];
}

- (void)setVisitorInfo:(nonnull SetVisitorInfoRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    ZDKChatAPIConfiguration *chatAPIConfiguration = [[ZDKChatAPIConfiguration alloc] init];
    chatAPIConfiguration.visitorInfo = [[ZDKVisitorInfo alloc] initWithName:input.name
                                                                      email:input.email
                                                                phoneNumber:input.phoneNumber];
    ZDKChat.instance.configuration = chatAPIConfiguration;
}

- (void)setVisitorNote:(nonnull VisitorNoteRequest *)input error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [ZDKChat.instance.profileProvider setNote:input.note completion:nil];
}

@end
