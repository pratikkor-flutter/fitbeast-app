import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';

class TodayProgressCard extends StatelessWidget {
  final double caloriesProgress; // 0.0 - 1.0
  final double waterProgress; // 0.0 - 1.0
  final double sleepProgress; // 0.0 - 1.0

  const TodayProgressCard({
    super.key,
    required this.caloriesProgress,
    required this.waterProgress,
    required this.sleepProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final overallProgress =
        ((caloriesProgress + waterProgress + sleepProgress) / 3)
            .clamp(0.0, 1.0);

    return Card(
      color: theme.colorScheme.onPrimary,
      shadowColor: theme.colorScheme.onSurface.withAlpha(80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Progress',
                style: AppTextTheme.labelLarge
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              'Remaining = 100% - Avg(Calories + Water + Sleep)',
              style: AppTextTheme.bodySmall.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withAlpha(180)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Circular progress
                SizedBox(
                  width: 140.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 65.w,
                        height: 55.h,
                        child: CircularProgressIndicator(
                          value: overallProgress,
                          strokeWidth: 10,
                          backgroundColor: Theme.of(Get.context!)
                              .colorScheme
                              .onSurface
                              .withAlpha(50),
                          color: AppColors.primary,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(overallProgress * 100).toInt()}%',
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressTile(
                        icon: Icons.local_fire_department,
                        label: 'Calories',
                        value:
                            '${(caloriesProgress * 100).toStringAsFixed(1)}%',
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(height: 2),
                      _buildProgressTile(
                        icon: Icons.water_drop,
                        label: 'Water',
                        value: '${(waterProgress * 100).toStringAsFixed(1)}%',
                        iconColor: Colors.blueAccent,
                      ),
                      const SizedBox(height: 2),
                      _buildProgressTile(
                        icon: Icons.bedtime,
                        label: 'Sleep',
                        value: '${(sleepProgress * 100).toStringAsFixed(1)}%',
                        iconColor: Colors.deepPurpleAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(label, style: AppTextTheme.bodySmall),
        const Spacer(),
        Text(value,
            style: AppTextTheme.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}
