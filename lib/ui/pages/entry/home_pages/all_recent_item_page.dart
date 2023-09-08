part of pages;

class AllRecentItemPage extends StatelessWidget {
  const AllRecentItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Item"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreConstants.recent_items)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    const CircularProgressIndicator()); // Loading indicator while data is fetched
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return const Text(
                'No recent items available.'); // Display a message if no data is available
          }

          final docs = snapshot.data!.docs;

          return Padding(
            padding: AppPadding.p24.paddingHorizontal,
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.transparent,
              ),
              scrollDirection: Axis.vertical,
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
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          )
                        ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 80.w,
                            // height: 80.h,
                            child: Hero(
                              tag: product.imagePath,
                              child: CachedNetworkImage(
                                imageUrl: product.imagePath,
                                height: 90.h,
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
                          child: Container(
                            padding: AppPadding.p8.paddingVertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(color: Colors.black),
                                ),
                                10.addVerticalSpace,
                                Text(product.resName ?? ""),
                                10.addVerticalSpace,
                                Row(
                                  children: [
                                    ItemRating(
                                      rating: product.rating.toString(),
                                    ),
                                    SizedBox(
                                      width: 3.h,
                                    ),
                                    Text(
                                      '(${product.ratingCount} rating)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: secondaryFontColor,
                                              fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
