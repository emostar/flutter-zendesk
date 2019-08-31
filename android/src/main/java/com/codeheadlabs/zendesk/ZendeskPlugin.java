package com.codeheadlabs.zendesk;

import android.content.Intent;

import com.zopim.android.sdk.api.ZopimChat;
import com.zopim.android.sdk.model.VisitorInfo;
import com.zopim.android.sdk.prechat.ZopimChatActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

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
    ZopimChat.DefaultConfig zopimConfig = ZopimChat.init((String) call.argument("accountKey"));
    if (call.hasArgument("department")) {
      zopimConfig.department((String) call.argument("department"));
    }
    if (call.hasArgument("appName")) {
      zopimConfig.visitorPathOne((String) call.argument("appName"));
    }
    result.success(true);
  }

  private void handleSetVisitorInfo(MethodCall call, Result result) {
    VisitorInfo.Builder builder = new VisitorInfo.Builder();
    if (call.hasArgument("name")) {
      builder = builder.name((String) call.argument("name"));
    }
    if (call.hasArgument("email")) {
      builder = builder.email((String) call.argument("email"));
    }
    if (call.hasArgument("phoneNumber")) {
      builder = builder.phoneNumber((String) call.argument("phoneNumber"));
    }
    if (call.hasArgument("note")) {
      builder = builder.note((String) call.argument("note"));
    }
    ZopimChat.setVisitorInfo(builder.build());
    result.success(true);
  }

  private void handleStartChat(MethodCall call, Result result) {
    Intent intent = new Intent(mRegistrar.activeContext(), ZopimChatActivity.class);
    mRegistrar.activeContext().startActivity(intent);
    result.success(true);
  }
}
