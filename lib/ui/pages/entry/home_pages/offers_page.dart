part of pages;

class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final CollectionReference offersCollection =
      FirebaseFirestore.instance.collection('latest_offers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latest offers"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
              child: const Text(
                "Find discounts, Offers special\nmeals and more!",
              ),
            ),
            addVerticalSpace(AppSize.s24.h),
            Container(
              margin: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
              height: AppSize.s30.h,
              width: AppSize.s155.w,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Check offers"),
              ),
            ),
            addVerticalSpace(AppSize.s22.h),
            StreamBuilder<QuerySnapshot>(
              stream: offersCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                ///Todo add description

                final offers = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return ProductModel.fromJson(data);
                }).toList();

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    ProductModel product = offers[index];

                    return GestureDetector(
                      onTap: () {
                        ServiceNavigation.serviceNavi
                            .pushNamedWidget(RouteGenerator.detailsPage , args: product);
                        // Provider.of<HomeController>(context, listen: false)
                        //     .navigateToDetailsPage(context, data);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: product.imagePath,
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                            placeholder: (context, url) => Center(
                                child: Image.asset(ImageAssets.app_icon)),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          addVerticalSpace(AppSize.s10.h),
                          Container(
                            margin: EdgeInsetsDirectional.only(
                              start: AppPadding.p20.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: primaryFontColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Row(
                                  children: [
                                    ItemRating(rating: product.rating.toString()),
                                    addHorizontalSpace(AppSize.s5.w),
                                    Text(
                                      '(${product.ratingCount} rating)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: secondaryFontColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          addVerticalSpace(AppSize.s30.h),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
