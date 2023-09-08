part of pages;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int currentIndex = -1;
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 500), vsync: this, value: 0.5);
  late final AnimationController _controller2 = AnimationController(
      duration: const Duration(milliseconds: 500), vsync: this, value: 1.0);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _getIconForIndex(MainMenu data, {String? imagePath = ""}) {
    if (data.index == 3) {
      // Placeholder for profile image
      if (imagePath != null && imagePath.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  currentIndex == data.index ? orangeColor : secondaryFontColor,
              width: 2.0,
            ),
          ),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 12, // Adjust as needed
                backgroundImage: CachedNetworkImageProvider(
                  imagePath,
                ),
              ),
              currentIndex != data.index
                  ? CircleAvatar(
                      radius: 12, // Adjus
                      backgroundColor: Colors.grey.withOpacity(0.4),
                      // t as needed
                      // backgroundImage: CachedNetworkImageProvider(imagePath,),
                    )
                  : SizedBox.shrink()
            ],
          ),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  currentIndex == data.index ? orangeColor : secondaryFontColor,
              width: 2.0,
            ),
          ),
          child: CircleAvatar(
            backgroundColor:
                currentIndex == data.index ? Colors.transparent : Colors.grey,
            radius: 12, // Adjust as needed
            backgroundImage: AssetImage(ImageAssets.app_icon),
          ),
        );
      }
    } else {
      return Icon(
        data.icon,
        color: currentIndex == data.index ? orangeColor : unSelectedIconColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ProfileController>(context).auth.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex = -1;
          });
        },
        backgroundColor: currentIndex == -1 ? orangeColor : secondaryFontColor,
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            ...MainMenu.list.map((MainMenu data) {
              return data.isBlank
                  ? SizedBox(
                      width: 0.w,
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller
                              .reverse()
                              .then((value) => _controller.forward());
                          currentIndex = data.index;
                        });
                      },
                      child: ScaleTransition(
                        scale: Tween(begin: 0.3, end: 1.0).animate(
                            CurvedAnimation(
                                parent: currentIndex == data.index
                                    ? _controller
                                    : _controller2,
                                curve: Curves.easeOut)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 27.w, vertical: 15.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _getIconForIndex(data, imagePath: user!.photoURL),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                data.label!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: currentIndex == data.index
                                            ? orangeColor
                                            : secondaryFontColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
            })
          ],
        ),
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    switch (currentIndex) {
      case 0:
        return const MenuPage();
      case 1:
        return const OffersPage();

      case 2:
        return InboxPage();

      case 3:
        return const MorePage();

      default:
        return const HomePage();
    }
  }
}
