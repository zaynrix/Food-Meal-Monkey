part of widgets;

class ItemRating extends StatelessWidget {
  const ItemRating({Key? key, required this.rating}) : super(key: key);
  final String rating;

  @override
  Widget build(BuildContext context) {
    print("This rating ${rating.runtimeType}");
    return Row(
      children: [
        RatingBarIndicator(
            itemCount: 1,
            rating: double.parse(rating),
            itemSize: 15.r,
            itemBuilder: (context, index) {
              return const Icon(
                Icons.star,
                color: orangeColor,
              );
            }),
        SizedBox(
          width: 5.w,
        ),
        Text(
          '$rating',
          style:
              Theme.of(context).textTheme.caption!.copyWith(color: orangeColor),
        )
      ],
    );
  }
}
