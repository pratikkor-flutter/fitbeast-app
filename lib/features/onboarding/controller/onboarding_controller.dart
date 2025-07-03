import 'package:fitbeast/features/onboarding/widgets/onboarding_page.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:fitbeast/services/local_storage_get/local_storage_get.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnboardingController extends GetxController {
  final LiquidController liquidController = LiquidController();
  final RxInt currentPageIndex = 0.obs;
  final RxBool showSkipButton = true.obs;

  final List<OnboardingPage> onboardingPages = const [
    OnboardingPage(
      imagePath: "assets/images/gym_boarding.png",
      title: "Elevate Your Training",
      subtitle:
          "Achieve your fitness goals with personalized workout routines and progress tracking",
    ),
    OnboardingPage(
      imagePath: 'assets/images/yoga_boarding.png',
      title: 'Breathe and Balance',
      subtitle:
          'Experience a peaceful journey toward flexibility, strength, and mindfulness',
    ),
    OnboardingPage(
      imagePath: 'assets/images/diet_boarding.png',
      title: 'Fuel Your Body Right',
      subtitle:
          'Stay on top of your nutrition with tailored meal plans and diet insights',
    ),
  ];

  bool get isLastPage => currentPageIndex.value == onboardingPages.length - 1;

  String get currentTitle => onboardingPages[currentPageIndex.value].title;
  String get currentSubtitle =>
      onboardingPages[currentPageIndex.value].subtitle;

  void onPageChanged(int activePageIndex) {
    currentPageIndex.value = activePageIndex;
    showSkipButton.value = !isLastPage;
  }

  Future<void> skipOnboarding() async {
    Get.offNamed(Routes.login);
    // update onboarding status in get storage
    await LocalStorageGet().setOnboardingComplete();
  }

  Future<void> completeOnboarding() async {
    Get.offNamed(Routes.login);
    // update onboarding status in get storage
    await LocalStorageGet().setOnboardingComplete();
  }

  void animateToNextPage() {
    if (!isLastPage) {
      // increment the page index
      liquidController.animateToPage(page: currentPageIndex.value + 1);
    }
  }
}
