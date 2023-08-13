part of pages;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = -1;

  @override
  Widget build(BuildContext context) {
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
                  : InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = data.index;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 27.w, vertical: 15.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              data.icon,
                              color: currentIndex == data.index
                                  ? orangeColor
                                  : unSelectedIconColor,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              data.label!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      color: currentIndex == data.index
                                          ? orangeColor
                                          : secondaryFontColor),
                            )
                          ],
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
        return const ProfilePage();

      case 3:
        return const MorePage();

      default:
        return const HomePage();
    }
  }
}
