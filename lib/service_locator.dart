import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/core/controllers/home_Controllers/home_controller.dart';
import 'package:food_delivery_app/core/controllers/order_controller/order_controller.dart';
import 'package:food_delivery_app/core/controllers/payment_controller/payment_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

void init() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<HomeController>(() => HomeController());
  // Register AuthController
  sl.registerLazySingleton(() => AuthController(
        firebaseFirestore: FirebaseFirestore.instance,
        prefs: prefs,
        googleSignIn: GoogleSignIn(),
        firebaseAuth: FirebaseAuth.instance,
      ));

  sl.registerLazySingleton<OrderController>(() => OrderController());
  sl.registerLazySingleton<PaymentController>(() => PaymentController(sharedPreferences: prefs));
}
