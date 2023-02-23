part of widgets;

class SplashLogo extends StatefulWidget {
  const SplashLogo({Key? key}) : super(key: key);

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/imags/Monkey face.png",
          fit: BoxFit.fill,
          width: 103.11.w,
        ),
        SizedBox(
          height: 13.9.h,
        ),
        Text.rich(TextSpan(
            text: 'Meal',
            style: Theme.of(context).textTheme.headline4!.copyWith(
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
            children: const [
              TextSpan(
                  text: ' Monkey',
                  style: TextStyle(color: primaryFontColor))
            ]
        )
        ),
        SizedBox(
          height: 9.h,
        ),
        Text("FOOD DELIVERY",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: secondaryFontColor,
                letterSpacing: 8.w))
      ],
    );
  }
}
