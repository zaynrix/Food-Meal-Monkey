import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/core/controllers/cart_controller/cart_controller.dart';
import 'package:food_delivery_app/core/controllers/home_Controllers/home_controller.dart';
import 'package:food_delivery_app/core/controllers/profile_controllers/profile_controller.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/routes.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/singel_chat_controller.dart';
import 'package:food_delivery_app/ui/pages/pages.dart';
import 'package:food_delivery_app/utils/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppConfig(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController(
              firebaseFirestore: firebaseFirestore,
              prefs: prefs,
              googleSignIn: GoogleSignIn(),
              firebaseAuth: FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatController(
              firebaseFirestore: firebaseFirestore,
              firebaseStorage: firebaseStorage,
              prefs: prefs),
        ),
        ChangeNotifierProvider(
          create: (context) => SingleChatController(
              firebaseFirestore: firebaseFirestore,
              firebaseStorage: firebaseStorage,
              prefs: prefs),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Meal Monkey',
          theme: ThemeManager.lightTheme,
          navigatorKey: ServiceNavigation.serviceNavi.navKey,
          onGenerateRoute: RoutsGenerate.generateRoute,
          // initialRoute: RouteGenerator.splashPage,
          scaffoldMessengerKey: ServiceNavigation.scaffoldKey,
          home: const SplashPage(),
        ),
      ),
    );
  }
}
//test1@gmail.com
//test2@gmail.com
// yahya123
//111111
//mmMM112233$
