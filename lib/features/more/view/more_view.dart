import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/features/more/controller/more_controller.dart';

class MoreView extends StatelessWidget {
  MoreView({super.key});

  final MoreController controller = Get.put(MoreController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'More Options',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(height: 0.1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSectionHeader(context, 'Account'),
                _buildTile(
                  context,
                  icon: Icons.person_outline,
                  label: 'Profile',
                  onTap: () => controller.navigateTo(Routes.profile),
                ),
                _buildTile(
                  context,
                  icon: Icons.article,
                  label: 'Write your blog',
                  onTap: () => controller.navigateTo(Routes.writeBlogs),
                ),
                _buildTile(
                  context,
                  icon: Icons.sports_gymnastics_rounded,
                  label: 'Apply as a Trainer',
                  onTap: () async {
                    if (await controller.checkForTrainerStatus()) {
                      showFitSnackbar('Already Qualified as Trainer');
                    } else {
                      controller.navigateTo(Routes.applyAsTrainer);
                    }
                  },
                ),
                _buildSectionHeader(context, 'Preferences'),
                Obx(() => _buildTile(
                      context,
                      icon: controller.isDarkTheme.value
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      label: controller.isDarkTheme.value
                          ? 'Light Mode'
                          : 'Dark Mode',
                      onTap: controller.toggleTheme,
                      trailing: AnimatedContainer(
                        duration: 300.milliseconds,
                        child: Transform.scale(
                          scale: 0.75,
                          child: Switch(
                            value: controller.isDarkTheme.value,
                            onChanged: (_) => controller.toggleTheme(),
                            activeColor: colorScheme.primary,
                            activeTrackColor: colorScheme.primary.withAlpha(80),
                          ),
                        ),
                      ),
                    )),
                _buildSectionHeader(context, 'Support'),
                _buildTile(
                  context,
                  icon: Icons.help_outline,
                  label: 'Help Center',
                  onTap: () => controller.navigateTo(Routes.help),
                ),
                _buildTile(
                  context,
                  icon: Icons.article_outlined,
                  label: 'Terms & Conditions',
                  onTap: () => controller.navigateTo(Routes.termsAndConditions),
                ),
                _buildTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () => controller.navigateTo(Routes.privacyPolicy),
                ),
                _buildTile(
                  context,
                  icon: Icons.info_outline,
                  label: 'About FitBeast',
                  onTap: () => controller.navigateTo(Routes.aboutFitbeast),
                ),
                _buildSectionHeader(context, 'Actions'),
                _buildTile(
                  context,
                  icon: Icons.logout,
                  label: 'Log Out',
                  onTap: () async {
                    await controller.logout();
                  },
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(140),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withAlpha(25),
          width: 1,
        ),
      ),
      child: ListTile(
        splashColor: AppColors.primary.withAlpha(180),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (iconColor ?? colorScheme.primary).withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: textColor ?? colorScheme.onSurface,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface.withAlpha(130),
            ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minLeadingWidth: 0,
      ),
    );
  }
}
