import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/pages/entry/profile_pages/profile_controllers/profile_controller.dart';
import 'package:food_delivery_app/ui/widgets/widgets.dart';
import 'package:food_delivery_app/utils/constant.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileController>(context, listen: false).fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: Consumer<ProfileController>(builder: (context, value, child) {
        User? currentUser = value.auth.currentUser;

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
                const SizedBox(height: 22),
                Text(
                  'Hi there ${currentUser?.displayName ?? 'User'}!',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    value.signOut(context);
                  },
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Color(secondaryTextColor)),
                  ),
                ),
                const SizedBox(height: 20),
                MainTextField(
                  text: 'Name',
                  type: TextInputType.text,
                  controller: value.nameController,
                ),
                const SizedBox(height: 12),
                MainTextField(
                  text: 'Email',
                  type: TextInputType.emailAddress,
                  controller: value.emailController,
                ),
                const SizedBox(height: 12),
                MainTextField(
                  text: 'Mobile',
                  type: TextInputType.phone,
                  controller: value.mobileController,
                ),
                const SizedBox(height: 12),
                MainTextField(
                  text: 'Address',
                  type: TextInputType.phone,
                  controller: value.addressController,
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
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Save',
                  onPress: () => value.updateProfile(context),
                ),
                const SizedBox(height: 100)
              ],
            ),
          ),
        );
      }),
    );
  }
}
