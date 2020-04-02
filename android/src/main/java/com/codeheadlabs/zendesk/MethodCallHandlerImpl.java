package com.codeheadlabs.zendesk;

import android.app.Activity;
import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.zopim.android.sdk.api.ZopimChat;
import com.zopim.android.sdk.model.VisitorInfo;
import com.zopim.android.sdk.prechat.ZopimChatActivity;
import com.zopim.android.sdk.util.AppInfo;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MethodCallHandlerImpl implements MethodCallHandler {

  @Nullable
  private Activity activity;

  void setActivity(@Nullable Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
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
      case "version":
        handleVersion(result);
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
    if (activity != null) {
      Intent intent = new Intent(activity, ZopimChatActivity.class);
      activity.startActivity(intent);
    }

    result.success(true);
  }

  private void handleVersion(Result result) {
    result.success(AppInfo.getChatSdkVersionName());
  }
}
