import 'dart:developer';

import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/services/group_chat_services.dart';
import 'package:fitbeast/models/group_message_model.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupChatController extends GetxController {
  final GroupChatService _groupChatService = GroupChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<Group?> group = Rx<Group?>(null);
  final RxList<GroupMessage> messages = <GroupMessage>[].obs;
  final RxBool isLoading = true.obs;
  final RxString currentUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentUserId.value = _auth.currentUser?.uid ?? '';
    final arguments = Get.arguments;
    // final groupId = parameters['groupId'] ?? 'OqH3nSK531BbiS7LzXr5';
    final groupId = arguments ?? '';
    if (groupId.isEmpty) {
      showFitSnackbar('Group ID is required', isError: true);
      return;
    }
    log('GroupChatController initialized with groupId: $groupId');
    if (groupId.isNotEmpty) {
      loadGroupData(groupId);
    }
  }

  void loadGroupData(String groupId) {
    isLoading.value = true;

    _groupChatService.getGroupStream(groupId).listen(
      (groupData) {
        log('Group data loaded: ${groupData.toMap().toString()}');
        group.value = groupData;
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        showFitSnackbar('Failed to load group data', isError: true);
        print('Group load error: $error');
      },
    );

    _groupChatService.getGroupMessagesStream(groupId).listen(
      (messagesList) {
        messages.assignAll(messagesList);
      },
      onError: (error) {
        showFitSnackbar('Failed to load messages', isError: true);
        print('Messages load error: $error');
      },
    );
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || group.value == null) return;

    try {
      await _groupChatService.sendMessage(
        groupId: group.value!.id,
        senderId: currentUserId.value,
        senderName: _auth.currentUser?.displayName ?? 'User',
        content: content.trim(),
      );
    } catch (e) {
      showFitSnackbar('Failed to send message', isError: true);
    }
  }

  Future<void> leaveGroup() async {
    if (group.value == null) return;

    try {
      await _groupChatService.removeMemberFromGroup(
        group.value!.id,
        currentUserId.value,
      );
      Get.back();
      showFitSnackbar('You have left the group');
    } catch (e) {
      showFitSnackbar('Failed to leave group', isError: true);
    }
  }

  bool isCurrentUser(String userId) {
    return userId == currentUserId.value;
  }
}
