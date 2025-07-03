import 'package:flutter/material.dart';

class SleepQualityIndicator extends StatelessWidget {
  final String quality; // 'Poor', 'Fair', 'Good', 'Excellent'
  final VoidCallback onTap;
  final double size;

  const SleepQualityIndicator({
    super.key,
    required this.quality,
    required this.onTap,
    this.size = 60,
  });

  Color getQualityColor() {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return Colors.green.shade400;
      case 'good':
        return Colors.lightGreen.shade400;
      case 'fair':
        return Colors.orange.shade400;
      case 'poor':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  IconData getQualityIcon() {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return Icons.nights_stay_rounded;
      case 'good':
        return Icons.nights_stay_outlined;
      case 'fair':
        return Icons.nightlight_round_outlined;
      case 'poor':
        return Icons.nightlight_round;
      default:
        return Icons.bedtime_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getQualityColor();
    final icon = getQualityIcon();

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: size * 0.5,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            quality,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'Quality',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: getQualityColor(),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
