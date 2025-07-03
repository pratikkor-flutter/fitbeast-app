import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/features/fithub/controller/fithub_controller.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBlogsView extends StatelessWidget {
  AllBlogsView({super.key});

  final FithubController controller = Get.find<FithubController>();
  final RxString _searchQuery = ''.obs;
  final Rx<BlogFilter> _currentFilter = BlogFilter.mostRecent.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Blogs', style: theme.textTheme.headlineSmall),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 0.1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search blogs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => _searchQuery.value = value,
            ),
          ),
          Expanded(
            child: Obx(() {
              // Apply both search and filter
              final filteredBlogs = _applyFilters(
                controller.blogs,
                _searchQuery.value,
                _currentFilter.value,
              );

              if (filteredBlogs.isEmpty && !controller.isLoading.value) {
                return Center(
                  child: Text(
                    'No blogs found',
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredBlogs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final blog = filteredBlogs[index];
                  return _buildBlogCard(context, blog);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _applyFilters(
    List<Map<String, dynamic>> blogs,
    String searchQuery,
    BlogFilter filter,
  ) {
    // First apply search filter
    var result = blogs.where((blog) {
      return blog['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    // Then apply sorting based on selected filter
    switch (filter) {
      case BlogFilter.mostRecent:
        result.sort((a, b) => b['date'].compareTo(a['date']));
        break;
      case BlogFilter.mostPopular:
        result.sort((a, b) => (b['likes'] as int).compareTo(a['likes'] as int));
        break;
    }

    return result;
  }

  Widget _buildBlogCard(BuildContext context, Map<String, dynamic> blog) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // onTap: () => Get.toNamed('/blog-details?id=${blog['id']}'),
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
              Image.network(
                blog['imageUrl'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: theme.colorScheme.onSurfaceVariant,
                  child: const Icon(Icons.broken_image),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            theme.colorScheme.primary.withAlpha(50),
                        child: Text(
                          blog['author'].toString().substring(0, 1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        blog['author'],
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      // Icon(
                      //   Icons.favorite_border,
                      //   size: 16,
                      //   color: theme.colorScheme.primary,
                      // ),
                      // const SizedBox(width: 4),
                      // Text(
                      //   blog['likes'].toString(),
                      //   style: theme.textTheme.bodySmall,
                      // ),
                      // const SizedBox(width: 8),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.timeAgo(blog['date']),
                        style: theme.textTheme.bodySmall,
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
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Obx(() => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Blogs',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ...BlogFilter.values.map((filter) {
                    return ListTile(
                      title: Text(
                        filter.displayName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: _currentFilter.value == filter
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: _currentFilter.value == filter
                          ? Icon(
                              Icons.check,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        _currentFilter.value = filter;
                        Get.back();
                      },
                    );
                  }),
                ],
              ),
            ));
      },
    );
  }
}

enum BlogFilter {
  mostRecent('Most Recent'),
  mostPopular('Most Popular');

  const BlogFilter(this.displayName);
  final String displayName;
}
