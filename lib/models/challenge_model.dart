import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbeast/features/challenges/controller/challenge_controller.dart';
import 'package:flutter/material.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final String iconKey;
  final ChallengeFilter filter;
  final DateTime validTill; 
  final ChallengeTab challengeType;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.filter,
    required this.validTill,
    required this.challengeType
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconKey': iconKey,
      'filter': filter.name,
      'validTill': Timestamp.fromDate(validTill),
      'challengeType': challengeType.name,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      iconKey: map['iconKey'] as String,
      filter: ChallengeFilter.values.firstWhere(
        (e) => e.name == map['filter'],
        orElse: () => ChallengeFilter.active,
      ),
      validTill: (map['validTill'] as Timestamp).toDate(),
      challengeType: ChallengeTab.values.firstWhere(
        (e) => e.name == map['challengeType'],
        orElse: () => ChallengeTab.daily,
      ),
    );
  }

  IconData get icon {
  const iconMapping = {
    'local_drink': Icons.local_drink,
    'directions_walk': Icons.directions_walk,
    'fitness_center': Icons.fitness_center,
    'self_improvement': Icons.self_improvement,
    'no_food': Icons.no_food,
    'hotel': Icons.hotel,
    'nutrition': Icons.food_bank,
    'no_cell': Icons.no_cell,
    'menu_book': Icons.menu_book,
    'fastfood': Icons.fastfood,
    'edit_note': Icons.edit_note,
    'local_cafe': Icons.local_cafe,
    'restaurant': Icons.restaurant,
    'no_drinks': Icons.no_drinks,
    'alarm': Icons.alarm,
    'emoji_food_beverage': Icons.emoji_food_beverage,
    'takeout_dining': Icons.takeout_dining,
    'devices_off': Icons.mobile_off,
  };
  return iconMapping[iconKey] ?? Icons.error;
}
}

class ChallengeCollection {
  final List<Challenge> dailyChallenges;
  final List<Challenge> weeklyChallenges;

  ChallengeCollection({
    required this.dailyChallenges,
    required this.weeklyChallenges,
  });

  Map<String, dynamic> toMap() {
    return {
      'daily': dailyChallenges.map((c) => c.toMap()).toList(),
      'weekly': weeklyChallenges.map((c) => c.toMap()).toList(),
    };
  }

  factory ChallengeCollection.fromMap(Map<String, dynamic> map) {
    return ChallengeCollection(
      dailyChallenges:
          (map['daily'] as List).map((e) => Challenge.fromMap(e)).toList(),
      weeklyChallenges:
          (map['weekly'] as List).map((e) => Challenge.fromMap(e)).toList(),
    );
  }

  factory ChallengeCollection.fromSnapshot(DocumentSnapshot snapshot) {
    return ChallengeCollection.fromMap(snapshot.data() as Map<String, dynamic>);
  }
}
