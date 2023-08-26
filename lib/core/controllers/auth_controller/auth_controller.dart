import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/cart_controller/cart_controller.dart';
import 'package:food_delivery_app/core/data/local/local_data.dart';
import 'package:food_delivery_app/core/data/remote/auth_exception_handler.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_user.dart';
import 'package:food_delivery_app/utils/helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../ui/pages/entry/more_pages/chat/firestore_constants.dart';

enum AuthStatus {
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
  AuthStatus _status = AuthStatus.uninitialized;

  AuthStatus get status => _status;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  AuthController({
    required this.googleSignIn,
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.prefs,
  });

  bool isLoading = false;
  bool googleLoading = false;

  String? getFirebaseUserId() => prefs.getString(FirestoreConstants.id);

  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      startLoading();
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setEmailUser(auth.currentUser?.uid ?? "null id");
      _navigateToMainPage();
    } catch (e) {
      stopLoading();
      AuthExceptionHandler.handleException(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      startGoogleLoading();
      _status = AuthStatus.authenticating;
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
            final String randomId = Uuid().v4();
            await firebaseFirestore
                .collection(FirestoreConstants.pathUserCollection)
                .doc(firebaseUser.uid)
                .set({
              FirestoreConstants.displayName: firebaseUser.displayName,
              FirestoreConstants.photoUrl: firebaseUser.photoURL,
              FirestoreConstants.id: randomId,
              FirestoreConstants.email: firebaseUser.email,
              FirestoreConstants.createdAt:
                  DateTime.now().millisecondsSinceEpoch.toString(),
              FirestoreConstants.chattingWith: null,
            });

            User? currentUser = firebaseUser;
            await prefs.setString(FirestoreConstants.id, currentUser.uid);
            await prefs.setString(
                FirestoreConstants.displayName, currentUser.displayName ?? "");
            await prefs.setString(
                FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
            await prefs.setString(
                FirestoreConstants.email, currentUser.email ?? "");
            await prefs.setString(
                FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
          } else {
            DocumentSnapshot documentSnapshot = document[0];
            ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
            await prefs.setString(FirestoreConstants.id, userChat.id);
            await prefs.setString(
                FirestoreConstants.displayName, userChat.displayName);
            await prefs.setString(FirestoreConstants.email, userChat.email);
            await prefs.setString(
                FirestoreConstants.phoneNumber, userChat.phoneNumber);
          }
          final userRef = FirebaseFirestore.instance
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseUser.uid);
          userRef.update({
            FirestoreConstants.online: true,
          });
          _status = AuthStatus.authenticated;

          stopGoogleLoading();
          notifyListeners();
          _navigateToMainPage();
        } else {
          _status = AuthStatus.authenticateError;
          notifyListeners();
          stopLoading();
        }
      } else {
        _status = AuthStatus.authenticateCanceled;
        notifyListeners();
        stopLoading();
      }
    } catch (e) {
      stopGoogleLoading();
      print('Error: $e');
    } finally {
      stopLoading();
    }
  }

  Future<void> signUp({ChatUser? userData, required String password}) async {
    try {
      startLoading();
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userData!.email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _updateUserProfile(user, userData);
        final String randomId = Uuid().v4();
        await _createUserInFirestore(user, userData, randomId);
        stopLoading();
        _navigateToLoginPage();
      }
    } catch (e) {
      stopLoading();
      AuthExceptionHandler.handleException(e);
    }
  }

  Future<void> updateUserOnlineStatus(bool isOnline) async {
    final user = auth.currentUser;
    if (user != null) {
      final userRef = _getUserFirestoreReference(user.uid);
      userRef.update({
        FirestoreConstants.online: isOnline,
        FirestoreConstants.lastSeen:
            DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
  }

  Future logout() async {
    final userRef = _getUserFirestoreReference(auth.currentUser!.uid);

    try {
      prefs.clear();
      CartController(sharedPreferences: prefs).disposeCartController();

      _updateStatus(AuthStatus.uninitialized);
      _navigateToLoginPage();

      userRef.update({
        FirestoreConstants.online: false,
        FirestoreConstants.lastSeen:
            DateTime.now().millisecondsSinceEpoch.toString(),
      });

      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future resetPassword({required String email}) async {
    try {
      startLoading();
      await auth.sendPasswordResetEmail(email: email);
      stopLoading();
      _navigateToLoginPage();
      Helpers.showSnackBar(
        message: "Password reset link sent: Check your email",
        isSuccess: true,
      );
    } catch (e) {
      stopLoading();
      AuthExceptionHandler.handleException(e);
    }
  }

  // Utility methods...

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void startGoogleLoading() {
    googleLoading = true;
    notifyListeners();
  }

  void stopGoogleLoading() {
    googleLoading = false;
    notifyListeners();
  }

  void _updateStatus(AuthStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void _setEmailUser(String id) {
    SharedPrefUtil.setIdUser(id);
  }

  void _navigateToMainPage() {
    ServiceNavigation.serviceNavi
        .pushNamedAndRemoveUtils(RouteGenerator.mainPage);
  }

  _updateUserProfile(User user, ChatUser userData) async {
    await user.updateDisplayName(userData.displayName);
  }

  Future<void> _createUserInFirestore(
    User user,
    ChatUser userData,
    String randomId,
  ) async {
    await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(user.uid)
        .set({
      FirestoreConstants.displayName: userData.displayName,
      FirestoreConstants.photoUrl: userData.photoUrl,
      FirestoreConstants.id: randomId,
      FirestoreConstants.address: userData.address,
      FirestoreConstants.email: userData.email,
      FirestoreConstants.createdAt:
          DateTime.now().millisecondsSinceEpoch.toString(),
      FirestoreConstants.chattingWith: null,
    });
  }

  DocumentReference _getUserFirestoreReference(String uid) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(uid);
  }

  void _navigateToLoginPage() {
    ServiceNavigation.serviceNavi
        .pushNamedReplacement(RouteGenerator.loginPage);
  }
}
