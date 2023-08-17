import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/data/remote/auth_exception_handler.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/firestore_constants.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_user.dart';
import 'package:food_delivery_app/utils/helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthController extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;
  Status _status = Status.uninitialized;

  Status get status => _status;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  AuthController(
      {required this.googleSignIn,
      required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.prefs});
  void clearControllers() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    addressController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  bool isLoading = false;
  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  String? getFirebaseUserId() {
    return prefs.getString(FirestoreConstants.id);
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
      _status = Status.authenticating;
      notifyListeners();
      _status = Status.authenticating;
      notifyListeners();

      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User? firebaseUser =
            (await firebaseAuth.signInWithCredential(credential)).user;

        if (firebaseUser != null) {
          final QuerySnapshot result = await firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
              .get();
          final List<DocumentSnapshot> document = result.docs;
          if (document.isEmpty) {
            firebaseFirestore
                .collection(FirestoreConstants.pathUserCollection)
                .doc(firebaseUser.uid)
                .set({
              FirestoreConstants.displayName: firebaseUser.displayName,
              FirestoreConstants.photoUrl: firebaseUser.photoURL,
              FirestoreConstants.id: firebaseUser.uid,
              "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
              FirestoreConstants.chattingWith: null
            });

            User? currentUser = firebaseUser;
            await prefs.setString(FirestoreConstants.id, currentUser.uid);
            await prefs.setString(
                FirestoreConstants.displayName, currentUser.displayName ?? "");
            await prefs.setString(
                FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
            await prefs.setString(
                FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
          } else {
            DocumentSnapshot documentSnapshot = document[0];
            ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
            await prefs.setString(FirestoreConstants.id, userChat.id);
            await prefs.setString(
                FirestoreConstants.displayName, userChat.displayName);
            await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
            await prefs.setString(
                FirestoreConstants.phoneNumber, userChat.phoneNumber);
          }
          _status = Status.authenticated;
          ServiceNavigation.serviceNavi
              .pushNamedAndRemoveUtils(RouteGenerator.mainPage);
          notifyListeners();
          // return true;
        } else {
          _status = Status.authenticateError;
          notifyListeners();
          // return false;
        }
      } else {
        _status = Status.authenticateCanceled;
        notifyListeners();
        // return false;
      }
      //
      // startLoading();
      // final GoogleSignInAccount? googleSignInAccount =
      //     await _googleSignIn.signIn();
      // if (googleSignInAccount != null) {
      //   final GoogleSignInAuthentication googleSignInAuth =
      //       await googleSignInAccount.authentication;
      //   final AuthCredential credential = GoogleAuthProvider.credential(
      //     accessToken: googleSignInAuth.accessToken,
      //     idToken: googleSignInAuth.idToken,
      //   );
      //
      //   final UserCredential userCredential =
      //       await auth.signInWithCredential(credential);
      //
      //   if (userCredential.user != null) {
      //     final String userId = userCredential.user!.uid;
      //     final String userEmail = userCredential.user!.email ?? '';
      //     final String userName = userCredential.user!.displayName ?? '';
      //     // const String userMobile =
      //     //     ''; // You can retrieve this from user input or other sources
      //
      //     final userData = {
      //       'email': userEmail,
      //       'name': userName,
      //       // 'mobile': userMobile,
      //     };
      //
      //     await FirebaseFirestore.instance
      //         .collection('users')
      //         .doc(userId)
      //         .set(userData, SetOptions(merge: true));
      //     stopLoading();
      //     ServiceNavigation.serviceNavi
      //         .pushNamedAndRemoveUtils(RouteGenerator.mainPage);
      //   }
      // }
    } catch (e) {
      stopLoading();
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
    try {
      _status = Status.uninitialized;
      ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.loginPage);
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
    await auth.signOut();
  }

  Future resetPassword({required String email}) async {
    try {
      startLoading();
      await auth.sendPasswordResetEmail(email: email);
      stopLoading();
      ServiceNavigation.serviceNavi
          .pushNamedReplacement(RouteGenerator.loginPage);
      Helpers.showSnackBar(
          message: "Password reset link sent: Check your email",
          isSuccess: true);
    } catch (e) {
      stopLoading();
      AuthExceptionHandler.handleException(e);
    }
  }
}
