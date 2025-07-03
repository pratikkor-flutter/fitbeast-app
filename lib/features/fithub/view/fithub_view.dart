import 'package:fitbeast/core/constants/app_assets.dart';
import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/features/fithub/widget/button.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/features/fithub/controller/fithub_controller.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class FithubView extends StatelessWidget {
  final FithubController controller = Get.put(FithubController());

  FithubView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'FitConnect',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt_1_rounded,
                color: colorScheme.onSurface),
            onPressed: () => Get.toNamed(Routes.connect),
          ),
          // IconButton(
          //   icon: Icon(Icons.message, color: colorScheme.onSurface),
          //   onPressed: () => Get.toNamed(Routes.chat),
          // ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoading(context);
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchAllData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 0.1,
                ),
                const SizedBox(height: 4),
                _buildHeaderSection(theme, 'Popular Groups'),
                const SizedBox(height: 12),
                _buildGroupsSection(theme),
                const SizedBox(height: 24),
                _buildHeaderSection(theme, 'Trainers'),
                const SizedBox(height: 12),
                _buildTrainersSection(theme),
                const SizedBox(height: 24),
                _buildHeaderSection(theme, 'Latest Blogs'),
                const SizedBox(height: 12),
                _buildBlogsSection(theme),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Shimmer(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey,
              margin: const EdgeInsets.only(bottom: 20),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (_, __) => Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.grey,
              margin: const EdgeInsets.only(bottom: 20),
            ),
            ...List.generate(
              4,
              (index) => Container(
                height: 80,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            List<String> parts = title.trim().split(' ');
            String route = 'all-${parts[1]}';
            // Navigate to see all
            Get.toNamed('/${route.toLowerCase()}');
          },
          child: Text(
            'See all',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupsSection(ThemeData theme) {
    return SizedBox(
      height: 140,
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.blogs.take(4).length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final group = controller.groups[index];
            Color groupColor = controller.getColor(index);
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Get.toNamed(Routes.groupCommunityChat,
                  arguments: group['id']),
              // onTap: () => Get.toNamed(Routes.groupCommunityChat),
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(12),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(group['icon'],
                        color: theme.colorScheme.onSurface, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      group['name'],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrainersSection(ThemeData theme) {
    return Obx(
      () => Column(
        children: controller.trainers.take(3).map((trainer) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.colorScheme.onSurface.withAlpha(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Get.toNamed('/trainer/${trainer['id']}'),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primary.withAlpha(50),
                      child: Text(
                        trainer['name'][0],
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trainer['name'],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trainer['speciality'],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '0',
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.location_on_outlined,
                                  color: theme.colorScheme.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                trainer['gym'],
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TrainerConnectButton(trainerId: trainer['id']),

                    // InkWell(
                    //   onTap: () {
                    //     Get.find<FithubController>().sendConnectionRequest(trainer['id']);
                    //   },
                    //   child: Container(
                    //     width: 78,
                    //     height: 30,
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: theme.colorScheme.primary,
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: Text(
                    //       'Connect',
                    //       style: theme.textTheme.bodySmall?.copyWith(
                    //         fontWeight: FontWeight.w600,
                    //         color: theme.colorScheme.onPrimary,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBlogsSection(ThemeData theme) {
    return Obx(
      () => Column(
        children: controller.blogs.take(3).map((blog) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.cardColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (blog['id'] != null) {
                  Get.toNamed(
                    Routes.blogDetails,
                    parameters: {'blogId': blog['id'].toString()},
                  );
                } else {
                  showFitSnackbar('Blog ID is missing', isError: true);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (blog['imageUrl'] != null && blog['imageUrl'].isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        blog['imageUrl'],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(AppAssets.splashLogo);
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blog['title'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          blog['desc'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(200),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Icon(Icons.favorite_border,
                            //     color: theme.colorScheme.primary, size: 16),
                            // const SizedBox(width: 4),
                            // Text(
                            //   '${blog['likes']} likes',
                            //   style: theme.textTheme.bodySmall,
                            // ),
                            const SizedBox(width: 16),
                            Icon(Icons.person_outline,
                                color: theme.colorScheme.primary, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              blog['author'],
                              style: theme.textTheme.bodySmall,
                            ),
                            const Spacer(),
                            Text(
                              controller.timeAgo(blog['date']),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    theme.colorScheme.onSurface.withAlpha(130),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
