import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/features/plans/controller/plans_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PlansView extends StatelessWidget {
  PlansView({super.key});

  final PlansController controller = Get.put(PlansController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Obx(() => Text(
                controller.currentTabIndex.value == 0
                    ? 'Your Diet Plan'
                    : 'Your Workout Plan',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              )),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.retry,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabButton(context, 'Diet', 0),
                    const SizedBox(width: 8),
                    _buildTabButton(context, 'Workout', 1),
                  ],
                )),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingAnimation();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorView(context);
        }

        if (controller.dietPlans.isEmpty) {
          final theme = Theme.of(context);
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Your Diet Plan Type',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'Veg',
                          label: Text('Veg Diet Plan'),
                          icon: Icon(Icons.spa_outlined),
                        ),
                        ButtonSegment(
                          value: 'Non-Veg',
                          label: Text('Non-Veg Diet Plan'),
                          icon: Icon(Icons.set_meal_outlined),
                        ),
                      ],
                      selected: {
                        controller.dietType.value
                      },
                      onSelectionChanged: (newSelection) {
                        controller.dietType.value = newSelection.first;
                      },
                      style: _segmentedButtonStyle(theme)),
                  const SizedBox(height: 24),
                  Center(
                    child: ButtonVariants.primary(
                      onPressed: () => controller.fetchPlans(),
                      text: 'Generate Plans',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return IndexedStack(
          index: controller.currentTabIndex.value,
          children: [
            _buildDietPlan(context),
            _buildWorkoutPlan(context),
          ],
        );
      }),
    );
  }

  ButtonStyle _segmentedButtonStyle(ThemeData theme) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return theme.cardColor.withAlpha(25);
      }),
      side: WidgetStateProperty.all(BorderSide(
        color: theme.dividerColor.withAlpha(130),
      )),
      textStyle: WidgetStateProperty.all(AppTextTheme.labelMedium),
    );
  }

  Widget _buildTabButton(BuildContext context, String text, int index) {
    final isSelected = controller.currentTabIndex.value == index;

    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withAlpha(140),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(5, (index) {
        return Shimmer(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            height: 120,
          ),
        );
      }),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load plans',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage.value,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.retry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDietPlan(BuildContext context) {
    final days = controller.dietPlans.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Your Personalized Nutrition Guide',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final meals = controller.dietPlans[day] as Map<String, dynamic>;
              return _buildDayCard(context, day, meals);
            },
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildDayCard(
      BuildContext context, String day, Map<String, dynamic> meals) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.onSurface.withAlpha(50),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    day,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: meals.entries.map((meal) {
                return _buildMealCard(context, meal.key, meal.value);
              }).toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * meals.length).ms);
  }

  Widget _buildMealCard(BuildContext context, String mealType, String meal) {
    final color = _getMealColor(mealType);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withAlpha(25),
            color.withAlpha(10),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(50),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getMealIcon(mealType),
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                mealType,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meal,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPlan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Daily Fitness Activities',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.workoutActivities.length,
                itemBuilder: (context, index) {
                  final activity = controller.workoutActivities[index];
                  return _buildActivityCard(context, activity, index);
                },
              )),
        ),
      ],
    );
  }

  Widget _buildActivityCard(BuildContext context, String activity, int index) {
    final duration = _extractDuration(activity);
    final activityName = _cleanActivityName(activity);
    final color = _getActivityColor(index);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getActivityIcon(activity),
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (duration != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      duration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(140),
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms);
  }

  // Helper methods for workout activities
  String? _extractDuration(String activity) {
    final regExp = RegExp(r'(\d+\s*min)');
    final match = regExp.firstMatch(activity);
    return match?.group(0);
  }

  String _cleanActivityName(String activity) {
    return activity.replaceAll(RegExp(r'\d+\s*min'), '').trim();
  }

  Color _getActivityColor(int index) {
    final colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
    ];
    return colors[index % colors.length];
  }

  IconData _getActivityIcon(String activity) {
    if (activity.toLowerCase().contains('walk')) return Icons.directions_walk;
    if (activity.toLowerCase().contains('yoga')) return Icons.self_improvement;
    if (activity.toLowerCase().contains('stretch')) return Icons.fitness_center;
    if (activity.toLowerCase().contains('cardio')) return Icons.directions_run;
    if (activity.toLowerCase().contains('breath')) return Icons.air;
    return Icons.sports_gymnastics;
  }

  // Helper methods for diet plan
  Color _getMealColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Colors.orangeAccent;
      case 'lunch':
        return Colors.greenAccent;
      case 'dinner':
        return Colors.blueAccent;
      case 'snacks':
        return Colors.purpleAccent;
      default:
        return Colors.redAccent;
    }
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snacks':
        return Icons.local_cafe;
      default:
        return Icons.restaurant;
    }
  }
}
