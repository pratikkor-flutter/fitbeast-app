import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ChallengeFilter { active, completed, upcoming }

enum ChallengeTab { daily, weekly }

class ChallengeController extends GetxController {
  final Rx<ChallengeTab> selectedTab = ChallengeTab.daily.obs;
  final Rx<ChallengeFilter> selectedFilter = ChallengeFilter.active.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<Map<String, dynamic>> upcomingDailyChallenges =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> upcomingWeeklyChallenges =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> activeChallenges =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> completedChallenges =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    //uploadChallengesToFirebase();
    fetchChallenges();
  }

  String get userId => _auth.currentUser?.uid ?? '';

  Future<void> fetchChallenges() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchUpcomingChallenges(),
        fetchUserChallenges(),
      ]);
    } catch (e) {
      showFitSnackbar('Failed to fetch challenges: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUpcomingChallenges() async {
    final querySnapshot = await _firestore.collection('challenges').get();

    final daily = <Map<String, dynamic>>[];
    final weekly = <Map<String, dynamic>>[];

    for (var doc in querySnapshot.docs) {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final userChallengeSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('user_challenges')
          .get();
      final acceptedChallengeIds =
          userChallengeSnapshot.docs.map((doc) => doc.id).toSet();
      if (acceptedChallengeIds.contains(doc.id)) continue;
      final data = doc.data();
      final challenge = {
        'id': doc.id,
        'title': data['title'] ?? '',
        'description': data['description'] ?? '',
        'iconKey': data['iconKey'] ?? 'self_improvement',
        'challengeType': data['challengeType'],
        'icon': _getIcon(data['iconKey'] ?? 'self_improvement'),
      };

      // log(challenge.toString());

      if (data['challengeType'] == 'daily') {
        daily.add(challenge);
        //log(challenge.toString());
      } else if (data['challengeType'] == 'weekly') {
        weekly.add(challenge);
        log(challenge.toString());
      }
    }

    upcomingDailyChallenges.assignAll(daily);
    upcomingWeeklyChallenges.assignAll(weekly);
  }

  Future<void> fetchUserChallenges() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('user_challenges')
        .get();

    final active = <Map<String, dynamic>>[];
    final completed = <Map<String, dynamic>>[];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final validTill = DateTime.parse(data['validTill']);
      // final status = _determineChallengeStatus(validTill);
      final progress = (data['progress'] ?? 0).toDouble();

      final challenge = {
        'id': doc.id,
        'title': data['title'],
        'description': data['description'],
        'iconKey': data['iconKey'],
        'icon': _getIcon(data['iconKey']),
        'challengeType': data['challengeType'],
        'validTill': validTill,
        'progress': progress,
        'filter': progress >= 100
            ? ChallengeFilter.completed
            : ChallengeFilter.active,
      };

      if (progress >= 100) {
        completed.add(challenge);
      } else {
        active.add(challenge);
      }
    }

    activeChallenges.assignAll(active);
    completedChallenges.assignAll(completed);
  }

  Future<void> acceptChallenge(Map<String, dynamic> challenge) async {
    final now = DateTime.now();
    final validTill = now.add(const Duration(days: 3));

    final userChallengeRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('user_challenges')
        .doc(challenge['id']);

    await userChallengeRef.set({
      'title': challenge['title'],
      'description': challenge['description'],
      'iconKey': challenge['iconKey'],
      'challengeType': challenge['challengeType'],
      'validTill': validTill.toIso8601String(),
      'progress': 0,
    });

    await fetchChallenges();
  }

  Future<void> updateProgress(String challengeId, double progress) async {
    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('user_challenges')
        .doc(challengeId);

    await ref.update({'progress': progress});

    await fetchChallenges();
  }

  ChallengeFilter determineChallengeStatus(DateTime validTill) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final vDate = DateTime(validTill.year, validTill.month, validTill.day);

    if (vDate.isBefore(today)) {
      return ChallengeFilter.completed;
    } else if (vDate.isAtSameMomentAs(today) ||
        vDate.isBefore(today.add(const Duration(days: 3)))) {
      return ChallengeFilter.active;
    } else {
      return ChallengeFilter.upcoming;
    }
  }
  //   if (vDate.isBefore(today)) {
  //     return ChallengeFilter.completed;
  //   } else if (vDate.isAtSameMomentAs(today) ||
  //       vDate.isBefore(today.add(const Duration(days: 3)))) {
  //     return ChallengeFilter.active;
  //   } else {
  //     return ChallengeFilter.upcoming;
  //   }
  // }

  List<Map<String, dynamic>> get filteredChallenges {
    if (selectedFilter.value == ChallengeFilter.upcoming) {
      return selectedTab.value == ChallengeTab.daily
          ? upcomingDailyChallenges
          : upcomingWeeklyChallenges;
    } else if (selectedFilter.value == ChallengeFilter.active) {
      return activeChallenges
          .where((e) => e['challengeType'] == selectedTab.value.name)
          .toList();
    } else {
      return completedChallenges
          .where((e) => e['challengeType'] == selectedTab.value.name)
          .toList();
    }
  }

  Future<void> logChallengeProgress(String challengeId) async {
    TextEditingController progressController = TextEditingController();

    final result = await Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
        title:
            Text('Update Challenge Progress', style: AppTextTheme.titleMedium),
        content: TextField(
          controller: progressController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Progress (%)',
            labelStyle: AppTextTheme.bodyMedium,
            suffixText: '%',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: Text('Cancel', style: AppTextTheme.titleSmall),
          ),
          ButtonVariants.primary(
            onPressed: () {
              if (progressController.text.isEmpty) {
                showFitSnackbar('Please enter progress value', isError: true);
                return;
              }

              final value = double.tryParse(progressController.text.trim());
              if (value == null || value < 0 || value > 100) {
                showFitSnackbar('Progress must be between 0 and 100',
                    isError: true);
                return;
              }

              Get.back(result: value);
            },
            text: 'Update',
          ),
        ],
      ),
    );

    if (result != null) {
      await updateProgress(challengeId, result);

      showFitSnackbar('Challenge progress updated successfully!');
    }
  }

  void changeTab(ChallengeTab tab) {
    selectedTab.value = tab;
  }

  void changeFilter(ChallengeFilter filter) {
    selectedFilter.value = filter;
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'local_drink':
        return Icons.local_drink;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'no_food':
        return Icons.no_food;
      case 'hotel':
        return Icons.hotel;
      case 'nutrition':
        return Icons.food_bank;
      case 'no_cell':
        return Icons.no_cell;
      case 'menu_book':
        return Icons.menu_book;
      case 'fastfood':
        return Icons.fastfood;
      case 'edit_note':
        return Icons.edit_note;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'restaurant':
        return Icons.restaurant;
      case 'no_drinks':
        return Icons.no_drinks;
      case 'alarm':
        return Icons.alarm;
      case 'emoji_food_beverage':
        return Icons.emoji_food_beverage;
      case 'takeout_dining':
        return Icons.takeout_dining;
      case 'devices_off':
        return Icons.mobile_off;
      default:
        return Icons.self_improvement;
    }
  }

