import 'package:fitbeast/features/fithub/controller/fithub_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogDetailsView extends StatelessWidget {
  final String blogId;
  const BlogDetailsView({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final FithubController controller = Get.find<FithubController>();

    try {
      final blog = controller.blogs.firstWhere(
        (blogDetails) => blogDetails['id'] == Get.parameters['blogId'],
        orElse: () => throw 'Blog not found',
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text('Blog Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blog['imageUrl'] != null && blog['imageUrl'].isNotEmpty)
                Image.network(
                  blog['imageUrl'],
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    color: theme.colorScheme.onSurfaceVariant,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog['title'] ?? 'No Title',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              theme.colorScheme.primary.withAlpha(50),
                          child: Text(
                            (blog['author']?.toString().substring(0, 1) ?? 'A'),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog['author'] ?? 'Anonymous',
                              style: theme.textTheme.bodyLarge,
                            ),
                            Text(
                              controller.timeAgo(blog['date']),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    theme.colorScheme.onSurface.withAlpha(130),
                              ),
                            ),
                          ],
                        ),
                        //     const Spacer(),
                        //     InkWell(
                        //       onTap: (){

                        //       },
                        //       child: Icon(
                        //         Icons.favorite_border,
                        //         size: 24,
                        //         color: theme.colorScheme.primary,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 4),
                        //     Text(
                        //       (blog['likes']?.toString() ?? '0'),
                        //       style: theme.textTheme.bodyLarge,
                        //     ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      blog['desc'] ?? 'No description available',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(
                'Blog not found',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'The requested blog (ID: $blogId) could not be found',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
