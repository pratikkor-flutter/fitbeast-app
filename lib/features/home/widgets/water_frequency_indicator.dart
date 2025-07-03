import 'package:flutter/material.dart';

class WaterFrequencyIndicator extends StatelessWidget {
  final int frequency;
  final int targetFrequency;
  final VoidCallback onTap;
  final double size;

  const WaterFrequencyIndicator({
    super.key,
    required this.frequency,
    required this.targetFrequency,
    required this.onTap,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    // final progress = frequency / targetFrequency;
    // final clampedProgress = progress.clamp(0.0, 1.0);
    final color = Colors.blue.shade400;

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
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Drops representing frequency
              Positioned(
                bottom: size * 0.1,
                child: Column(
                  children: List.generate(
                    targetFrequency,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Icon(
                        Icons.water_drop,
                        size: size * 0.2,
                        color: index < frequency ? color : color.withAlpha(50),
                      ),
                    ),
                  ),
                ),
              ),
              // Main water icon
              Icon(
                Icons.opacity,
                size: size * 0.5,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$frequency/$targetFrequency',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'Times',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
