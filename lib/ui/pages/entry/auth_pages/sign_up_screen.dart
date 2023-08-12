// part of pages;
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     mobileController.dispose();
//     addressController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppPadding.p34.w),
//       child: SingleChildScrollView(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//         const AuthHeader(
//           title: "Sign Up",
//           caption: "Add your details to sign up",
//         ),
//         addVerticalSpace(AppSize.s35.h),
//         const MainTextField(
//           text: "Name",
//           type: TextInputType.name,
//         ),
//         addVerticalSpace(AppSize.s28.h),
//         const MainTextField(
//           text: "Email",
//           type: TextInputType.emailAddress,
//         ),
//         addVerticalSpace(AppSize.s28.h),
//         const MainTextField(
//           text: "Mobile No",
//           type: TextInputType.phone,
//         ),
//         addVerticalSpace(AppSize.s28.h),
//         const MainTextField(
//           text: "Address",
//           type: TextInputType.streetAddress,
//         ),
//         addVerticalSpace(AppSize.s28.h),
//         const MainTextField(
//           text: "Password",
//           type: TextInputType.visiblePassword,
//           obscure: true,
//         ),
//         addVerticalSpace(AppSize.s28.h),
//         const MainTextField(
//           text: "Confirm Password",
//           type: TextInputType.visiblePassword,
//           obscure: true,
//         ),
//         addVerticalSpace(AppSize.s28.h),
//         CustomButton(
//           text: 'Sign Up',
//           onPress: () async {
//             try {
//               final String name = nameController.text;
//               final String email = emailController.text;
//               final String mobile = mobileController.text;
//               final String address = addressController.text;
//               final String password = passwordController.text;
//
//               if (password != confirmPasswordController.text) {
//                 // Handle password mismatch
//                 return;
//               }
//
//               UserCredential userCredential =
//                   await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                 email: email,
//                 password: password,
//               );
//
//               User? user = userCredential.user;
//               if (user != null) {
//                 // Update user profile with name
//                 await user.updateProfile(displayName: name);
//
//                 // Store additional user information in Firestore
//                 await FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(user.uid)
//                     .set({
//                   'name': name,
//                   'email': email,
//                   'mobile': mobile,
//                   'address': address,
//                 });
//
//                 // Navigate to the next screen or perform other actions
//               }
//             } catch (e) {
//               // Handle sign-up error
//               print('Error during sign-up: $e');
//             }
//           },
//         ),
//         FooterAuth(
//           text: "Already have an Account?",
//           textButton: 'Login',
//           onPressed: () {
//             ServiceNavigation.serviceNavi
//                 .pushNamedReplacement(RouteGenerator.loginPage);
//           },
//         ),
//       ])),
//     ));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/widgets/widgets.dart';
import 'package:food_delivery_app/utils/helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p34.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AuthHeader(
                title: "Sign Up",
                caption: "Add your details to sign up",
              ),
              addVerticalSpace(AppSize.s35.h),
              MainTextField(
                text: "Name",
                type: TextInputType.name,
                controller: nameController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Email",
                type: TextInputType.emailAddress,
                controller: emailController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Mobile No",
                type: TextInputType.phone,
                controller: mobileController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Address",
                type: TextInputType.streetAddress,
                controller: addressController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Password",
                type: TextInputType.visiblePassword,
                obscure: true,
                controller: passwordController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Confirm Password",
                type: TextInputType.visiblePassword,
                obscure: true,
                controller: confirmPasswordController,
              ),
              addVerticalSpace(AppSize.s28.h),
              CustomButton(
                text: 'Sign Up',
                onPress: () async {
                  try {
                    final String name = nameController.text;
                    final String email = emailController.text;
                    final String mobile = mobileController.text;
                    final String address = addressController.text;
                    final String password = passwordController.text;

                    if (password != confirmPasswordController.text) {
                      // Handle password mismatch
                      return;
                    }

                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    User? user = userCredential.user;
                    if (user != null) {
                      // Update user profile with name
                      await user.updateProfile(displayName: name);

                      // Store additional user information in Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .set({
                        'name': name,
                        'email': email,
                        'mobile': mobile,
                        'address': address,
                      });
                      ServiceNavigation.serviceNavi
                          .pushNamedReplacement(RouteGenerator.mainPage);
                      // Navigate to the next screen or perform other actions
                    }
                  } catch (e) {
                    Helpers.showSnackBar(message: "$e", isSuccess: false);
                    // Handle sign-up error
                    print('Error during sign-up: $e');
                  }
                },
              ),
              FooterAuth(
                text: "Already have an Account?",
                textButton: 'Login',
                onPressed: () {
                  ServiceNavigation.serviceNavi
                      .pushNamedReplacement(RouteGenerator.loginPage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
