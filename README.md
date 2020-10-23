# zendesk

Flutter interface for Zendesk Mobile SDK. 

## Android Integration

You must set a compatible theme *theme* in the `AndroidManifest.xml` file's `<application>` tag. The details are outlined on the [zendesk forums](https://develop.zendesk.com/hc/en-us/community/posts/360043932734/comments/360011819933).

The Android example of this shows the same details.

## For Developers

The plugin is using [Pigeon](https://pub.dev/packages/pigeon) to generate all the interfaces needed.
To modify the interfaces, edit `zendesk.dart` in the `pigeons` folder and run:

```
flutter pub run pigeon \
  --input pigeons/zendesk.dart \
  --dart_out lib/src/pigeon.dart \
  --objc_header_out ios/Classes/zendesk.pigeon.h \
  --objc_source_out ios/Classes/zendesk.pigeon.m \
  --java_out ./android/src/main/java/com/codeheadlabs/zendesk/ZendeskPigeon.java \
  --java_package "com.codeheadlabs.zendesk.pigeon"
```