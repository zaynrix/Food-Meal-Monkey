part of pages;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProfileController>(
          builder: (context, value, child) {
            String? currentUser =
                value.auth.currentUser?.displayName?.split(' ')[0];
            return Text(
              "Good morning ${currentUser}!",
              style: TextStyle(fontSize: 20.sp),
            );
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),

      body: ListView(
          //scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 13.w, left: 13.w, top: 13.h),
              child: const CurrentLocation(),
            ),
            const CustomSearchBar(),
            SizedBox(
              height: 100.h,
              child: const HomeCategory(),
            ),
            // addVerticalSpace(AppSize.s10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
              child: const HeaderList(
                title: "Popular Restaurents",
              ),
            ),

            const PupularResturent(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
              child: const HeaderList(
                title: "Most Popular",
              ),
            ),
            SizedBox(height: 185.h, child: const MostPopular()),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
              child: const HeaderList(
                title: "Recent Items",
              ),
            ),

            RecentItems(),
          ]),
    );
  }
}
