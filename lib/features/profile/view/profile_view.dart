import 'dart:developer';

import 'package:fitbeast/features/home/controller/home_controller.dart';
import 'package:fitbeast/features/home/widgets/circular_avtar_widget.dart';
import 'package:fitbeast/features/profile/widgets/cover_carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/features/profile/controller/profile_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            leading: InkWell(
              onTap: Get.back,
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              background: CoverImageCarousel(
                imageUrls: [
                  "assets/images/gym_boarding.png",
                  "assets/images/gym_boarding.png",
                  "assets/images/gym_boarding.png",
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // Profile Header
                  _buildProfileHeader(context),
                  const SizedBox(height: 24),

                  // Level Progress
                  _buildLevelProgress(context),
                  const SizedBox(height: 32),

                  // Stats Grid
                  _buildStatsGrid(context),
                  const SizedBox(height: 32),

                  // Achievements
                  _buildAchievementsSection(context),
                  const SizedBox(height: 32),

                  // Fitness Stats
                  _buildFitnessStats(context),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);


    return Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Placeholder with Level Badge
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircularAvatarWithInitials(
                  name: Get.find<HomeController>().name.value,
                  radius: 50,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getLevelColor(controller.userLevel.value),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.userLevel.value,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Get.find<HomeController>().name.value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.userPoints.value} XP',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => _showEditNameDialog(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildLevelProgress(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() => Column(
          children: [
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              animation: true,
              lineHeight: 12,
              animationDuration: 1000,
              percent: controller.progressToNextLevel.value,
              barRadius: const Radius.circular(10),
              progressColor: _getLevelColor(controller.userLevel.value),
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${controller.userLevel.value}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(controller.progressToNextLevel.value * 100).toStringAsFixed(0)}% to next level',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Obx(() => GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildStatCard(
              context,
              icon: Icons.local_fire_department,
              value: controller.daysStreak.value.toString(),
              label: 'Day Streak',
              color: Colors.orangeAccent,
            ),
            _buildStatCard(
              context,
              icon: Icons.fitness_center,
              value: controller.userPoints.value.toString(),
              label: 'Workouts',
              color: Colors.blueAccent,
            ),
            _buildStatCard(
              context,
              icon: Icons.emoji_events,
              value: controller.challengesWon.value.toString(),
              label: 'Challenges',
              color: Colors.purpleAccent,
            ),
          ],
        ));
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.achievementsList.length,
                  itemBuilder: (context, index) {
                    final achievement = controller.achievementsList[index];
                    return _buildAchievementBadge(
                      context,
                      achievement.title,
                      achievement.icon,
                      achievement.color,
                    );
                  },
                )),
          ],
        ));
  }

  Widget _buildAchievementBadge(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessStats(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitness Stats',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withAlpha(15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: controller.fitnessStats.entries.map((entry) {
                  log(controller.fitnessStats.toString());
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(140),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          entry.value.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ));
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'gold':
        return Colors.amber;
      case 'silver':
        return Colors.grey;
      case 'bronze':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  void _showEditNameDialog(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ProfileController>();
    final textController =
        TextEditingController(text: Get.find<HomeController>().name.value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Name',
            style: theme.textTheme.titleLarge,
          ),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  controller.updateName(textController.text.trim());
                }
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
