part of widgets;

class RecentItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('recent_items').snapshots(),
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

        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.transparent,
          ),
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
                    width: 80.w,
                    height: 80.h,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      height: 80.h,
                      width: 80.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                          name,
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
            );
          },
        );
      },
    );
  }
}
