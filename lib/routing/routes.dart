import 'package:flutter/material.dart';
import 'package:food_delivery_app/routing/router.dart';

import '../ui/pages/pages.dart';


class RoutsGenerate{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
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


        default:
        throw const FormatException("Route not found");
    }
  }
}