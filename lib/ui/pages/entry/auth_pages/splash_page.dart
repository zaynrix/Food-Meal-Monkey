part of pages;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppConfig>(context, listen: false).onBordingStatue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background_splash.png",
            fit: BoxFit.fill,
          ),
          const SplashLogo()
        ],
      ),
    );
  }
}
