import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/core/controllers/auth_controller.dart';
import 'package:food_delivery_app/ui/widgets/widgets.dart';
import 'package:food_delivery_app/utils/extension/validate_extension.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p34.w),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                  validator: (String? value) => value!.validateUserName(),
                ),
                addVerticalSpace(AppSize.s28.h),
                MainTextField(
                  validator: (value) => value!.validateEmail(),
                  text: "Email",
                  type: TextInputType.emailAddress,
                  controller: emailController,
                ),
                addVerticalSpace(AppSize.s28.h),
                MainTextField(
                  validator: (value) => value!.validatePhoneNumber(),
                  text: "Mobile No",
                  type: TextInputType.phone,
                  controller: mobileController,
                ),
                addVerticalSpace(AppSize.s28.h),
                MainTextField(
                  validator: (value) => value!.validateUserName(),
                  text: "Address",
                  type: TextInputType.streetAddress,
                  controller: addressController,
                ),
                addVerticalSpace(AppSize.s28.h),
                MainTextField(
                  validator: (value) => value!.validatePassword(),
                  text: "Password",
                  type: TextInputType.visiblePassword,
                  obscure: true,
                  controller: passwordController,
                ),
                addVerticalSpace(AppSize.s28.h),
                MainTextField(
                  validator: (value) =>
                      value!.validateRePassword(passwordController.text),
                  text: "Confirm Password",
                  type: TextInputType.visiblePassword,
                  obscure: true,
                  controller: confirmPasswordController,
                ),
                addVerticalSpace(AppSize.s28.h),
                CustomButton(
                  text: 'Sign Up',
                  onPress: () {
                    if (formKey.currentState!.validate()) {
                      provider.signUp(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          mobile: mobileController.text,
                          address: addressController.text);
                    }
                  },
                  isLoading: provider.isLoading,
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
      ),
    );
  }
}
