import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/routing/routes.dart';
import 'package:food_delivery_app/ui/pages/pages.dart';
import 'package:food_delivery_app/resources/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context ,child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meal Monkey Demo',
        theme: ThemeData(

          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: primaryFontColor,
              fontSize: 20
            ),
            actionsIconTheme: const IconThemeData(color: primaryFontColor),
          ),
          primarySwatch: Colors.deepOrange,
        ),
        navigatorKey: ServiceNavigation.serviceNavi.navKey,
        onGenerateRoute: RoutsGenerate.generateRoute,
        home: const SplashPage(),
      ),
    );
  }
}


