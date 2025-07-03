import 'package:fitbeast/features/fithub/controller/fithub_controller.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllGroupsView extends StatelessWidget {
  AllGroupsView({super.key});

  final FithubController controller = Get.find<FithubController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Groups', style: theme.textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.groups.isEmpty && !controller.isLoading.value) {
          return Center(
            child: Text('No groups found', style: theme.textTheme.bodyLarge),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchGroups(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: controller.groups.length,
            itemBuilder: (context, index) {
              final group = controller.groups[index];
              final groupColor = controller.getColor(index);
              return _buildGroupCard(theme, group, groupColor);
            },
          ),
        );
      }),
    );
  }

  Widget _buildGroupCard(ThemeData theme, Map<String, dynamic> group, Color groupColor) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Get.toNamed(Routes.groupCommunityChat,arguments:  group['id']),
      child: Container(
        decoration: BoxDecoration(
          color: groupColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: groupColor.withAlpha(80),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    group['icon'],
                    size: 40,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    group['name'],
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}