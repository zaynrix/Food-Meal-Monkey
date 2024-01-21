part of pages;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKye = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? mediumStyle = Theme.of(context).textTheme.labelMedium;
    final provider = Provider.of<AuthController>(context);
    final authProvider = Provider.of<AuthController>(context);

    switch (authProvider.status) {
      case AuthStatus.authenticateError:
        Fluttertoast.showToast(msg: 'Sign in failed');
        break;
      case AuthStatus.authenticateCanceled:
        Fluttertoast.showToast(msg: 'Sign in cancelled');
        break;
      case AuthStatus.authenticated:
        Fluttertoast.showToast(msg: 'Sign in successful');
        break;
      default:
        break;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p34),
        child: Form(
          key: formKye,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AuthHeader(
                title: "Login",
                caption: "Add your details to login",
              ),
              addVerticalSpace(AppSize.s35.h),
              MainTextField(
                text: 'Your Email',
                type: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) => value!.validateEmail(),
              ),
              addVerticalSpace(AppSize.s28.h),
              MainTextField(
                text: 'Password',
                type: TextInputType.visiblePassword,
                obscure: true,
                controller: passwordController,
                validator: (value) => value!.validatePassword(),
              ),
              addVerticalSpace(AppSize.s28.h),
              CustomButton(
                isLoading: provider.isLoading,
                text: 'Login',
                onPress: () {
                  if (formKye.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());

                    provider.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);
                  }
                },
              ),
              20.addVerticalSpace,
              TextButton(
                onPressed: () {
                  ServiceNavigation.serviceNavi
                      .pushNamedWidget(RouteGenerator.resetPasswordPage);
                },
                child: Text(
                  "Forgot your password?",
                  style: mediumStyle,
                ),
              ),
              30.addVerticalSpace,
              Text(
                "or Login With",
                style: mediumStyle,
              ),
              20.addVerticalSpace,
              CustomButton(
                text: 'Login with Facebook',
                onPress: () {},
                icon: Icons.facebook,
                color: const Color(0xFF367FC0),
              ),
              20.addVerticalSpace,
              CustomButton(
                text: 'Login with Google',
                onPress: provider.signInWithGoogle,
                icon: Icons.facebook,
                isLoading: provider.googleLoading,
                color: const Color(0xFFDD4B39),
              ),
              const Spacer(),
              FooterAuth(
                text: "Don't have an Account?",
                textButton: 'Sign Up',
                onPressed: () {
                  ServiceNavigation.serviceNavi
                      .pushNamedWidget(RouteGenerator.signUpPage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
