import 'package:flutter/material.dart';

class ServiceNavigation {
  ServiceNavigation._();
  static ServiceNavigation serviceNavi = ServiceNavigation._();
  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  pushNamedWidget(String name, {args}) {
    navKey.currentState?.pushNamed(name, arguments: args);
  }

  pushNamedReplacement(String name) {
    navKey.currentState?.pushReplacementNamed(name);
  }

  back() {
    navKey.currentState?.pop();
  }

  pushNamedAndRemoveUtils(String name) {
    navKey.currentState?.pushNamedAndRemoveUntil(name, (route) => false);
  }
}
