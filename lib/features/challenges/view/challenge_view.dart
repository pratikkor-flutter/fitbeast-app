import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/features/challenges/controller/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengeView extends StatelessWidget {
  ChallengeView({super.key});

  final ChallengeController controller = Get.put(ChallengeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Your Challenges',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 0.1,
            ),
            const SizedBox(height: 16),
            // Tab Bar
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border.all(
                      width: 0.5,
                      color: theme.colorScheme.outline.withAlpha(50)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTab(
                      context,
                      label: 'Daily',
                      isSelected:
                          controller.selectedTab.value == ChallengeTab.daily,
                      onTap: () => controller.changeTab(ChallengeTab.daily),
                    ),
                    _buildTab(
                      context,
                      label: 'Weekly',
                      isSelected:
                          controller.selectedTab.value == ChallengeTab.weekly,
                      onTap: () => controller.changeTab(ChallengeTab.weekly),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Filter Chips
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      context,
                      label: 'Active',
                      isSelected: controller.selectedFilter.value ==
                          ChallengeFilter.active,
                      onSelected: (_) =>
                          controller.changeFilter(ChallengeFilter.active),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      context,
                      label: 'Completed',
                      isSelected: controller.selectedFilter.value ==
                          ChallengeFilter.completed,
                      onSelected: (_) =>
                          controller.changeFilter(ChallengeFilter.completed),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      context,
                      label: 'Upcoming',
                      isSelected: controller.selectedFilter.value ==
                          ChallengeFilter.upcoming,
                      onSelected: (_) =>
                          controller.changeFilter(ChallengeFilter.upcoming),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Challenge List
            Expanded(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildChallengeList(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required ValueChanged<bool> onSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
      ),
      selectedColor: colorScheme.primary,
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(width: 0.5, color: colorScheme.outline.withAlpha(30)),
      ),
    );
  }

  Widget _buildChallengeList(BuildContext context) {
    final theme = Theme.of(context);
    List filteredChallenges = [];

    if (controller.selectedFilter.value == ChallengeFilter.upcoming) {
      filteredChallenges = controller.selectedTab.value == ChallengeTab.daily
          ? controller.upcomingDailyChallenges
          : controller.upcomingWeeklyChallenges;
    } else {
      filteredChallenges = controller.filteredChallenges.where((challenge) {
        return challenge['filter'] == controller.selectedFilter.value;
      }).toList();
    }

    if (filteredChallenges.isEmpty) {
      // TODO: add image to show no challenge for now
      return Center(
        child: Text(
          'No ${controller.selectedFilter.value.toString().split('.').last} challenges',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(130),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredChallenges.length,
      itemBuilder: (context, index) {
        final challenge = filteredChallenges[index];
        return _buildChallengeCard(context, challenge);
      },
    );
  }

  Widget _buildChallengeCard(
      BuildContext context, Map<String, dynamic> challenge) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline.withAlpha(25)),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(
            challenge['icon'] ?? Icons.flag,
            color: colorScheme.primary,
          ),
          title: Text(challenge['title'], style: theme.textTheme.titleMedium),
          subtitle:
              Text(challenge['description'], style: theme.textTheme.bodyMedium),
          trailing: challenge['filter'] == ChallengeFilter.active
              ? SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    value: double.parse(challenge['progress'].toString()) / 100,
                    strokeWidth: 6,
                    color: colorScheme.secondary,
                    backgroundColor: colorScheme.onSurface.withAlpha(30),
                  ),
                )
              : challenge['filter'] == ChallengeFilter.completed
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 24,
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '20 pts',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(color: colorScheme.secondary),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () async {
                        await controller.acceptChallenge(challenge);
                        showFitSnackbar(
                            'Challenge "${challenge['title']}" added to active');
                      },
                      child: Container(
                        width: 60,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Accept',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
          onTap: () async {
            // Handle challenge tap
            if (challenge['filter'] == ChallengeFilter.active) {
              await controller.logChallengeProgress(challenge['id']);
            }
          },
        ),
      ),
    );
  }
}
