import 'package:fitbeast/features/fithub/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/models/message_model.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatController = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildSearchBar(context, chatController),
          ),
          Expanded(
            child: Obx(() {
              if (chatController.isLoading.value) {
                return _buildLoadingShimmer();
              }
              return _buildMessageList(context, chatController);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ChatController controller) {
    final theme = Theme.of(context);

    return TextField(
      decoration: InputDecoration(
        hintText: 'Search messages...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withAlpha(20),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: controller.updateSearchQuery,
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList(BuildContext context, ChatController controller) {
    if (controller.filteredMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
            ),
            const SizedBox(height: 16),
            Text(
              controller.searchQuery.isEmpty
                  ? 'No messages yet'
                  : 'No messages found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(130),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: controller.filteredMessages.length,
      separatorBuilder: (context, index) => Divider(
        height: 0.1,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
      ),
      itemBuilder: (context, index) {
        final message = controller.filteredMessages[index];
        return _buildMessageItem(context, message, index, controller);
      },
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    Message message,
    int index,
    ChatController controller,
  ) {
    final theme = Theme.of(context);
    final isUnread = !message.isRead;

    return Dismissible(
      key: Key(message.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: theme.colorScheme.onError,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(context);
      },
      onDismissed: (_) => controller.deleteMessage(message.id),
      child: InkWell(
        onTap: () {
          controller.markAsRead(index);
          _openChatDetails(context, message);
        },
        child: Container(
          color: isUnread
              ? theme.colorScheme.primary.withAlpha(10)
              : theme.colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildAvatar(message),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          message.senderName,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                isUnread ? FontWeight.bold : FontWeight.normal,
                            color: isUnread
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isUnread
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withAlpha(180),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.time,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(130),
                    ),
                  ),
                  if (isUnread) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Message message) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: _getAvatarColor(message.senderName),
          child: Text(
            message.initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (!message.isRead)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue.shade700,
      Colors.red.shade600,
      Colors.green.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.teal.shade600,
      Colors.pink.shade600,
    ];
    return colors[name.hashCode % colors.length];
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // void _showMoreOptions(BuildContext context, ChatController controller) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       return SafeArea(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               leading: const Icon(Icons.mark_as_unread),
  //               title: const Text('Mark all as read'),
  //               onTap: () {
  //                 // Implement mark all as read
  //                 Get.back();
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.delete_outline),
  //               title: const Text('Delete all messages'),
  //               onTap: () {
  //                 Get.back();
  //                 _showDeleteAllConfirmation(context, controller);
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.settings),
  //               title: const Text('Chat settings'),
  //               onTap: () {
  //                 Get.back();
  //                 // Navigate to settings
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showDeleteAllConfirmation(
  //     BuildContext context, ChatController controller) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete All Messages'),
  //       content: const Text(
  //           'Are you sure you want to delete all messages? This cannot be undone.'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             // Implement delete all
  //             Get.back();
  //           },
  //           child: const Text('Delete All'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _openChatDetails(BuildContext context, Message message) {
    // TODO: Navigate to chat details screen
    // Get.to(() => ChatDetailsView(message: message));
  }
}
