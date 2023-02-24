part of pages;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const LoginHeader(title: "Sign Up", caption: "Add your details to sign up",),
              const MainTextField(
                text: "Name",
                type: TextInputType.name,
              ),
              SizedBox(
                height: 28.h,
              ),
              const MainTextField(
                text: "Email",
                type: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 28.h,
              ),
              const MainTextField(
                text: "Mobile No",
                type: TextInputType.phone,
              ),
              SizedBox(
                height: 28.h,
              ),
              const MainTextField(
                text: "Address",
                type: TextInputType.streetAddress,
              ),
              SizedBox(
                height: 28.h,
              ),
              const MainTextField(
                text: "Password",
                type: TextInputType.visiblePassword,
                obs: true,
              ),
              SizedBox(
                height: 28.h,
              ),
              const MainTextField(
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
                      const Text("Already have an Account?", style: TextStyle(color: secondaryFontColor),),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.loginPage);
                          });
                        },
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: orangeColor,
                          ),
                        ),
                      ),
                    ],
                  )
            ])));
  }
}
