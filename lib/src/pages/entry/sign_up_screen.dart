part of pages;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginHeader(title: "Sign Up", caption: "Add your details to sign up",),
              MainTextField(
                text: "Name",
                type: TextInputType.name,
              ),
              SizedBox(
                height: 28.h,
              ),
              MainTextField(
                text: "Email",
                type: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 28.h,
              ),
              MainTextField(
                text: "Mobile No",
                type: TextInputType.phone,
              ),
              SizedBox(
                height: 28.h,
              ),
              MainTextField(
                text: "Address",
                type: TextInputType.streetAddress,
              ),
              SizedBox(
                height: 28.h,
              ),
              MainTextField(
                text: "Password",
                type: TextInputType.visiblePassword,
                obs: true,
              ),
              SizedBox(
                height: 28.h,
              ),
              MainTextField(
                text: "Confirm Password",
                type: TextInputType.visiblePassword,
                obs: true,
              ),
                  SizedBox(
                    height: 28.h,
                  ),
                  ButtonMain(text: 'Sign Up',onPress: (){},),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an Account?", style: TextStyle(color: secondaryFontColor),),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pushReplacementNamed(context, '/login');
                          });
                        },
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ],
                  )
            ])));
  }
}
