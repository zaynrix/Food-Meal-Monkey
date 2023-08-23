part of pages;
class CartPage extends StatefulWidget {
  const CartPage();

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CartController>(context , listen: false).fetchFoodItemsFromFirestore();
  }
  // final SingleProduct? singleProduct;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.p20.paddingHorizontal,
          child: Consumer<CartController>(
            builder: (context , value , child) => Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.cartProducts.length ,
                  itemBuilder: (context, index) {
                    final food = value.cartProducts[index];

                    return value.cartProducts.isNotEmpty ?
                    Column(
                      children: [
                        CartCard(food: food ,
                          onIncrement: () async {
                          value.incrementProduct(food);
                            await value.updateProductInFirestore(food);
                          },
                          onDecrement: () async {
                            value.decrementProduct(food);
                            await value.updateProductInFirestore(food);
                          },),
                        5.addVerticalSpace,
                        Divider(
                          color: secondaryFontColor,
                        ),

                      ],
                    )
                        :
                         Center(child: Text("No Item In Card", style: TextStyle(
                           color: Colors.black
                         ),),);

                  },
                ),
                50.addVerticalSpace,
                20.addVerticalSpace,
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: textTheme.titleMedium!.copyWith(color: Colors.black),),
                    Text(
                      '\$${calculateSubtotal(value.cartProducts).toStringAsFixed(2)}',
                    ),
                  ],
                ),
                SizedBox(
                  height: FlutterSizes.screenDeviceHeight.height * 0.35,
                )
              ],
            ),
          ),
        ),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<CartController>(
        builder: (context, instance, child) => FloatingActionButton(
          backgroundColor: orangeColor,
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  double calculateSubtotal(List<ProductModel> cartList) {
    double subtotal = 0.0;
    for (var product in cartList) {
      num price = product.price;
      num cartQuantity = product.cartQuantity;
      subtotal += price * cartQuantity;
    }
    return subtotal;
  }
}

