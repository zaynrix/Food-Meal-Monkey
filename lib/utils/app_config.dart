import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/data/local/local_data.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';

class AppConfig extends ChangeNotifier {
  void onBordingStatue() {
    Timer(const Duration(seconds: 3), () {
      checkFirstSeen();
    });
  }

  Future<void> checkFirstSeen() async {
    bool seen = await SharedPrefUtil.hasSeenOnboarding();
    bool isAuthenticated = FirebaseAuth.instance.currentUser != null;
    if (seen) {
      if (isAuthenticated) {
        ServiceNavigation.serviceNavi
            .pushNamedAndRemoveUtils(RouteGenerator.mainPage);
      } else {
        ServiceNavigation.serviceNavi
            .pushNamedAndRemoveUtils(RouteGenerator.loginPage);
      }
    } else {
      await SharedPrefUtil.setSeenOnboarding(true);
      ServiceNavigation.serviceNavi
          .pushNamedAndRemoveUtils(RouteGenerator.onBoarding);
    }
  }
}
