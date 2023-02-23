part of pages;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginHeader(title: "Login", caption: "Add your details to login",),
          MainTextField(
            text: "Your Email",
            type: TextInputType.emailAddress,
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
          ButtonMain(
            text: 'Login',
            onPress: () {
              setState(() {
                Navigator.pushReplacementNamed(context, '/mainpage');
              });
            },
          ),
          SizedBox(
            height: 28.h,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/reset');
              });
            },
            child: Text(
              "Forgot your password?",
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold,
                color: secondaryFontColor,
              ),
            ),
          ),
          SizedBox(
            height: 45.h,
          ),
          Text(
            "or Login With",
            style: Theme.of(context).textTheme.caption!.copyWith(
              fontWeight: FontWeight.bold,
              color: secondaryFontColor,
            ),
          ),
          SizedBox(
            height: 28.h,
          ),
          ButtonMain(
            text: 'Login with Facebook',
            onPress: () {},
            ico: Icons.facebook,
            color: Color(0xFF367FC0),
          ),
          SizedBox(
            height: 28.h,
          ),
          ButtonMain(
            text: 'Login with Google',
            onPress: () {},
            ico: Icons.facebook,
            color: Color(0xFFDD4B39),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an Account?", style: TextStyle(color: secondaryFontColor),),
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pushReplacementNamed(context, '/signup');
                  });
                },
                child: Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
