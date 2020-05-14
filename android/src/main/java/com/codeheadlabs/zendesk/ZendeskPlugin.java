package com.codeheadlabs.zendesk;

import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ZendeskPlugin
 */
public class ZendeskPlugin implements FlutterPlugin, ActivityAware {

  private MethodChannel channel;
  private MethodCallHandlerImpl methodCallHandler;

  public ZendeskPlugin() {
  }

  public static void registerWith(Registrar registrar) {
    ZendeskPlugin plugin = new ZendeskPlugin();
    plugin.startListening(registrar.context(), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    startListening(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
  }

  private void startListening(Context applicationContext, BinaryMessenger messenger) {
    methodCallHandler = new MethodCallHandlerImpl(applicationContext);
    channel = new MethodChannel(messenger, "com.codeheadlabs.zendesk");
    channel.setMethodCallHandler(methodCallHandler);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    methodCallHandler.setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    methodCallHandler.setActivity(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    methodCallHandler.setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    methodCallHandler.setActivity(null);
  }
}
