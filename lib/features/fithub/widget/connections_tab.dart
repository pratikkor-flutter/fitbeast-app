import 'package:fitbeast/features/fithub/controller/connections_controller.dart';
import 'package:fitbeast/models/connection_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionsTab extends StatelessWidget {
  final ConnectionsController controller;

  const ConnectionsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return controller.connections.isEmpty
            ? Center(
                child: Text(
                  'No connections found',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: controller.connections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final connection = controller.connections[index];
                  return _buildConnectionItem(context, connection);
                },
              );
      },
    );
  }

  Widget _buildConnectionItem(BuildContext context, Connection connection) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: _getAvatarColor(connection.name),
          child: Text(
            connection.initials,
            style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ),
        title: Text(
          connection.name,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: connection.mutualConnections != null
            ? Text(
                connection.mutualConnections!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        
      ),
    );
  }

  Color _getAvatarColor(String name) {
    const colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    return colors[name.hashCode % colors.length];
  }
}