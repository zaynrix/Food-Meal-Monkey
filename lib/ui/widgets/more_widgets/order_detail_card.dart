part of widgets;
class OrderDetailCard extends StatelessWidget {
  const OrderDetailCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.price,
  }) : super(key: key);

  final String title;
  final String imagePath;
  final String price;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: AppSize.s16.marginBottom,
      height: 104.height,
      decoration: BoxDecoration(
          border: Border(
              bottom:
              BorderSide(color: secondaryFontColor))),
      child: Padding(
        padding: AppSize.s24.paddingBottom,
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: imagePath,
              height: AppSize.s80.height,
              width: AppSize.s80.width,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: Image.asset(ImageAssets.app_icon)),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error),
            ),
            AppSize.s16.addHorizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium!.copyWith(color: primaryFontColor),
                  ),
                  const Spacer(),
                  FittedBox(
                    child: Text(
                      "\$$price",
                      style: textTheme.bodyLarge,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
