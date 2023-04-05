part of pages;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p34.w),
      child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const AuthHeader(
          title: "Sign Up",
          caption: "Add your details to sign up",
        ),
        addVerticalSpace(AppSize.s35.h),
        const MainTextField(
          text: "Name",
          type: TextInputType.name,
        ),
        addVerticalSpace(AppSize.s28.h),
        const MainTextField(
          text: "Email",
          type: TextInputType.emailAddress,
        ),
        addVerticalSpace(AppSize.s28.h),
        const MainTextField(
          text: "Mobile No",
          type: TextInputType.phone,
        ),
        addVerticalSpace(AppSize.s28.h),
        const MainTextField(
          text: "Address",
          type: TextInputType.streetAddress,
        ),
        addVerticalSpace(AppSize.s28.h),
        const MainTextField(
          text: "Password",
          type: TextInputType.visiblePassword,
          obscure: true,
        ),
        addVerticalSpace(AppSize.s28.h),
        const MainTextField(
          text: "Confirm Password",
          type: TextInputType.visiblePassword,
          obscure: true,
        ),
        addVerticalSpace(AppSize.s28.h),
        CustomButton(
          text: 'Sign Up',
          onPress: () {},
        ),
        FooterAuth(
          text: "Already have an Account?",
          textButton: 'Login',
          onPressed: () {
            ServiceNavigation.serviceNavi
                .pushNamedReplacement(RouteGenerator.loginPage);
          },
        ),
      ])),
    ));
  }
}
