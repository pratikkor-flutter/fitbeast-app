import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GymVoucherCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> vouchers = [
    {
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPCZRK5cyLt0RClR0K4nvGOoWgN_030Zhwvg&s',
      'title': 'Summer Special',
      'gymName': 'FitBeast Premium Gym',
      'address': '123 Fitness Street, Health District',
      'location': 'https://maps.app.goo.gl/example123',
      'couponCode': 'SUMMER2023',
      'validUntil': 'December 31, 2023',
      'description':
          'Get 50% off on annual membership. Includes access to all group classes and 2 personal training sessions.',
      'terms':
          'Valid for new members only. Cannot be combined with other offers.',
    },
    {
      'imageUrl':
          'https://media-cldnry.s-nbcnews.com/image/upload/t_social_share_1200x630_center,f_auto,q_auto:best/rockcms/2023-08/shy-girl-workout-tiktok-mc-230828-02-ab104e.jpg',
      'title': 'Weekend Pass',
      'gymName': 'Urban Fitness Club',
      'address': '456 Workout Avenue, Downtown',
      'location': 'https://maps.app.goo.gl/example456',
      'couponCode': 'WEEKEND25',
      'validUntil': 'Ongoing',
      'description':
          'Free weekend pass for you and a friend. Try our premium facilities for two full days.',
      'terms': 'Must be 18+ to redeem. First-time visitors only.',
    },
    {
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_agvXLDuRQ2ceJMOO5AibdiKs4_Od2Yevkg&s',
      'title': 'New Member Offer',
      'gymName': 'Powerhouse Gym',
      'address': '789 Muscle Road, Fitness City',
      'location': 'https://maps.app.goo.gl/example789',
      'couponCode': 'NEWFIT30',
      'validUntil': 'March 31, 2024',
      'description':
          '30% discount for first 3 months. Includes free fitness assessment.',
      'terms': 'Requires 12-month commitment. Enrollment fee waived.',
    },
    {
      'imageUrl':
          'https://static.vecteezy.com/system/resources/previews/025/888/481/non_2x/beautiful-athletic-muscular-woman-pumps-up-the-muscles-by-one-arm-lifts-dumbbell-exercise-on-bench-in-fitness-gym-young-sport-girl-gains-strong-physical-muscle-well-by-weight-lifted-in-fitness-studio-photo.jpg',
      'title': 'Personal Training',
      'gymName': 'Elite Performance Center',
      'address': '321 Athlete Boulevard, Sports Complex',
      'location': 'https://maps.app.goo.gl/example321',
      'couponCode': 'PERSONAL10',
      'validUntil': 'January 15, 2024',
      'description':
          '10% off all personal training packages. Choose from our certified trainers.',
      'terms': 'Minimum 5 sessions required. New clients only.',
    },
  ];

  GymVoucherCarousel({super.key});

  void _showVoucherDetails(BuildContext context, Map<String, dynamic> voucher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          voucher['title'],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gym Info
              _buildDetailRow(Icons.fitness_center, voucher['gymName']),
              _buildDetailRow(Icons.location_on, voucher['address']),
              const SizedBox(height: 16),

              // Coupon Code
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.onSurfaceLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CODE: ${voucher['couponCode']}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Validity
              _buildDetailRow(Icons.calendar_today,
                  'Valid until: ${voucher['validUntil']}'),
              const SizedBox(height: 16),

              // Description
              Text(
                'Offer Details:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                voucher['description'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurface.withOpacity(0.9),
                    ),
              ),
              const SizedBox(height: 16),

              // Terms
              Text(
                'Terms & Conditions:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                voucher['terms'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurface.withOpacity(0.8),
                    ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:
                const Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onSurfaceLight,
              foregroundColor: AppColors.primary,
            ),
            onPressed: () {
              // Add functionality to redeem voucher
              Get.back();
              showFitSnackbar(
                  'Your ${voucher['title']} code has been copied to clipboard');
            },
            child: const Text('Redeem Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurface),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 600),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        disableCenter: true,
        enableInfiniteScroll: true,
        scrollDirection: Axis.horizontal,
      ),
      items: vouchers.map((voucher) {
        return GestureDetector(
          onTap: () => _showVoucherDetails(context, voucher),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onPrimary.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.network(
                    voucher['imageUrl'],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.error),
                      );
                    },
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.onPrimary.withOpacity(0.7),
                          AppColors.onPrimary.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),

                  // Voucher Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucher['title'],
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
