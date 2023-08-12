import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/widgets/widgets.dart';
import 'package:food_delivery_app/utils/constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      ServiceNavigation.serviceNavi
          .pushNamedAndRemoveUtils(RouteGenerator.loginPage);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    User? currentUser = _auth.currentUser;

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
        }
      }).catchError((error) {
        print('Error retrieving user data: $error');
      });
    }
  }

  bool _isSaving = false; // Variable to track the saving state

  Future<void> _updateProfile() async {
    setState(() {
      _isSaving = true; // Start saving state
    });
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(nameController.text);
        await currentUser.updateEmail(emailController.text);
        // Update user information in Firestore
        await _firestore.collection('users').doc(currentUser.uid).update({
          'name': nameController.text,
          'email': emailController.text,
          'mobile': mobileController.text,
        });

        // Show a success message or navigate to another screen
        print('Profile updated successfully');
      }
    } catch (e) {
      // Handle error
      print('Error updating profile: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'An error occurred while updating your profile. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isSaving = false; // End saving state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 34,
        ),
        child: Column(
          children: [
            CircleAvatar(
              maxRadius: 45,
              backgroundImage: NetworkImage(
                "${currentUser?.photoURL}",
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Hi there ${currentUser?.displayName ?? 'User'}!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            GestureDetector(
              onTap: _signOut,
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Color(secondaryTextColor)),
              ),
            ),
            const SizedBox(height: 20),
            MainTextField(
              text: 'Name',
              type: TextInputType.text,
              controller: nameController,
            ),
            const SizedBox(height: 12),
            MainTextField(
              text: 'Email',
              type: TextInputType.emailAddress,
              controller: emailController,
            ),
            const SizedBox(height: 12),
            MainTextField(
              text: 'Mobile',
              type: TextInputType.phone,
              controller: mobileController,
            ),
            const SizedBox(height: 12),
            const MainTextField(
              text: 'Password',
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            const MainTextField(
              text: 'Confirm Password',
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: _isSaving
                  ? ''
                  : 'Save', // Show text or empty string based on saving state
              onPress: _updateProfile, // Disable button during saving
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
