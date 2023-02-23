part of pages;

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginHeader(title: "Reset Password", caption: "Please enter your email to receive alink to  create a new password via email"),
                SizedBox(
                  height: 22.h,
                ),
                MainTextField(
                  text: "Email",
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 34.h,
                ),
                ButtonMain(text: "Send", onPress: (){
                  Navigator.pushReplacementNamed(context, '/otd');
                },)
              ]),
        ));
  }
}