//   // final List<Map<String, dynamic>> _dailyChallenges = [
//   //   {
//   //     'id': 'daily1',
//   //     'title': 'Water Intake',
//   //     'description': 'Drink 3L of water today',
//   //     'iconKey': 'local_drink',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily2',
//   //     'title': '10,000 Steps',
//   //     'description': 'Walk 10,000 steps today',
//   //     'iconKey': 'directions_walk',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily3',
//   //     'title': '30-min Workout',
//   //     'description': 'Complete a 30-minute workout',
//   //     'iconKey': 'fitness_center',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily4',
//   //     'title': 'Morning Stretch',
//   //     'description': 'Do 10 minutes of morning stretching',
//   //     'iconKey': 'self_improvement',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily5',
//   //     'title': 'No Sugar',
//   //     'description': 'Avoid added sugar today',
//   //     'iconKey': 'no_food',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily6',
//   //     'title': '8 Hours Sleep',
//   //     'description': 'Get 8 hours of sleep tonight',
//   //     'iconKey': 'hotel',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily7',
//   //     'title': '5 Fruits/Veggies',
//   //     'description': 'Eat 5 servings of fruits/vegetables',
//   //     'iconKey': 'nutrition',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily8',
//   //     'title': 'No Screen Time',
//   //     'description': '1 hour before bed with no screens',
//   //     'iconKey': 'no_cell',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily9',
//   //     'title': '15-min Meditation',
//   //     'description': 'Meditate for 15 minutes',
//   //     'iconKey': 'self_improvement',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily10',
//   //     'title': 'Read 30 Pages',
//   //     'description': 'Read 30 pages of a book',
//   //     'iconKey': 'menu_book',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily11',
//   //     'title': 'No Fast Food',
//   //     'description': 'Avoid fast food today',
//   //     'iconKey': 'fastfood',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily12',
//   //     'title': '20 Pushups',
//   //     'description': 'Do 20 pushups today',
//   //     'iconKey': 'fitness_center',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily13',
//   //     'title': 'Gratitude Journal',
//   //     'description': 'Write 3 things you\'re grateful for',
//   //     'iconKey': 'edit_note',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily14',
//   //     'title': 'No Caffeine',
//   //     'description': 'Avoid caffeine after 2pm',
//   //     'iconKey': 'local_cafe',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   //   {
//   //     'id': 'daily15',
//   //     'title': '30-min Walk',
//   //     'description': 'Take a 30-minute walk outside',
//   //     'iconKey': 'directions_walk',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 1)),
//   //     'challengeType': ChallengeTab.daily,
//   //   },
//   // ];

