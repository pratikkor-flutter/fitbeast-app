import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/models/connection_model.dart';
import 'package:get/get.dart';

class ConnectionsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  final RxBool isTrainer = false.obs;
  final RxBool isLoading = true.obs;

  final RxList<Connection> pendingRequests = <Connection>[].obs; // For trainers
  final RxList<Connection> sentRequests = <Connection>[].obs; //For users
  final RxList<Connection> requests = <Connection>[].obs;
  final RxList<Connection> connections = <Connection>[].obs;

  final RxString searchQuery = ''.obs;
  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRole();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void changeTabIndex(int index) {
    currentTabIndex.value = index;
  }

  Future<void> fetchUserRole() async {
    final userDoc =
        await _firestore.collection('users').doc(currentUserId).get();
    final trainerData =
        await _firestore.collection('trainers').doc(userDoc.id).get();
    isTrainer.value = trainerData.exists;

    fetchConnectionData();
  }

  Future<void> fetchConnectionData() async {
    isLoading(true);
    try {
      if (isTrainer.value) {
        log('Trainer True');
        await Future.wait([
          fetchPendingRequests(),
          fetchConnections(),
        ]);
      } else {
        log('Trainer False');
        await Future.wait([
          fetchSentRequests(),
          fetchConnections(),
        ]);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPendingRequests() async {
    if (currentUserId == null) return;

    final usersSnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('requests')
        .get();
    final requestData = usersSnapshot.docs;
    final List<Connection> allRequests = [];

    for (var doc in requestData) {
      final data = doc.data();
      allRequests
          .add(Connection(name: data['userName'], id: doc.id, isRequest: true));

      print("Found request from ${data['userName']} to trainer $currentUserId");
    }

    pendingRequests.assignAll(allRequests);
  }

  Future<void> fetchSentRequests() async {
    if (currentUserId == null) return;

    // User's sent requests from subcollection
    final snapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('requests')
        .get();

    sentRequests.assignAll(snapshot.docs.map((doc) {
      final data = doc.data();
      return Connection(
        id: doc.id,
        name: data['trainerName'] ?? 'Unknown Trainer',
        isRequest: true,
      );
    }).toList());
  }

  Future<void> fetchConnections() async {
    if (currentUserId == null) return;

    final usersSnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('connections')
        .get();
    final requestData = usersSnapshot.docs;
    final List<Connection> allConn = [];

    for (var doc in requestData) {
      final data = doc.data();
      allConn.add(Connection(
          name: data['userName'], id: data['userId'], isRequest: false));

      print(
          "Found Connection from ${data['userName']} to trainer $currentUserId");
    }

    connections.assignAll(allConn);
  }

  Future<void> messageConnection(String connectionId) async {
    try {
      // Get connection document
      final connectionDoc =
          await _firestore.collection('connections').doc(connectionId).get();
      final connectionData = connectionDoc.data();

      if (connectionData == null) return;

      // Determine who the other user is
      final otherUserId = isTrainer.value
          ? connectionData['userId']
          : connectionData['trainerId'];

      if (otherUserId == null) return;

      // Navigate to chat screen
      Get.toNamed('/chat/$otherUserId');
    } catch (e) {
      showFitSnackbar('Failed to start chat: $e', isError: true);
    }
  }

  Future<void> acceptRequest(String requestId) async {
    try {
      if (currentUserId == null) return;

      // Get the request document from subcollection
      final requestDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('requests')
          .doc(requestId)
          .get();

      final requestData = requestDoc.data();
      if (requestData == null) return;

      // Add to connections collection
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('connections')
          .add({
        'userId': requestData['userId'],
        'userName': requestData['userName'],
        'trainerId': requestData['trainerId'],
        'trainerName': requestData['trainerName'],
        'connectedAt': FieldValue.serverTimestamp(),
      });

      // Add to connections collection
      await _firestore
          .collection('users')
          .doc(requestData['userId'])
          .collection('connections')
          .add({
        'userId': requestData['userId'],
        'userName': requestData['userName'],
        'trainerId': requestData['trainerId'],
        'trainerName': requestData['trainerName'],
        'connectedAt': FieldValue.serverTimestamp(),
      });

      // Delete the request from both user and trainer subcollections
      await Future.wait([
        _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('requests')
            .doc(requestId)
            .delete()
      ]);

      await Future.wait([
        _firestore
            .collection('users')
            .doc(requestData['userId'])
            .collection('requests')
            .where('trainerId', isEqualTo: currentUserId)
            .get()
            .then((snapshot) {
          for (final doc in snapshot.docs) {
            doc.reference.delete();
          }
        }),
      ]);

      showFitSnackbar('Connection accepted');

      await fetchConnectionData();
    } catch (e) {
      showFitSnackbar('Failed to accept connection: $e', isError: true);
    }
  }

  Future<void> ignoreRequest(String requestId) async {
    try {
      if (currentUserId == null) return;

      // Delete from trainer's subcollection
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('requests')
          .doc(requestId)
          .delete();

      showFitSnackbar('Request ignored');

      await fetchConnectionData();
    } catch (e) {
      showFitSnackbar('Failed to ignore request: $e', isError: true);
    }
  }

  Future<void> fetchConnectionRequests() async {
    if (currentUserId == null) return;

    requests.bindStream(_firestore
        .collection('requests')
        .where('trainerId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Connection(
                id: doc.id,
                name: data['userName'] ?? 'Unknown User',
                isRequest: true,
              );
            }).toList()));
  }

  List<Connection> get filteredRequests {
    if (searchQuery.isEmpty) return requests;
    return requests.where((request) {
      return request.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  List<Connection> get filteredConnections {
    if (searchQuery.isEmpty) return connections;
    return connections.where((connection) {
      return connection.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // void acceptRequest(int index) {
  //   final accepted = requests.removeAt(index);
  //   connections.insert(0, Connection(
  //     name: accepted.name,
  //     mutualConnections: accepted.mutualConnections,
  //   ));
  // }

  // void ignoreRequest(int index) {
  //   requests.removeAt(index);
  // }
}
