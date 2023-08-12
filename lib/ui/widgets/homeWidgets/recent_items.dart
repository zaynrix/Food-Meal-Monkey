part of widgets;

// class RecentItems extends StatelessWidget {
//   RecentItems({Key? key}) : super(key: key);
//   final data = ItemModel.recentItem;
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: ItemModel.recentItem.length,
//         itemBuilder: (context, index) => Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: SizedBox(
//                     width: 80.w,
//                     height: 80.h,
//                     child: Image.asset(data[index].imagePath),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10.h,
//                 ),
//                 Expanded(
//                   child: SizedBox(
//                     height: 100.h,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           data[index].name,
//                           style: Theme.of(context)
//                               .textTheme
//                               .headline4!
//                               .copyWith(color: primaryFontColor),
//                         ),
//                         Row(
//                           children: [
//                             const Text("Cafe"),
//                             SizedBox(
//                               width: 5.w,
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.only(bottom: 5.0),
//                               child: Text(
//                                 ".",
//                                 style: TextStyle(
//                                   color: orangeColor,
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 5.w,
//                             ),
//                             const Text("Western Food"),
//                             SizedBox(
//                               width: 20.w,
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             ItemRating(
//                               rating: data[index].rating.toString(),
//                             ),
//                             SizedBox(
//                               width: 3.h,
//                             ),
//                             Text(
//                               '(${data[index].ratingCount} rating)',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .caption!
//                                   .copyWith(
//                                       color: secondaryFontColor,
//                                       fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ));
//   }
// }

class RecentItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('recent_items').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator while data is fetched
        }
        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          return const Text(
              'No recent items available.'); // Display a message if no data is available
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final itemData = snapshot.data!.docs[index].data();
            String image = itemData['imagePath'];
            String name = itemData['name'];
            // String description = itemData['description'];
            String rating = itemData['rating'];
            String ratingCount = itemData['ratingCount'];
            String res_name = itemData['res_name'];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(image), // Load image from network
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
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
                            Text(res_name),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ItemRating(
                              rating: rating,
                            ),
                            SizedBox(
                              width: 3.h,
                            ),
                            Text(
                              '($ratingCount rating)',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
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
            );
          },
        );
      },
    );
  }
}
