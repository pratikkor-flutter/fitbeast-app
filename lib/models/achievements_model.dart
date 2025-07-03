import 'package:flutter/widgets.dart';

class Achievement {
  final String title;
  final IconData icon;
  final Color color;

  Achievement({
    required this.title,
    required this.icon,
    required this.color,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      title: map['title'],
      icon: map['icon'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
      'color': color,
    };
  }
}
