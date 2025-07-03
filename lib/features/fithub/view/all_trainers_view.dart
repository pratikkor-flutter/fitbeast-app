import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/features/fithub/controller/fithub_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTrainersView extends StatelessWidget {
  AllTrainersView({super.key});

  final FithubController controller = Get.find<FithubController>();
  final RxString _searchQuery = ''.obs;
  final Rx<SpecialtyFilter> _specialtyFilter = SpecialtyFilter.all.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Trainers', style: theme.textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Divider(
                  height: 0.1,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search trainers...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.onSurface.withAlpha(20),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => _searchQuery.value = value,
                ),
                const SizedBox(height: 12),
                Obx(() => Wrap(
                      spacing: 8,
                      children: SpecialtyFilter.values.map((filter) {
                        final isSelected = _specialtyFilter.value == filter;

                        return FilterChip(
                          padding: EdgeInsets.zero,
                          label: Text(filter.name),
                          labelStyle: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 0.5,
                              color: theme.colorScheme.outline.withAlpha(30),
                            ),
                          ),
                          onSelected: (selected) {
                            _specialtyFilter.value =
                                selected ? filter : SpecialtyFilter.all;
                          },
                        );
                      }).toList(),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final filteredTrainers = controller.trainers.where((trainer) {
                final matchesSearch = trainer['name']
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery.value.toLowerCase());
                final matchesSpecialty =
                    _specialtyFilter.value == SpecialtyFilter.all ||
                        trainer['speciality'] == _specialtyFilter.value.name;
                return matchesSearch && matchesSpecialty;
              }).toList();

              if (filteredTrainers.isEmpty && !controller.isLoading.value) {
                return Center(
                    child: Text('No trainers found',
                        style: theme.textTheme.bodyLarge));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredTrainers.length,
                itemBuilder: (context, index) {
                  final trainer = filteredTrainers[index];
                  return _buildTrainerCard(context, trainer);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(BuildContext context, Map<String, dynamic> trainer) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.toNamed('/trainer-details/${trainer['id']}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.primary.withAlpha(50),
                child: Text(
                  trainer['name'][0],
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trainer['name'],
                      style: theme.textTheme.titleMedium?.copyWith(
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '0',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.work_outline,
                            size: 20, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          trainer['experience'].toString(),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Get.find<FithubController>().sendConnectionRequest(trainer['id']);
                },
                child: Container(
                  width: 78,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Connect',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SpecialtyFilter {
  all('All'),
  yoga('Yoga'),
  crossfit('CrossFit'),
  hiit('HIIT'),
  bodybuilding('Bodybuilding'),
  swimming('Swimming');

  const SpecialtyFilter(this.name);
  final String name;
}
