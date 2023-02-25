part of pages;

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p34.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AuthHeader(title: "Reset Password", caption: "Please enter your email to receive alink to  create a new password via email"),
                  addVerticalSpace(AppSize.s60.h),
                  const MainTextField(
                    text: "Email",
                    type: TextInputType.emailAddress,
                  ),
                  addVerticalSpace(AppSize.s35.h),
                  CustomButton(text: "Send", onPress: (){
                    ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.mobileOtpPage);
                  },)
                ]),
          ),
        ));
  }
}
