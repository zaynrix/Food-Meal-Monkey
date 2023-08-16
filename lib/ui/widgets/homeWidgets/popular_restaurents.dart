part of widgets;

class PupularResturent extends StatelessWidget {
  const PupularResturent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('restaurants').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data available');
        }

        List<DocumentSnapshot> restaurantDocs = snapshot.data!.docs;

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: restaurantDocs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> restaurantData =
                restaurantDocs[index].data() as Map<String, dynamic>;

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: restaurantData['imagePath'],
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      Center(child: Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                addVerticalSpace(AppSize.s10.h),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    restaurantData['name'],
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: primaryFontColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      ItemRating(
                        rating: restaurantData['rating'],
                      ),
                      addHorizontalSpace(AppSize.s5.w),
                      Text(
                        '(${restaurantData['ratingCount']} rating)',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: secondaryFontColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(AppSize.s30.h)
              ],
            );
          },
        );
      },
    );
  }
}
