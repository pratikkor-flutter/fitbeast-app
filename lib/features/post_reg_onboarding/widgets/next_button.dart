import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  const NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
