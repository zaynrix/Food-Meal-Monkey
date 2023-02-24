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
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoginHeader(title: "Reset Password", caption: "Please enter your email to receive alink to  create a new password via email"),
                SizedBox(
                  height: 22.h,
                ),
                const MainTextField(
                  text: "Email",
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 34.h,
                ),
                ButtonMain(text: "Send", onPress: (){
                  ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.newPasswordPage);
                },)
              ]),
        ));
  }
}
