part of pages;

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key? key}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final GlobalKey<FormState> formKye = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p34.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AuthHeader(
                      title: "New Password",
                      caption:
                          "Please enter your email to receive alink to  create a new password via email"),
                  addVerticalSpace(AppSize.s40.h),
                   MainTextField(
                    text: "New Password",
                    type: TextInputType.emailAddress,
                     validator: (value) => value!.validatePassword(),
                  ),
                  addVerticalSpace(AppSize.s28.h),
                   MainTextField(
                    validator: (value) => value!.validatePassword(),
                    text: "Confirm Password",
                    type: TextInputType.emailAddress,
                  ),
                  addVerticalSpace(AppSize.s28.h),
                  CustomButton(
                    text: "Next",
                    onPress: () {
                      ServiceNavigation.serviceNavi
                          .pushNamedReplacement(RouteGenerator.loginPage);
                    },
                  ),
                ]),
          ),
        ));
  }
}
