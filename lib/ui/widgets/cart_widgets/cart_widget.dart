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
    return Row(
      children: [
        Image.network(
          widget.food.imagePath,
          width: AppSize.s80.width,
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              20.addVerticalSpace,
              Text(
                '\$${widget.food.price}',
                // style: bodyBoldPrimary,
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