//   // final List<Map<String, dynamic>> _weeklyChallenges = [
//   //   {
//   //     'id': 'weekly1',
//   //     'title': 'Complete 5 Workouts',
//   //     'description': 'Do 5 workouts this week',
//   //     'iconKey': 'fitness_center',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly2',
//   //     'title': 'Meditate 3 Times',
//   //     'description': 'Meditate at least 3 times this week',
//   //     'iconKey': 'self_improvement',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly3',
//   //     'title': '70,000 Steps',
//   //     'description': 'Walk 70,000 steps this week',
//   //     'iconKey': 'directions_walk',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly4',
//   //     'title': 'Meal Prep',
//   //     'description': 'Prepare 3 healthy meals at home',
//   //     'iconKey': 'restaurant',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly5',
//   //     'title': 'No Alcohol',
//   //     'description': 'Avoid alcohol this week',
//   //     'iconKey': 'no_drinks',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly6',
//   //     'title': 'Read a Book',
//   //     'description': 'Read at least 100 pages this week',
//   //     'iconKey': 'menu_book',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly7',
//   //     'title': 'Early Riser',
//   //     'description': 'Wake up before 7am 5 days',
//   //     'iconKey': 'alarm',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly8',
//   //     'title': 'Social Media Limit',
//   //     'description': 'Limit to 30 mins per day',
//   //     'iconKey': 'no_cell',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly9',
//   //     'title': 'Try New Recipe',
//   //     'description': 'Cook one new healthy recipe',
//   //     'iconKey': 'emoji_food_beverage',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly10',
//   //     'title': 'Yoga 3 Times',
//   //     'description': 'Do yoga at least 3 times',
//   //     'iconKey': 'self_improvement',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly11',
//   //     'title': 'No Takeout',
//   //     'description': 'Avoid takeout food this week',
//   //     'iconKey': 'takeout_dining',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly12',
//   //     'title': 'Journal Daily',
//   //     'description': 'Write in journal every day',
//   //     'iconKey': 'edit_note',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly13',
//   //     'title': 'Plank Challenge',
//   //     'description': 'Increase plank time daily',
//   //     'iconKey': 'fitness_center',
//   //     'filter': ChallengeFilter.active,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly14',
//   //     'title': 'Digital Detox',
//   //     'description': 'No screens for 2 hours before bed',
//   //     'iconKey': 'devices_off',
//   //     'filter': ChallengeFilter.upcoming,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   //   {
//   //     'id': 'weekly15',
//   //     'title': 'Hydration Goal',
//   //     'description': 'Drink 3L water daily all week',
//   //     'iconKey': 'local_drink',
//   //     'filter': ChallengeFilter.completed,
//   //     'validTill': DateTime.now().add(Duration(days: 7)),
//   //     'challengeType': ChallengeTab.weekly,
//   //   },
//   // ];

//   // Future<void> uploadChallengesToFirebase() async {
//   //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   //   // Create a new batch
//   //   final WriteBatch batch = firestore.batch();

//   //   // Reference to the challenges collection
//   //   final CollectionReference challengesRef =
//   //       firestore.collection('challenges');

//   //   // Add all daily challenges to batch
//   //   for (final challenge in _dailyChallenges) {
//   //     final docRef = challengesRef.doc(challenge['id']);
//   //     batch.set(docRef, {
//   //       'title': challenge['title'],
//   //       'description': challenge['description'],
//   //       'iconKey': challenge['iconKey'],
//   //       'challengeType': 'daily',
//   //     });
//   //   }

//   //   // Add all weekly challenges to batch
//   //   for (final challenge in _weeklyChallenges) {
//   //     final docRef = challengesRef.doc(challenge['id']);
//   //     batch.set(docRef, {
//   //       'title': challenge['title'],
//   //       'description': challenge['description'],
//   //       'iconKey': challenge['iconKey'],
//   //       'challengeType': 'weekly',
//   //     });
//   //   }

//   //   try {
//   //     // Commit the batch
//   //     await batch.commit();
//   //     print('Successfully uploaded all challenges to Firebase!');
//   //   } catch (e) {
//   //     print('Error uploading challenges: $e');
//   //     // You might want to rethrow the error or handle it differently
//   //     throw e;
//   //   }
//   // }
}
