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
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoginHeader(title: "We have sent an OTP toyour Mobile", caption: "Please check your mobile number 071*****12 continue to reset your password"),
                buildPinPut(),
                // MainTextField(
                //   text: "Your Email",
                //   type: TextInputType.emailAddress,
                // ),
                SizedBox(
                  height: 36.h,
                ),
                ButtonMain(text: "Next", onPress: (){
                  setState(() {
                    Navigator.pushReplacementNamed(context, '/newpassword');
                  });
                },),
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
                          Navigator.pushReplacementNamed(context, '/reset');
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





Widget buildPinPut() {
  return Pinput(
      obscureText: true,
    obscuringCharacter: '*',
    onCompleted: (pin) => print(pin),
  );
}


