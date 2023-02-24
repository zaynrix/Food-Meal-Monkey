part of pages;

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key? key}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 68.h,
                ),
                SizedBox(
                  width: 296.w,
                  height: 55.h,
                  child: Text(
                    'New Password',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryFontColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                SizedBox(
                  width: 302.w,
                  height: 35.h,
                  child: Text(
                    'Please enter your email to receive alink to  create a new password via email',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: secondaryFontColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 55.h,
                ),
                const MainTextField(
                  text: "New Password",
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 28.h,
                ),
                const MainTextField(
                  text: "Confirm Password",
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 36.h,
                ),
                ButtonMain(text: "Next", onPress: (){ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.loginPage);},),
                const SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't Receive?", style: TextStyle(color: secondaryFontColor),),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.resetPasswordPage);
                        });
                      },
                      child: Text(
                        "Click Here",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: orangeColor,
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        ));
  }
}
