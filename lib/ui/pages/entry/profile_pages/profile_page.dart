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
      nameController.text = currentUser.displayName ?? '';
      emailController.text = currentUser.email ?? '';
      mobileController.text = currentUser.phoneNumber ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 34,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  maxRadius: 45,
                  backgroundImage: AssetImage(
                    'assets/images/user.png',
                  ),
                ),
                const SizedBox(height: 8),
                // const ColTxt(),
                const SizedBox(height: 8),
                Text(
                  'Hi there ${currentUser?.displayName ?? 'User'}!',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
                  text: 'Save',
                  onPress: () {},
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
