import 'package:fitbeast/features/fithub/controller/connections_controller.dart';
import 'package:fitbeast/features/fithub/widget/connections_tab.dart';
import 'package:fitbeast/features/fithub/widget/requests_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionsView extends StatelessWidget {
  final ConnectionsController controller = Get.put(ConnectionsController());

  ConnectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connections'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(36),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabButton(context, 'Requests', 0),
                      const SizedBox(width: 8),
                      _buildTabButton(context, 'Connections', 1),
                    ],
                  )),
            ),
          ),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search beast...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).colorScheme.onSurface.withAlpha(20),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: controller.updateSearchQuery,
              ),
            ),
            // TabBarView
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: controller.currentTabIndex.value,
                  children: [
                    RequestsTab(controller: controller),
                    ConnectionsTab(controller: controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String text, int index) {
    final isSelected = controller.currentTabIndex.value == index;

    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTabIndex(index),
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
}
