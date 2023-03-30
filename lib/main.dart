import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/routes.dart';
import 'package:food_delivery_app/ui/pages/entry/menu/desserts_page.dart';
import 'package:food_delivery_app/ui/pages/pages.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        theme: ThemeManager.lightTheme,
        navigatorKey: ServiceNavigation.serviceNavi.navKey,
        onGenerateRoute: RoutsGenerate.generateRoute,
        home: const SplashPage(),
      ),
    );
  }
}


