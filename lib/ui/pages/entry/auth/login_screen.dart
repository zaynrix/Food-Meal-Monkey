part of pages;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          const LoginHeader(title: "Login", caption: "Add your details to login",),
          const MainTextField(
            text: "Your Email",
            type: TextInputType.emailAddress,
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
          ButtonMain(
            text: 'Login',
            onPress: () {
              setState(() {
                ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.mainPage);
              });
            },
          ),
          SizedBox(
            height: 28.h,
          ),
          TextButton(
            onPressed: () {
              ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.resetPasswordPage);
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
            color: const Color(0xFF367FC0),
          ),
          SizedBox(
            height: 28.h,
          ),
          ButtonMain(
            text: 'Login with Google',
            onPress: () {},
            ico: Icons.facebook,
            color: const Color(0xFFDD4B39),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an Account?", style: TextStyle(color: secondaryFontColor),),
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
                    color: orangeColor,
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
