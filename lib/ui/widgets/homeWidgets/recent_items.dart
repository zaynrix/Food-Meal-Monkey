part of widgets;

class RecentItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('recent_items')
          .limit(2)
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
          padding: 16.paddingHorizontal,
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
                                  '(${product.ratingCount} rating)',
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
  }
}
