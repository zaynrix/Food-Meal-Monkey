import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/utils/helper.dart';

class ProfileController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isSaving = false; // Variable to track the saving state

  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, RouteGenerator.loginPage, (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    isSaving = true; // Start saving state
    notifyListeners();
    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(nameController.text);
        await currentUser.updateEmail(emailController.text);
        // Update user information in Firestore
        await _firestore.collection('users').doc(currentUser.uid).update({
          'name': nameController.text,
          'email': emailController.text,
          'mobile': mobileController.text,
          'address': addressController.text,
        });
        Helpers.showSnackBar(
            message: "Profile updated successfully", isSuccess: true);
        // Show a success message or navigate to another screen
        print('Profile updated successfully');
      }
    } catch (e) {
      // Handle error
      Helpers.showSnackBar(
          message: "Error updating profile, try later $e", isSuccess: false);

      print('Error updating profile: $e');
    } finally {
      isSaving = false; // End saving state
      notifyListeners();
    }
  }

  Future<void> fetchUserProfile() async {
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      print("User UID: ${currentUser.uid}");
      print("User Phone Number: ${currentUser.phoneNumber}");

      _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((DocumentSnapshot docSnapshot) {
        if (docSnapshot.exists) {
          Map<String, dynamic> userData =
              docSnapshot.data() as Map<String, dynamic>;
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          mobileController.text = userData['mobile'] ?? '';
          addressController.text = userData['address'] ?? '';
        }
      }).catchError((error) {
        print('Error retrieving user data: $error');
      });
    }
  }
}