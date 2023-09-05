import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/order_controller/order_controller.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/core/model/order_model.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/service_locator.dart';
import 'package:food_delivery_app/ui/pages/entry/auth_pages/sign_up_screen.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/det_screen.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/ui/pages/entry/profile_pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../ui/pages/pages.dart';

class RoutsGenerate {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;

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
            builder: (_) => DetailsScreen(
                  product: args as ProductModel,
                ));

      case RouteGenerator.chatPage:
        return MaterialPageRoute(
            builder: (_) => ChatPage(arguments: args as ChatArgument));

      case RouteGenerator.inboxPage:
        return MaterialPageRoute(builder: (_) => InboxPage());
      case RouteGenerator.profilePage:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case RouteGenerator.cartPage:
        return MaterialPageRoute(builder: (_) => CartPage());
      // case RouteGenerator.ordersPage:
      //   return MaterialPageRoute(builder: (_) => OrdersPage());

      case RouteGenerator.addPaymentPage:
        return MaterialPageRoute(builder: (_) => PaymentPage());
      case RouteGenerator.paymentDetailsPage:
        return MaterialPageRoute(builder: (_) => PaymentDetailsPage());

      case RouteGenerator.ordersPage:
        return MaterialPageRoute(builder: (_) => ChangeNotifierProvider.value(value: sl<OrderController>(), child: OrdersPage() ,));
      case RouteGenerator.checkoutPage:
        return MaterialPageRoute(
            builder: (_) =>  CheckoutPage());

      case RouteGenerator.orderDetailsPage:
        return MaterialPageRoute(
            builder: (_) =>  OrderDetailScreen(order: args as OrderModel));

      default:
        throw const FormatException("Route not found");
    }
  }
}
