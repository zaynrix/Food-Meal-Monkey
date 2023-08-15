import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/data/remote/auth_exception_handler.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/utils/helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    addressController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  bool isLoading = false;
  startLoading(){
    isLoading = true;
    notifyListeners();
  }

  stopLoading(){
    isLoading = false;
    notifyListeners();
  }

  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      startLoading();
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      stopLoading();
      ServiceNavigation.serviceNavi
          .pushNamedAndRemoveUtils(RouteGenerator.mainPage);
    } catch (e) {
      stopLoading();
      print('Error: $e');
      AuthExceptionHandler.handleException(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuth =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          final String userId = userCredential.user!.uid;
          final String userEmail = userCredential.user!.email ?? '';
          final String userName = userCredential.user!.displayName ?? '';
          // const String userMobile =
          //     ''; // You can retrieve this from user input or other sources

          final userData = {
            'email': userEmail,
            'name': userName,
            // 'mobile': userMobile,
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .set(userData, SetOptions(merge: true));

          ServiceNavigation.serviceNavi
              .pushNamedAndRemoveUtils(RouteGenerator.mainPage);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> signUp(
      {required String name,
      required String email,
      required String mobile,
      required String address,
      required String password}) async {
    try {
      startLoading();
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Update user profile with name
        await user.updateDisplayName(name);

        // Store additional user information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'mobile': mobile,
          'address': address,
        });
        stopLoading();

        ServiceNavigation.serviceNavi
            .pushNamedReplacement(RouteGenerator.mainPage);
        // Navigate to the next screen or perform other actions
      }
    } catch (e) {
      stopLoading();
      print('Error during sign-up: $e');
      AuthExceptionHandler.handleException(e);
    }
  }

  Future logout() async {
    await auth.signOut();
    ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.loginPage);
  }

  Future resetPassword({required String email}) async {
    try {
      startLoading();
      await auth.sendPasswordResetEmail(email: email);
      stopLoading();
      ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.loginPage);
      Helpers.showSnackBar(
          message: "Password reset link sent: Check your email",
          isSuccess: true);
    } catch (e) {
      stopLoading();
      AuthExceptionHandler.handleException(e);
    }
  }
}
