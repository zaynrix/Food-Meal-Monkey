part of widgets;

class CartCard extends StatefulWidget {
  const CartCard({
    Key? key,
    required this.food,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  final ProductModel food;
  final void Function() onIncrement;
  final void Function() onDecrement;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        CachedNetworkImage(
          width: AppSize.s80.width,
          placeholder: (context, url) =>
              Center(child: Image.asset(ImageAssets.app_icon)),
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageUrl: widget.food.imagePath,
        ),
        AppSize.s25.addHorizontalSpace,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 166.width,
                child: Text(
                  widget.food.name,
                  style: textTheme.titleSmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              20.addVerticalSpace,
              Text(
                '\$${widget.food.price}',
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: widget.onDecrement,
            ),
            Text(widget.food.cartQuantity.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: widget.onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}
