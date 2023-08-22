part of widgets;

class MostPopular extends StatefulWidget {
  final homeController;

  const MostPopular({Key? key, required this.homeController}) : super(key: key);

  @override
  State<MostPopular> createState() => _MostPopularState();
}

class _MostPopularState extends State<MostPopular> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.homeController.getMostPopularFoodStream(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No data available');
        }

        final docs = snapshot.data!.docs;
        debugPrint("This is docs for most pobular >>> $docs");
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final product = ProductModel.fromDocument(doc);

            return GestureDetector(
              onTap: () {
                ServiceNavigation.serviceNavi
                    .pushNamedWidget(RouteGenerator.detailsPage , args: product);
              },
              child: Container(
                padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
                // width: 200.w,
                height: 185.h,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: product.imagePath,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: product.imagePath,
                            height: 135.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                                child: Image.asset(ImageAssets.app_icon)),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    addVerticalSpace(AppSize.s12.h),
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        ItemRating(rating: product.rating.toString()),
                        SizedBox(
                          width: 3.h,
                        ),
                        Text(
                          product.ratingCount.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
