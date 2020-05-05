package com.codeheadlabs.zendesk;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import zendesk.chat.Chat;
import zendesk.chat.ChatEngine;
import zendesk.chat.ChatProvider;
import zendesk.chat.ProfileProvider;
import zendesk.chat.VisitorInfo;
import zendesk.chat.VisitorPath;
import zendesk.messaging.MessagingActivity;

/** ZendeskPlugin */
public class ZendeskPlugin implements MethodCallHandler {
  private final Registrar mRegistrar;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.codeheadlabs.zendesk");
    channel.setMethodCallHandler(new ZendeskPlugin(registrar));
  }

  private ZendeskPlugin(Registrar registrar) {
    this.mRegistrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "init":
        handleInit(call, result);
        break;
      case "setVisitorInfo":
        handleSetVisitorInfo(call, result);
        break;
      case "startChat":
        handleStartChat(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void handleInit(MethodCall call, Result result) {
    Chat.INSTANCE.init(mRegistrar.context(), (String) call.argument("accountKey"));
    if (call.hasArgument("department")) {
      ChatProvider chatProvider = Chat.INSTANCE.providers().chatProvider();
      chatProvider.setDepartment((String) call.argument("department"), null);
    }
    if (call.hasArgument("appName")) {
      ProfileProvider profileProvider = Chat.INSTANCE.providers().profileProvider();
      VisitorPath visitorPath = VisitorPath.create((String) call.argument("appName"));
      profileProvider.trackVisitorPath(visitorPath, null);
    }
    result.success(true);
  }

  private void handleSetVisitorInfo(MethodCall call, Result result) {
    ProfileProvider profileProvider = Chat.INSTANCE.providers().profileProvider();
    VisitorInfo.Builder builder = VisitorInfo.builder();
    if (call.hasArgument("name")) {
      builder = builder.withName((String) call.argument("name"));
    }
    if (call.hasArgument("email")) {
      builder = builder.withEmail((String) call.argument("email"));
    }
    if (call.hasArgument("phoneNumber")) {
      builder = builder.withPhoneNumber((String) call.argument("phoneNumber"));
    }
    if (call.hasArgument("note")) {
      profileProvider.setVisitorNote((String) call.argument("note"), null);
    }
    profileProvider.setVisitorInfo(builder.build(), null);
    result.success(true);
  }

  private void handleStartChat(MethodCall call, Result result) {
    MessagingActivity.builder()
            .withEngines(ChatEngine.engine())
            .show(mRegistrar.activeContext());
    result.success(true);
  }
}
