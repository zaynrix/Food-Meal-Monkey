import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/profile_controllers/profile_controller.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/ui/widgets/widgets.dart';
import 'package:food_delivery_app/utils/extension/validate_extension.dart';
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
    return Consumer<ProfileController>(
      builder: (context, value, child) {
        User? currentUser = value.auth.currentUser;

        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CustomButton(
              text: 'Save',
              onPress: () => value.updateProfile(context),
            ),
          ),
          appBar: AppBar(
            title: const Text("Profile"),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.shopping_cart))
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 34,
              ),
              child: Column(
                children: [
                  CachedNetworkImage(
                    placeholder: (context, url) => Center(
                        child: Image.asset(
                      ImageAssets.app_icon,
                      width: 45,
                    )),
                    imageUrl: currentUser?.photoURL ?? "",
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(ImageAssets
                          .app_icon), // Replace with your actual asset path
                    ),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      maxRadius: 45,
                      backgroundImage: imageProvider,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Hi there ${currentUser?.displayName ?? 'User'}!',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  MainTextField(
                    text: 'Name',
                    type: TextInputType.text,
                    controller: value.nameController,
                    validator: (String? value) => value!.validateUserName(),
                  ),
                  const SizedBox(height: 12),
                  MainTextField(
                    validator: (value) => value!.validateEmail(),
                    text: 'Email',
                    type: TextInputType.emailAddress,
                    controller: value.emailController,
                  ),
                  const SizedBox(height: 12),
                  MainTextField(
                    validator: (value) => value!.validatePhoneNumber(),
                    text: 'Mobile',
                    type: TextInputType.phone,
                    controller: value.mobileController,
                  ),
                  const SizedBox(height: 12),
                  MainTextField(
                    validator: (value) => value!.validateUserName(),
                    text: 'Address',
                    type: TextInputType.phone,
                    controller: value.addressController,
                  ),
                  const SizedBox(height: 12),
                  MainTextField(
                    validator: (value) => value!.validatePassword(),
                    text: 'Password',
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  MainTextField(
                    validator: (text) {
                      return null;
                    },
                    text: 'Confirm Password',
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 100)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
