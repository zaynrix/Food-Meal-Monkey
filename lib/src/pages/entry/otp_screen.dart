part of pages;

class OtdScreen extends StatefulWidget {
  const OtdScreen({Key? key}) : super(key: key);

  @override
  State<OtdScreen> createState() => _OtdScreenState();
}

class _OtdScreenState extends State<OtdScreen> {
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





Widget buildPinPut() {
  return Pinput(

      obscureText: true,
    obscuringCharacter: '*',
    onCompleted: (pin) => print(pin),
  );
}

// Widget _textFieldOTP({bool first, last}) {
//   return Container(
//     height: 85,
//     child: AspectRatio(
//       aspectRatio: 1.0,
//       child: TextField(
//         autofocus: true,
//         onChanged: (value) {
//           if (value.length == 1 && last == false) {
//             FocusScope.of(context).nextFocus();
//           }
//           if (value.length == 0 && first == false) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//         showCursor: false,
//         readOnly: false,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         decoration: InputDecoration(
//           counter: Offstage(),
//           enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(width: 2, color: Colors.black12),
//               borderRadius: BorderRadius.circular(12)),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(width: 2, color: Colors.purple),
//               borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     ),
//   );
// }
