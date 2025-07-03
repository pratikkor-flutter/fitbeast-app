import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularAvatarWithInitials extends StatelessWidget {
  final String name;
  final double radius;
  final TextStyle? textStyle;

  const CircularAvatarWithInitials({
    super.key,
    required this.name,
    this.radius = 24,
    this.textStyle,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);

    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(Get.context!).colorScheme.primary,
      child: Text(
        initials,
        style: textStyle ??
            TextStyle(
              color: Theme.of(Get.context!).colorScheme.onPrimary,
              fontSize: radius * 0.8,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
