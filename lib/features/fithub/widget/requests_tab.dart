import 'package:fitbeast/features/fithub/controller/connections_controller.dart';
import 'package:fitbeast/models/connection_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsTab extends StatelessWidget {
  final ConnectionsController controller;

  const RequestsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final requests = controller.isTrainer.value 
            ? controller.pendingRequests
            : controller.sentRequests;
            
        return requests.isEmpty
            ? Center(
                child: Text(
                  controller.isTrainer.value 
                      ? 'No new requests'
                      : 'No pending requests',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                itemCount: requests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return _buildRequestItem(context, request, index);
                },
              );
      },
    );
  }

  Widget _buildRequestItem(
      BuildContext context, Connection request, int index) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
          backgroundColor: _getAvatarColor(request.name),
          child: Text(
            request.initials,
            style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ),
        title: Text(
          request.name,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: request.mutualConnections != null
            ? Text(
                request.mutualConnections!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: controller.isTrainer.value 
            ? Column(
                spacing: 2,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => controller.acceptRequest(request.id!),
                    child: Container(
                      width: 60,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Accept',
                        style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => controller.ignoreRequest(request.id!),
                    child: Container(
                      width: 60,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.onSurface.withAlpha(30)),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Ignore',
                        style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface),
                      ),
                    ),
                  ),
                ],
              )
            : Text(
                'Pending',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
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