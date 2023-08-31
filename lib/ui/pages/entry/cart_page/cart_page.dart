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
    Provider.of<CartController>(context, listen: false).fetchCartItems();
    initPaymentSheet();
  }

  Map<String , dynamic>? paymentIntent;
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
            builder: (context, value, child) => Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.cartItems.length,
                  itemBuilder: (context, index) {
                    final food = value.cartItems[index];

                    return value.cartItems.isNotEmpty
                        ? Column(
                            children: [
                              CartCard(
                                food: food,
                                onIncrement: () async {
                                  value.incrementProduct(food);
                                  await value.updateCartItemQuantity(food);
                                },
                                onDecrement: () async {
                                  value.decrementProduct(food);
                                  await value.updateCartItemQuantity(food);
                                },
                              ),
                              5.addVerticalSpace,
                              Divider(
                                color: secondaryFontColor,
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              "No Item In Card",
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                  },
                ),
                50.addVerticalSpace,
                20.addVerticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style:
                          textTheme.titleMedium!.copyWith(color: Colors.black),
                    ),
                    Text(
                      '\$${calculateSubtotal(value.cartItems).toStringAsFixed(2)}',
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
        builder: (context, instance, child) => Padding(
          padding: AppPadding.p24.paddingHorizontal,
          child: ElevatedButton(onPressed: (){
            ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.addPaymentPage);
          }, child: Text("Checkout")),
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

  calculateAmount(String amount){
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }

  createPaymentIntent(String amount , String currency) async {
    await dotenv.load(fileName: ".env");
    final String secretKey = dotenv.get("stripePublishKey");

    try {
      Map<String, dynamic> body = {
        "amount": calculateAmount(amount),
        "currency": currency
      };

      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer $secretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          });

      return jsonDecode(response.body);
    }catch (e){
      debugPrint("err charging user : $e");
    }
  }

  Future<void> initPaymentSheet() async {
    try {
      paymentIntent = await createPaymentIntent("100" , "USD");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: true,
          merchantDisplayName: 'Flutter Stripe Demo',
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          // customerEphemeralKeySecret: "",
          // customerId: "",
          // setupIntentClientSecret: "",
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          options: const PaymentSheetPresentOptions(timeout: 1200000));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successfully completed'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }
}
