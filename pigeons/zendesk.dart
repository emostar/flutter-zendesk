import 'package:pigeon/pigeon.dart';

class InitializeRequest {
  String? accountKey;
  String? appId;
}

class SetDepartmentRequest {
  String? department;
}

class StartChatRequest {
  bool? isPreChatFormEnabled;
  bool? isOfflineFormEnabled;
  bool? isAgentAvailabilityEnabled;
  bool? isChatTranscriptPromptEnabled;
  String? messagingName;
  String? iosBackButtonTitle;
  int? iosNavigationBarColor;
  int? iosNavigationTitleColor;
}

@HostApi()
abstract class ChatApi {
  void initialize(InitializeRequest request);
  void setDepartment(SetDepartmentRequest request);
  void startChat(StartChatRequest request);
}

class SetVisitorInfoRequest {
  String? name;
  String? email;
  String? phoneNumber;
}

class VisitorTagsRequest {
  List<String>? tags;
}

class VisitorNoteRequest {
  String? note;
}

@HostApi()
abstract class ProfileApi {
  void setVisitorInfo(SetVisitorInfoRequest request);
  void addVisitorTags(VisitorTagsRequest request);
  void removeVisitorTags(VisitorTagsRequest request);
  void setVisitorNote(VisitorNoteRequest request);
  void appendVisitorNote(VisitorNoteRequest request);
  void clearVisitorNotes();
}
