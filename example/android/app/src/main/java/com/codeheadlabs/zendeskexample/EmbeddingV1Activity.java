package com.codeheadlabs.zendeskexample;

import android.os.Bundle;
import com.codeheadlabs.zendesk.ZendeskPlugin;
import dev.flutter.plugins.e2e.E2EPlugin;
import io.flutter.app.FlutterActivity;

public class EmbeddingV1Activity extends FlutterActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    ZendeskPlugin.registerWith(registrarFor("com.codeheadlabs.zendesk.ZendeskPlugin"));
    E2EPlugin.registerWith(registrarFor("dev.flutter.plugins.e2e.E2EPlugin"));
  }
}
