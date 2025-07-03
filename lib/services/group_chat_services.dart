import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbeast/models/group_message_model.dart';

class GroupChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get stream of a single group
  Stream<Group> getGroupStream(String groupId) {
    return _firestore.collection('groups').doc(groupId).snapshots().map(
          (snapshot) => Group.fromMap(snapshot.data()!..['id'] = snapshot.id));
  }

  // Get stream of messages for a group
  Stream<List<GroupMessage>> getGroupMessagesStream(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupMessage.fromMap(doc.data()..['id'] = doc.id))
            .toList());
  }

  // Send a message to a group
  Future<void> sendMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required String content,
  }) async {
    final message = GroupMessage(
      id: '',
      groupId: groupId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      timestamp: Timestamp.now(),
    );

    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(message.toMap());
  }

  // Add a member to a group
  Future<void> addMemberToGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  // Remove a member from a group
  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });
  }
}