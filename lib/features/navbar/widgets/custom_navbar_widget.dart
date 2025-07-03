import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/features/navbar/controller/navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavbarWidget extends StatelessWidget {
  const CustomNavbarWidget({super.key});

  static const items = [
    _NavbarItem(Icons.home_outlined, Icons.home, 'Home'),
    _NavbarItem(Icons.calendar_today_outlined, Icons.calendar_today, 'Plans'),
    _NavbarItem(Icons.people_outline, Icons.people, 'FitHub'),
    _NavbarItem(Icons.emoji_events_outlined, Icons.emoji_events, 'Quests'),
    _NavbarItem(Icons.menu_rounded, Icons.menu_rounded, 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = NavbarController.to.currentIndex.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Center(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(25),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final selected = index == currentIndex;

                return _AnimatedNavbarButton(
                  icon: selected ? item.activeIcon : item.icon,
                  label: item.label,
                  selected: selected,
                  onTap: () => NavbarController.to.changeTab(index),
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}

class _AnimatedNavbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AnimatedNavbarButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.primary.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.primary : theme.iconTheme.color,
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextTheme.labelSmall.copyWith(
                color: selected
                    ? AppColors.primary
                    : theme.textTheme.bodySmall?.color,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavbarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavbarItem(this.icon, this.activeIcon, this.label);
}
