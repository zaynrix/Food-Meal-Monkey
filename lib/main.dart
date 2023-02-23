import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:food_delivery_app/styles/styles.dart';

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
        routes: {
          "/" : (context) => const SplashScreen(),
          "/intro" : (context) => const IntroPage(),
          "/starter" : (context) => const StarterPage(),
          "/login" : (context) => const LoginScreen(),
          "/signup" : (context) => const SignUp(),
          "/reset" : (context) => const ResetPassword(),
          "/otd" : (context) => const OtdScreen(),
          "/newpassword" : (context) => const NewPassword(),
          "/mainpage" : (context) => const MainPage(),
        },
      ),
    );
  }
}


