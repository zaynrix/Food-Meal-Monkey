part of pages;

class PopularRestaurantScreen extends StatelessWidget {
  const PopularRestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, homeController, child) => Scaffold(
        appBar: AppBar(
          title: Text("Popular Restaurant"),
        ),
        body: SingleChildScrollView(
          child:  StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(FirestoreConstants.restaurants)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data available');
              }

              List<DocumentSnapshot> restaurantDocs = snapshot.data!.docs;

              return ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                  height: 16,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: restaurantDocs.length,
                itemBuilder: (context, index) {
                  FoodItem restaurant = FoodItem.fromFirestore(
                      restaurantDocs[index].data() as Map<String, dynamic>);

                  return Column(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: restaurant.imagePath,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            Center(child: Image.asset(ImageAssets.app_icon)),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      addVerticalSpace(AppSize.s10.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: primaryFontColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            ItemRating(
                              rating: restaurant.rating.toString(),
                            ),
                            addHorizontalSpace(AppSize.s5.w),
                            Text(
                              '(${restaurant.ratingCount} rating)',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color: secondaryFontColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        )

      ),
    );
  }
}
