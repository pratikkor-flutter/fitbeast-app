import 'package:flutter/material.dart';

class ProgressFillIcon extends StatelessWidget {
  final IconData icon;
  final double progress; // value between 0.0 to 1.0
  final Color fillColor;
  final Color backgroundColor;
  final String label;
  final double size;
  final VoidCallback onTap;

  const ProgressFillIcon({
    super.key,
    required this.icon,
    required this.progress,
    required this.fillColor,
    this.backgroundColor = Colors.grey,
    this.label = '',
    this.size = 60,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Background square
              Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  color: backgroundColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Fill layer
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: clampedProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: fillColor.withAlpha(80),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Icon on top
              Icon(
                icon,
                size: size * 0.5,
                color: fillColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${(clampedProgress * 100).toInt()}%',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: fillColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: fillColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
