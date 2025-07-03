import 'package:fitbeast/features/challenges/binding/challenge_binding.dart';
import 'package:fitbeast/features/challenges/view/challenge_view.dart';
import 'package:fitbeast/features/fithub/binding/fithub_binding.dart';
import 'package:fitbeast/features/fithub/view/fithub_view.dart';
import 'package:fitbeast/features/home/binding/home_binding.dart';
import 'package:fitbeast/features/home/view/home_view.dart';
import 'package:fitbeast/features/more/binding/more_binding.dart';
import 'package:fitbeast/features/more/view/more_view.dart';
import 'package:fitbeast/features/navbar/widgets/custom_navbar_widget.dart';
import 'package:fitbeast/features/plans/binding/plans_binding.dart';
import 'package:fitbeast/features/plans/view/plans_view.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppShell extends StatelessWidget {
  final NavigatorObserver observer = Get.put(NavigatorObserver());

  AppShell({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Navigator(
          key: Get.nestedKey(1),
          initialRoute: Routes.home,
          observers: [observer],
          onGenerateRoute: (settings) => onGenerateRouteCallback(settings),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CustomNavbarWidget(),
        ),
      ],
    );
  }

  GetPageRoute onGenerateRouteCallback(settings) {
    Bindings binding;
    Widget page;

    switch (settings.name) {
      case Routes.home:
        page = const HomeView();
        binding = HomeBinding();
        break;
      case Routes.plans:
        page = PlansView();
        binding = PlansBinding();
      case Routes.community:
        page = FithubView();
        binding = FithubBinding();
      case Routes.challenges:
        page = ChallengeView();
        binding = ChallengeBinding();
      case Routes.more:
        page = MoreView();
        binding = MoreBinding();
      default:
        page = const HomeView();
        binding = HomeBinding();
        break;
    }

    return GetPageRoute(
      settings: settings,
      page: () => page,
      binding: binding,
    );
  }
}
