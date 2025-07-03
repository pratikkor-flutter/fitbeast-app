import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FithubController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive lists
  final RxList<Map<String, dynamic>> groups = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> trainers = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> blogs = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading(true);
      await Future.wait([
        fetchTrainers(),
        fetchBlogs(),
        fetchGroups(),
      ]);
    } finally {
      isLoading(false);
    }
  }

  // Future<void> fetchGroups() async {
  //   // Simulate network delay
  //   await Future.delayed(const Duration(seconds: 1));

  //   groups.assignAll([
  //     {
  //       'id': '1',
  //       'name': 'Morning Runners',
  //       'icon': Icons.directions_run,
  //       'color': Colors.blueAccent,
  //       'memberCount': 245,
  //     },
  //     {
  //       'id': '2',
  //       'name': 'Yoga Lovers',
  //       'icon': Icons.self_improvement,
  //       'color': Colors.green,
  //       'memberCount': 189,
  //     },
  //     {
  //       'id': '3',
  //       'name': 'Cycling Club',
  //       'icon': Icons.directions_bike,
  //       'color': Colors.redAccent,
  //       'memberCount': 132,
  //     },
  //     {
  //       'id': '4',
  //       'name': 'Weight Lifters',
  //       'icon': Icons.fitness_center,
  //       'color': Colors.purpleAccent,
  //       'memberCount': 98,
  //     },
  //     {
  //       'id': '5',
  //       'name': 'Swim Team',
  //       'icon': Icons.pool,
  //       'color': Colors.orangeAccent,
  //       'memberCount': 76,
  //     },
  //   ]);
  // }

  Future<String> loadTrainerStatus(String trainerId) async {
    // Check in connections
    final connectionSnapshot = await _firestore
        .collection('connections')
        .where('userId', isEqualTo: currentUserId)
        .where('trainerId', isEqualTo: trainerId)
        .get();

    if (connectionSnapshot.docs.isNotEmpty) {
      return 'accepted';
    }

    // Check in requests
    final requestSnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('requests')
        .where('trainerId', isEqualTo: trainerId)
        .limit(1)
        .get();

    if (requestSnapshot.docs.isNotEmpty) {
      return 'pending';
    }

    return 'connect';
  }

  Future<void> fetchGroups() async {
    final snapshot = await _firestore.collection('groups').get();
    groups.assignAll(snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? '',
        'icon': _getIconData(data['name']),
      };
    }).toList());
  }

  Future<void> fetchTrainers() async {
    final snapshot = await _firestore.collection('trainers').get();
    trainers.assignAll(snapshot.docs.map((doc) {
      final data = doc.data();
      log(data.toString());
      return {
        'id': doc.id,
        'name': data['name'] ?? '',
        'gym': data['gym'] ?? '',
        'speciality': data['speciality'] ?? 'General Fitness',
        'experience': data['experience'] ?? '',
      };
    }).toList());
  }

  Future<void> fetchBlogs() async {
    final snapshot = await _firestore
        .collection('blogs')
        .orderBy('date', descending: true)
        .get();

    blogs.assignAll(snapshot.docs.map((doc) {
      final data = doc.data();
      log("blogs data:- ${data.toString()}");
      return {
        'id': doc.id,
        'title': data['title'] ?? '',
        'desc': data['desc'] ?? '',
        'author': data['author'] ?? '',
        'date': data['date'],
        'likes': data['likes'] ?? 0,
        'imageUrl': data['imageUrl'] ?? '',
      };
    }).toList());
  }

  Future<void> sendConnectionRequest(String trainerId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    final isTrainer =
        await _firestore.collection('trainers').doc(currentUserId).get();
    if (isTrainer.exists) {
      showFitSnackbar('Trainers cannot send connection requests',
          isError: true);
      return;
    }

    final userDoc =
        await _firestore.collection('users').doc(currentUserId).get();

    final userName = userDoc.data()?['name'] ?? 'Unknown User';

    final trainerDoc =
        await _firestore.collection('trainers').doc(trainerId).get();
    final trainerData = trainerDoc.data();
    if (trainerData == null) {
      showFitSnackbar('Trainer not found', isError: true);
      return;
    }

    final trainerName = trainerData['name'] ?? 'Unknown Trainer';
    final trainerGym = trainerData['gym'] ?? '';
    final trainerExperience = trainerData['experience'] ?? '';
    final trainerSpeciality = trainerData['speciality'] ?? '';

    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('requests')
          .add({
        'userId': currentUserId,
        'userName': userName,
        'trainerId': trainerId,
        'trainerName': trainerName,
        'trainerGym': trainerGym,
        'trainerExperience': trainerExperience,
        'trainerSpeciality': trainerSpeciality,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _firestore
          .collection('users')
          .doc(trainerId)
          .collection('requests')
          .add({
        'userId': currentUserId,
        'userName': userName,
        'trainerId': trainerId,
        'trainerName': trainerName,
        'trainerGym': trainerGym,
        'trainerExperience': trainerExperience,
        'trainerSpeciality': trainerSpeciality,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      showFitSnackbar('Connection request sent to trainer');
    } catch (e) {
      showFitSnackbar('Failed to send connection request: $e', isError: true);
    }
  }

  // Helper methods
  IconData _getIconData(String iconName) {
    if (iconName.toLowerCase().contains('runners')) {
      return Icons.directions_run;
    }
    if (iconName.toLowerCase().contains('yoga')) {
      return Icons.self_improvement;
    }
    if (iconName.toLowerCase().contains('cycling')) {
      return Icons.directions_bike;
    }
    if (iconName.toLowerCase().contains('swim')) {
      return Icons.pool;
    } else {
      return Icons.fitness_center;
    }
  }

  Color getColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.redAccent;
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.greenAccent;
      case 3:
        return Colors.purpleAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  String timeAgo(String date) {
    DateTime dateTime = DateTime.parse(date);
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inDays < 30) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }
}
