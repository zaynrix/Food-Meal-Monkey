part of pages;

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);
    final GlobalKey<FormState> formKye = GlobalKey<FormState>();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p34.w),
            child: Form(
              key: formKye,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AuthHeader(
                        title: "Reset Password",
                        caption:
                            "Please enter your email to receive a link to  create a new password via email"),
                    addVerticalSpace(AppSize.s60.h),
                    MainTextField(
                      controller: emailController,
                      text: "Email",
                      type: TextInputType.emailAddress,
                      validator: (String? value) => value!.validateEmail(),
                    ),
                    addVerticalSpace(AppSize.s35.h),
                    CustomButton(
                      text: "Send",
                      onPress: () {
                        if (formKye.currentState!.validate()) {
                          provider.resetPassword(email: emailController.text);
                        }
                      },
                    )
                  ]),
            ),
          ),
        ));
  }
}
