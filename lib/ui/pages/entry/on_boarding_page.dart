part of pages;

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final List<IntroModle> data = IntroModle.data;
  late PageController _controller;
  int _activeIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController();
    _controller.addListener(() {
      setState(() {
        _activeIndex = _controller.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                itemCount: data.length,
                controller: _controller,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 112.h,
                      ),
                      Image.asset(
                        data[index].imagePath,
                        width: 210.61.w,
                        height: 294.81.h,
                      ),
                    ],
                  );
                }),
          ),
          SliderIndicator(
            length: data.length,
            activeIndex: _activeIndex,
            indicator: Icon(
              Icons.fiber_manual_record,
              color: unSelectedIconColor,
              size: 8.w,
            ),
            activeIndicator: Icon(
              Icons.fiber_manual_record,
              color: orangeColor,
              size: 8.w,
            ),
          ),
          SizedBox(
            height: 30.2.h,
          ),
          SizedBox(
            height: 40.h,
            child: Text(
              data[_activeIndex].title,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: primaryFontColor,
                    fontWeight: FontWeight.bold,
                    //height: 19.h
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 34.h,
          ),
          SizedBox(
              height: 58.h,
              width: 271.w,
              child: Text(
                data[_activeIndex].desc,
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: secondaryFontColor,
                      fontWeight: FontWeight.bold,
                      //height: 19.h
                    ),
                textAlign: TextAlign.center,
              )),
          Padding(
            padding: EdgeInsets.only(
                right: 34.w, left: 34.w, top: 36.h, bottom: 111.h),
            child: CustomButton(
              text: "Next",
              onPress: () {
                if (_activeIndex + 1 >= data.length) {
                  ServiceNavigation.serviceNavi.pushNamedReplacement(RouteGenerator.starterPage);
                }
                _controller.nextPage(
                    duration: const Duration(milliseconds: 250), curve: Curves.ease);
              },
            ),
          )
        ],
      ),
    );
  }
}
