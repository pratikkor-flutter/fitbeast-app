import 'package:fitbeast/features/more/controller/write_blog_controller.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/core/utils/custom_textfield.dart';

class WriteBlogsView extends StatelessWidget {
  WriteBlogsView({super.key});

  final WriteBlogController controller = Get.put(WriteBlogController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write your Blog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: controller.submitBlog,
          ),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(theme),
                const SizedBox(height: 32),

                // Title Input
                _buildTitleField(controller),
                const SizedBox(height: 20),

                // Description Input
                _buildDescField(controller),
                const SizedBox(height: 20),

                // Author Input
                _buildAuthorField(controller),
                const SizedBox(height: 20),

                // Image URL Input
                _buildImageUrlField(controller),
                const SizedBox(height: 20),

                // Error Message
                if (controller.errorMessage.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      controller.errorMessage.value,
                      style: AppTextTheme.bodySmall.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),

                // Submit Button
                const SizedBox(height: 40),
                _buildSubmitButton(theme, controller),
              ],
            ),
          )),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Your Blog',
          style: AppTextTheme.displaySmall
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 8),
        Text(
          'Share your fitness knowledge with the community',
          style: AppTextTheme.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(WriteBlogController controller) {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.titleController,
      labelText: 'Blog Title',
      prefixIcon: Icons.title,
    );
  }

  Widget _buildDescField(WriteBlogController controller) {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.descController,
      labelText: 'Blog Description',
      // prefixIcon: Icons.description,
      maxlines: 8,
    );
  }

  Widget _buildAuthorField(WriteBlogController controller) {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.authorController,
      labelText: 'Author Name',
      prefixIcon: Icons.person,
    );
  }

  Widget _buildImageUrlField(WriteBlogController controller) {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.imageUrlController,
      labelText: 'Image URL (optional)',
      prefixIcon: Icons.image,
    );
  }

  Widget _buildSubmitButton(ThemeData theme, WriteBlogController controller) {
    return Center(
      child: ButtonVariants.primary(
          onPressed: controller.submitBlog, text: 'Publish Blog'),
    );
  }
}
