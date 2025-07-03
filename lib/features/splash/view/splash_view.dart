import 'package:fitbeast/core/constants/app_assets.dart';
import 'package:fitbeast/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Center(
              child: Obx(() {
                return AnimatedOpacity(
                  opacity: controller.isLoading.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    AppAssets.splashLogo,
                    fit: BoxFit.contain,
                    width: context.width * 0.6,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
