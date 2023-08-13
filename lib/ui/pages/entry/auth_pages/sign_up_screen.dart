import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/auth_pages/controllers/auth_controller.dart';
import 'package:food_delivery_app/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void dispose() {
    Provider.of<AuthController>(context).clearControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);

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
                controller: provider.nameController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Email",
                type: TextInputType.emailAddress,
                controller: provider.emailController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Mobile No",
                type: TextInputType.phone,
                controller: provider.mobileController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Address",
                type: TextInputType.streetAddress,
                controller: provider.addressController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Password",
                type: TextInputType.visiblePassword,
                obscure: true,
                controller: provider.passwordController,
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: "Confirm Password",
                type: TextInputType.visiblePassword,
                obscure: true,
                controller: provider.confirmPasswordController,
              ),
              addVerticalSpace(AppSize.s28.h),
              CustomButton(
                text: 'Sign Up',
                onPress: provider.signUp,
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
