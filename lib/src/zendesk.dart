part of zendesk;

class Zendesk {
  final ChatApi _chatApi = ChatApi();
  final ProfileApi _profileApi = ProfileApi();

  Future<void> init(String accountKey, {String? appId}) async {
    InitializeRequest request = InitializeRequest()
      ..accountKey = accountKey
      ..appId = appId;

    await _chatApi.initialize(request);
  }

  Future<void> setDepartment(String department) async {
    SetDepartmentRequest request = SetDepartmentRequest()
      ..department = department;

    await _chatApi.setDepartment(request);
  }

  Future<void> setVisitorInfo({
    String? name,
    String? email,
    String? phoneNumber,
  }) async {
    SetVisitorInfoRequest request = SetVisitorInfoRequest()
      ..name = name
      ..email = email
      ..phoneNumber = phoneNumber;

    await _profileApi.setVisitorInfo(request);
  }

  Future<void> addVisitorTags(List<String> tags) async {
    VisitorTagsRequest request = VisitorTagsRequest()..tags = tags;
    await _profileApi.addVisitorTags(request);
  }

  Future<void> removeVisitorTags(List<String> tags) async {
    VisitorTagsRequest request = VisitorTagsRequest()..tags = tags;
    await _profileApi.removeVisitorTags(request);
  }

  Future<void> setVisitorNote(String note) async {
    VisitorNoteRequest request = VisitorNoteRequest()..note = note;
    await _profileApi.setVisitorNote(request);
  }

  Future<void> appendVisitorNote(String note) async {
    VisitorNoteRequest request = VisitorNoteRequest()..note = note;
    await _profileApi.appendVisitorNote(request);
  }

  Future<void> clearVisitorNotes() async {
    await _profileApi.clearVisitorNotes();
  }

  Future<void> startChat({
    bool? isPreChatFormEnabled,
    bool? isOfflineFormEnabled,
    bool? isAgentAvailabilityEnabled,
    bool? isChatTranscriptPromptEnabled,
    String? messagingName,
    String? iosBackButtonTitle,
    Color? iosNavigationBarColor,
    Color? iosNavigationTitleColor,
  }) async {
    StartChatRequest request = StartChatRequest()
      ..isPreChatFormEnabled = isPreChatFormEnabled
      ..isOfflineFormEnabled = isOfflineFormEnabled
      ..isAgentAvailabilityEnabled = isAgentAvailabilityEnabled
      ..isChatTranscriptPromptEnabled = isChatTranscriptPromptEnabled
      ..messagingName = messagingName
      ..iosBackButtonTitle = iosBackButtonTitle
      ..iosNavigationBarColor = iosNavigationBarColor?.value
      ..iosNavigationTitleColor = iosNavigationTitleColor?.value;
      
    await _chatApi.startChat(request);
  }
}
