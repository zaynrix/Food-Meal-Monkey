import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/home_Controllers/home_controller.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/auth_pages/sign_up_screen.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/det_screen.dart';

import '../ui/pages/pages.dart';

class RoutsGenerate {
  static Route<dynamic> generateRoute(RouteSettings settings) {


    switch (settings.name) {
      case RouteGenerator.newPasswordPage:
        return MaterialPageRoute(builder: (_) => const NewPasswordPage());
      case RouteGenerator.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingPage());
      case RouteGenerator.splashPage:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case RouteGenerator.loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteGenerator.signUpPage:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case RouteGenerator.mobileOtpPage:
        return MaterialPageRoute(builder: (_) => const MobileOtpPage());
      case RouteGenerator.resetPasswordPage:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());
      case RouteGenerator.starterPage:
        return MaterialPageRoute(builder: (_) => const StarterPage());
      case RouteGenerator.homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RouteGenerator.mainPage:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case RouteGenerator.dessertsPage:
        return MaterialPageRoute(builder: (_) => DessertsPage());
      case RouteGenerator.aboutAsPage:
        return MaterialPageRoute(builder: (_) => const AboutAsPage());
      case RouteGenerator.detailsPage:
        return MaterialPageRoute(
            builder: (_) {
              final args = settings.arguments as DetailsScreenArguments;
              return DetailsScreen(arguments: args);}
    );

      case RouteGenerator.inboxPage:
        return MaterialPageRoute(builder: (_) => InboxPage());
      default:
        throw const FormatException("Route not found");
    }
  }
}
