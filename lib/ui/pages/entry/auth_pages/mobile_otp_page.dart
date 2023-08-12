part of pages;

class MobileOtpPage extends StatefulWidget {
  const MobileOtpPage({Key? key}) : super(key: key);

  @override
  State<MobileOtpPage> createState() => _MobileOtpPageState();
}

class _MobileOtpPageState extends State<MobileOtpPage> {
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
                      title: "We have sent an OTP toyour Mobile",
                      caption:
                          "Please check your mobile number 071*****12 continue to reset your password"),
                  addVerticalSpace(AppSize.s40.h),
                  // buildPinPut(),
                  SizedBox(
                    height: 36.h,
                  ),
                  CustomButton(
                    text: "Next",
                    onPress: () {
                      ServiceNavigation.serviceNavi
                          .pushNamedReplacement(RouteGenerator.newPasswordPage);
                    },
                  ),
                  addVerticalSpace(AppSize.s35.h),
                  FooterAuth(
                      text: "Didn't Receive?",
                      textButton: "Click Here",
                      onPressed: () {
                        ServiceNavigation.serviceNavi.pushNamedReplacement(
                            RouteGenerator.resetPasswordPage);
                      })
                ]),
          ),
        ));
  }
}

// Widget buildPinPut() {
//   return Pinput(
//       obscureText: true,
//     obscuringCharacter: '*',
//     onCompleted: (pin) => debugPrint(pin),
//   );
// }
