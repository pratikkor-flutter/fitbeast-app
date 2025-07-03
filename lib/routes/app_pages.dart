import 'package:fitbeast/features/auth/binding/auth_binding.dart';
import 'package:fitbeast/features/auth/view/login_view.dart';
import 'package:fitbeast/features/auth/view/register_view.dart';
import 'package:fitbeast/features/challenges/binding/challenge_binding.dart';
import 'package:fitbeast/features/challenges/view/challenge_view.dart';
import 'package:fitbeast/features/fithub/binding/chat_binding.dart';
import 'package:fitbeast/features/fithub/binding/connections_binding.dart';
import 'package:fitbeast/features/fithub/binding/fithub_binding.dart';
import 'package:fitbeast/features/fithub/view/all_blogs_view.dart';
import 'package:fitbeast/features/fithub/view/all_groups_view.dart';
import 'package:fitbeast/features/fithub/view/all_trainers_view.dart';
import 'package:fitbeast/features/fithub/view/blog_details_view.dart';
import 'package:fitbeast/features/fithub/view/chat_view.dart';
import 'package:fitbeast/features/fithub/view/connections_view.dart';
import 'package:fitbeast/features/fithub/view/fithub_view.dart';
import 'package:fitbeast/features/fithub/view/group_community_chat_view.dart';
import 'package:fitbeast/features/home/binding/home_binding.dart';
import 'package:fitbeast/features/home/view/home_view.dart';
import 'package:fitbeast/features/more/binding/more_binding.dart';
import 'package:fitbeast/features/more/view/about_fitbeast_view.dart';
import 'package:fitbeast/features/more/view/apply_as_trainer_view.dart';
import 'package:fitbeast/features/more/view/help_view.dart';
import 'package:fitbeast/features/more/view/more_view.dart';
import 'package:fitbeast/features/more/view/privacy_policy_view.dart';
import 'package:fitbeast/features/more/view/terms_and_conditions.dart';
import 'package:fitbeast/features/more/view/write_blogs_view.dart';
import 'package:fitbeast/features/navbar/binding/navbar_binding.dart';
import 'package:fitbeast/features/navbar/view/app_shell.dart';
import 'package:fitbeast/features/onboarding/binding/onboarding_binding.dart';
import 'package:fitbeast/features/onboarding/view/onboarding_view.dart';
import 'package:fitbeast/features/plans/binding/plans_binding.dart';
import 'package:fitbeast/features/plans/view/plans_view.dart';
import 'package:fitbeast/features/post_reg_onboarding/binding/post_reg_onboarding_binding.dart';
import 'package:fitbeast/features/post_reg_onboarding/view/post_reg_onboarding_view.dart';
import 'package:fitbeast/features/post_reg_onboarding/view/post_reg_onboarding_success_view.dart';
import 'package:fitbeast/features/profile/binding/profile_binding.dart';
import 'package:fitbeast/features/profile/view/profile_view.dart';
import 'package:fitbeast/features/splash/binding/splash_binding.dart';
import 'package:fitbeast/features/splash/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/routes/app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.initial,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      fullscreenDialog: false,
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.postReg,
      page: () => PostRegOnboardingView(),
      binding: PostRegOnboardingBinding(),
    ),
    GetPage(
      name: Routes.postRegOnboardingSuccess,
      page: () => const PostRegOnboardingSuccessView(),
    ),
    GetPage(
      name: Routes.appShell,
      page: () => AppShell(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.plans,
      page: () => PlansView(),
      binding: PlansBinding(),
    ),
    GetPage(
      name: Routes.community,
      page: () => FithubView(),
      binding: FithubBinding(),
    ),
    GetPage(
      name: Routes.groupCommunityChat,
      page: () => GroupCommunityChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.connect,
      page: () => ConnectionsView(),
      binding: ConnectionsBinding(),
    ),
    GetPage(
      name: Routes.allGroups,
      page: () => AllGroupsView(),
      binding: FithubBinding(),
    ),
    GetPage(
      name: Routes.allTrainers,
      page: () => AllTrainersView(),
      binding: FithubBinding(),
    ),
    GetPage(
      name: Routes.allBlogs,
      page: () => AllBlogsView(),
      binding: FithubBinding(),
    ),
    GetPage(
      name: Routes.blogDetails,
      page: () {
        final blogId = Get.parameters['blogId'];
        return BlogDetailsView(blogId: blogId!);
      },
      binding: FithubBinding(),
    ),
    GetPage(
      name: Routes.challenges,
      page: () => ChallengeView(),
      binding: ChallengeBinding(),
    ),
    GetPage(
      name: Routes.more,
      page: () => MoreView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: Routes.writeBlogs,
      page: () => WriteBlogsView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.applyAsTrainer,
      page: () => ApplyAsTrainerView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: Routes.help,
      page: () => const HelpView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: Routes.termsAndConditions,
      page: () => const TermsAndConditionsView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: Routes.aboutFitbeast,
      page: () => const AboutFitBeastView(),
      binding: MoreBinding(),
    ),
  ];

  // static GetPage unknownRoute = GetPage(
  //   name: Routes.notFound,
  //   page: () => const Scaffold(
  //     body: Center(
  //       child: Text('Page not found'),
  //     ),
  //   ),
  // );
}
