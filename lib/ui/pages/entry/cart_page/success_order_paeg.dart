part of pages;

class SuccessOrderPage extends StatelessWidget {
  const SuccessOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: AppPadding.p24.paddingHorizontal,
        child: Column(
          children: [
            AppSize.s200.addVerticalSpace,
            SvgPicture.asset(SvgAssets.successOrder),
            AppSize.s30.addVerticalSpace,
            Text(
              "Thank You!",
              style: textTheme.displaySmall!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              "for your order",
              style: textTheme.titleMedium,
            ),
            AppSize.s20.addVerticalSpace,
            Text(
              "Your Order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your Order",
              style:
                  textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
            ),
            AppSize.s35.addVerticalSpace,
            CustomButton(
                text: "Go To Home Page",
                onPress: () {
                  ServiceNavigation.serviceNavi
                      .pushNamedReplacement(RouteGenerator.mainPage);
                })
          ],
        ),
      ),
    );
  }
}
