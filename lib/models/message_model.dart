class Message {
  final String id;
  final String senderName;
  final String initials;
  final String content;
  final String time;
  final bool isRead;

  Message({
    required this.id,
    required this.senderName,
    required this.initials,
    required this.content,
    required this.time,
    required this.isRead,
  });

  Message copyWith({
    String? id,
    String? senderName,
    String? initials,
    String? content,
    String? time,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      initials: initials ?? this.initials,
      content: content ?? this.content,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }
}
