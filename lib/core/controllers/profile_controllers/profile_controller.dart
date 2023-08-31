import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/model/resturant_model.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/firestore_constants.dart';
import 'package:food_delivery_app/utils/helper.dart';

class ProfileController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isSaving = false; // Variable to track the saving state

  List? foodList;
  String searchWord = "";

  void search(String value) {
    searchWord = value;
    notifyListeners();
  }

  Future<List<FoodItem>> fetchFoodItemsFromFirestore() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirestoreConstants.latest_offers)
          .get();

      final restaurants = querySnapshot.docs
          .map(
            (doc) => FoodItem.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .toList();

      foodList = restaurants;
      notifyListeners();
      return restaurants;
    } catch (error) {
      print("Error getting restaurants: $error");
      rethrow; // Rethrow the error for better error handling
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
        await _fireStore.collection('users').doc(currentUser.uid).update({
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

      _fireStore
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
