part of widgets;

// class MostPopular extends StatelessWidget {
//   const MostPopular({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         shrinkWrap: true,
//         // physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: ItemModel.mostPopular.length,
//         itemBuilder: (context, index) {
//           ItemModel data = ItemModel.mostPopular[index];
//           return Container(
//             padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
//             width: 228.w,
//             height: 185.h,
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               //margin: EdgeInsetsDirectional.only(start: 0, end: 0),
//               children: [
//                 Image.asset(
//                   data.imagePath,
//
//                   height: 135.h,
//                 ),
//                 addVerticalSpace(AppSize.s12.h),
//                 Text(
//                   data.name,
//                   style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                       color: primaryFontColor, fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     ItemRating(
//                       rating: data.rating,
//                     ),
//                     SizedBox(
//                       width: 3.h,
//                     ),
//                     Text(
//                       '(${data.ratingCount} rating)',
//                       style: Theme.of(context).textTheme.caption!.copyWith(
//                           color: secondaryFontColor,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
//

class MostPopular extends StatelessWidget {
  const MostPopular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('most_popular_food')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No data available');
        }

        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            String title = doc['title'];
            String rating = doc['rating'];
            String description = doc['description'];
            String imagePath = doc['imagePath'];
            String ratingCount = doc['ratingCount'];

            return Container(
              padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
              width: 228.w,
              height: 185.h,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imagePath,
                    height: 135.h,
                  ),
                  addVerticalSpace(AppSize.s12.h),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black, // Customize text color
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      ItemRating(rating: rating.toString()),
                      SizedBox(
                        width: 3.h,
                      ),
                      Text(
                        ratingCount,
                        style: TextStyle(
                          color: Colors.grey, // Customize text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
