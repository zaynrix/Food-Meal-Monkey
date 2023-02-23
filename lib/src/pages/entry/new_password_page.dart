part of pages;

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
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
                MainTextField(
                  text: "New Password",
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 28.h,
                ),
                MainTextField(
                  text: "Confirm Password",
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 36.h,
                ),
                ButtonMain(text: "Next", onPress: (){},),
                SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't Receive?", style: TextStyle(color: secondaryFontColor),),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pushReplacementNamed(context, '/reset');
                        });
                      },
                      child: Text(
                        "Click Here",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        ));
  }
}
