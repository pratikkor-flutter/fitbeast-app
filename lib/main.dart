import 'package:firebase_core/firebase_core.dart';
import 'package:fitbeast/core/theme/app_theme.dart';
import 'package:fitbeast/firebase_options.dart';
import 'package:fitbeast/routes/app_pages.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:fitbeast/services/local_storage_hive/init_hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // init hive
  await InitHive().initHive();

  runApp(const FitBeast());
}

class FitBeast extends StatelessWidget {
  const FitBeast({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => GetMaterialApp(
        title: 'FitBeast',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        // themeMode: ThemeService().theme,.
        themeMode: ThemeMode.system,
        initialRoute: Routes.initial,
        getPages: AppPages.pages,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        opaqueRoute: Get.isOpaqueRouteDefault,
        popGesture: Get.isPopGestureEnable,
        enableLog: true,
        logWriterCallback: Logger.write,
        smartManagement: SmartManagement.keepFactory,
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
      ),
    );
  }
}

// Custom logger for GetX
class Logger {
  static void write(String text, {bool isError = false}) {
    if (isError || Get.isLogEnable) {
      debugPrint('** $text ${isError ? '[ERROR]' : ''}');
    }
  }
}
