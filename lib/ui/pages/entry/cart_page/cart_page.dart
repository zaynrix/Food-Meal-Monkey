part of pages;

class CartPage extends StatefulWidget {
  const CartPage();

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartController>(context, listen: false).fetchCartItems();
    initPaymentSheet();
  }

  Map<String, dynamic>? paymentIntent;
  // final SingleProduct? singleProduct;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Consumer<CartController>(
        builder: (context , controller , child) => Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: AppPadding.p20.paddingHorizontal,
                child: Column(
                  children: [

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final food = controller.cartItems[index];

                        return controller.cartItems.isNotEmpty
                            ? Column(
                                children: [
                                  CartCard(
                                    food: food,
                                    onIncrement: () async {
                                      controller.incrementProduct(food);
                                      await controller.updateCartItemQuantity(food);
                                    },
                                    onDecrement: () async {
                                      controller.decrementProduct(food);
                                      await controller.updateCartItemQuantity(food);
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
                          controller.calculateSubtotal(),
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
            Visibility(
              visible: controller.isLoading,
              child: Container(
                height: FlutterSizes.screenDeviceHeight,
                width: FlutterSizes.screenDeviceWidth,
                color: secondaryFontColor.withOpacity(0.3),
                child: const LoadingStatusWidget(
                  loadingStatus: LoadingStatusOption.loading,
                ),
              ),
            )

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<CartController>(
        builder: (context, instance, child) => Padding(
          padding: AppPadding.p24.paddingHorizontal,
          child: ElevatedButton(onPressed: (){
            if (instance.cartItems.isEmpty) {
              Helpers.showSnackBar(message: "Please Add Item In Cart", isSuccess: false);
            }  else {
              ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.checkoutPage);
            }

          }, child: Text("Checkout")),

        ),
      ),
    );
  }


  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }

  createPaymentIntent(String amount, String currency) async {
    // await dotenv.load(fileName: ".env");
    // final String secretKey = dotenv.get("stripePublishKey");
    //
    // try {
    //   Map<String, dynamic> body = {
    //     "amount": calculateAmount(amount),
    //     "currency": currency
    //   };
    //
    //   var response = await http.post(
    //       Uri.parse("https://api.stripe.com/v1/payment_intents"),
    //       body: body,
    //       headers: {
    //         "Authorization": "Bearer $secretKey",
    //         "Content-Type": "application/x-www-form-urlencoded"
    //       });
    //
    //   return jsonDecode(response.body);
    // }catch (e){
    //   debugPrint("err charging user : $e");
    // }
  }

  Future<void> initPaymentSheet() async {
    // try {
    //   paymentIntent = await createPaymentIntent("100" , "USD");
    //   await Stripe.instance.initPaymentSheet(
    //     paymentSheetParameters: SetupPaymentSheetParameters(
    //       customFlow: true,
    //       merchantDisplayName: 'Flutter Stripe Demo',
    //       paymentIntentClientSecret: paymentIntent!["client_secret"],
    //       // customerEphemeralKeySecret: "",
    //       // customerId: "",
    //       // setupIntentClientSecret: "",
    //       style: ThemeMode.light,
    //     ),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error: $e')),
    //   );
    //   rethrow;
    // }
  }

  Future<void> _displayPaymentSheet() async {
    // try {
    //   await Stripe.instance.presentPaymentSheet(
    //       options: const PaymentSheetPresentOptions(timeout: 1200000));
    //
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Payment successfully completed'),
    //     ),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('$e'),
    //     ),
    //   );
    // }
  }
}
