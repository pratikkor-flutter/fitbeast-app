import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialAuthButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(Get.context!).colorScheme.onSurface;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          shape: BoxShape.circle,
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
