import 'package:get/get.dart';
import 'package:fitbeast/models/message_model.dart';

class ChatController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      isLoading(true);
      // Simulate API call - replace with your actual data source
      await Future.delayed(const Duration(seconds: 1));

      final mockMessages = [
        Message(
          id: '1',
          senderName: 'Alex Johnson',
          initials: 'AJ',
          content: 'Hey, how was your workout today?',
          time: '10:30 AM',
          isRead: false,
        ),
        Message(
          id: '2',
          senderName: 'Sarah Miller',
          initials: 'SM',
          content: 'Nutrition plan sent, please check',
          time: 'Yesterday',
          isRead: true,
        ),
        Message(
          id: '3',
          senderName: 'Mike Chen',
          initials: 'MC',
          content: 'Your progress is amazing! Keep it up!',
          time: 'Yesterday',
          isRead: true,
        ),
        Message(
          id: '4',
          senderName: 'FitBeast Team',
          initials: 'FB',
          content: 'New challenge starting tomorrow',
          time: '2 days ago',
          isRead: false,
        ),
        Message(
          id: '5',
          senderName: 'Emma Wilson',
          initials: 'EW',
          content: 'Let me know if you need any modifications',
          time: '3 days ago',
          isRead: true,
        ),
      ];

      messages.assignAll(mockMessages);
    } finally {
      isLoading(false);
    }
  }

  List<Message> get filteredMessages {
    if (searchQuery.isEmpty) return messages;
    return messages.where((message) {
      return message.senderName
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          message.content.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void markAsRead(int index) {
    if (index < messages.length) {
      final updatedMessage = messages[index].copyWith(isRead: true);
      messages[index] = updatedMessage;
    }
  }

  void deleteMessage(String id) {
    messages.removeWhere((message) => message.id == id);
  }
}
