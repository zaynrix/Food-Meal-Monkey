part of pages;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildHomePageBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Consumer<ProfileController>(
        builder: (context, value, child) {
          String? currentUser =
              value.auth.currentUser?.displayName?.split(' ')[0];
          return Text(
            "Good morning ${currentUser}!",
            style: TextStyle(fontSize: 20),
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            ServiceNavigation.serviceNavi
                .pushNamedWidget(RouteGenerator.cartPage);
          },
          icon: const Icon(Icons.shopping_cart),
        ),
      ],
    );
  }

  Widget buildHomePageBody() {
    return Consumer<ProfileController>(
      builder: (context, value, child) => ListView(
        padding: EdgeInsets.zero,
        children: [
          const CustomSearchBar(),
          value.searchWord.isEmpty
              ? SizedBox.shrink()
              : buildSearchResults(value),
          value.searchWord.isNotEmpty
              ? SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.addVerticalSpace,
                    SizedBox(height: 100, child: const HomeCategory()),
                    HeaderList(
                      title: AppStrings.popularRestaurant,
                      onPressed: () {
                        ServiceNavigation.serviceNavi.pushNamedWidget(
                            RouteGenerator.popularRestaurantScreen);
                      },
                    ),
                    const PupularResturent(),
                    10.addVerticalSpace,
                    HeaderList(
                      title: AppStrings.mostPopular,
                      onPressed: () {
                        ServiceNavigation.serviceNavi
                            .pushNamedWidget(RouteGenerator.mostPopularPage);
                      },
                    ),
                    SizedBox(
                      height: 185.h,
                      child: Consumer<HomeController>(
                        builder: (context, controller, child) => MostPopular(
                          homeController: controller,
                        ),
                      ),
                    ),
                    10.addVerticalSpace,
                    HeaderList(
                      title: AppStrings.recentItems,
                      onPressed: () {
                        ServiceNavigation.serviceNavi
                            .pushNamedWidget(RouteGenerator.allRecentItemPage);
                      },
                    ),
                    RecentItems(),
                  ],
                ),
        ],
      ),
    );
  }

  Widget buildCurrentLocation() {
    return Padding(
      padding: EdgeInsets.only(right: 13.w, left: 13.w, top: 13.h),
      child: const CurrentLocation(),
    );
  }

  Widget buildSearchResults(ProfileController value) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreConstants.recent_items)
          .where(
            FirestoreConstants.displayName,
            isGreaterThanOrEqualTo: value.searchWord,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  const CircularProgressIndicator()); // Loading indicator while data is fetched
        }
        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          return Center(
            child: Text('${AppStrings.noItems}( ${value.searchWord} )'),
          ); // Display a message if no data is available
        }

        final docs = snapshot.data!.docs;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.transparent,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final product = ProductModel.fromDocument(doc);

              return GestureDetector(
                onTap: () {
                  ServiceNavigation.serviceNavi.pushNamedWidget(
                      RouteGenerator.detailsPage,
                      args: product);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 80.w,
                        height: 80.h,
                        child: Hero(
                          tag: product.imagePath,
                          child: CachedNetworkImage(
                            imageUrl: product.imagePath,
                            height: 80.h,
                            width: 80.w,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                                child: Image.asset(ImageAssets.app_icon)),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ), // Load image from network
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            Row(
                              children: [
                                const Text("Cafe"),
                                SizedBox(
                                  width: 5.w,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    ".",
                                    style: TextStyle(
                                      color: orangeColor,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(product.resName ?? ""),
                                SizedBox(
                                  width: 20.w,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ItemRating(
                                  rating: product.rating.toString(),
                                ),
                                SizedBox(
                                  width: 3.h,
                                ),
                                Text(
                                  '(${product.ratingCount} ${AppStrings.rating})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: secondaryFontColor,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    // Build search results UI
  }
}
