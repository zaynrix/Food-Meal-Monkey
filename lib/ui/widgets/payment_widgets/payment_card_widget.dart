part of widgets;
class PaymentCardWidget extends StatelessWidget {
  const PaymentCardWidget({
    required this.onTap,
    required this.imagePath,
    required this.supTitle,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final String supTitle;
  final String imagePath;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: AppPadding.p24.paddingBottom,
      margin: AppMargin.m24.marginBottom,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: primaryFontColor)
      ),),
      child: Row(
        children: [
            Container(
              padding: AppPadding.p8.paddingAll,
              height: AppSize.s45.height,
              width: AppSize.s45.width,
              decoration: BoxDecoration(
                  color: whiteColor,
                  shape: BoxShape.rectangle,
                  borderRadius: AppSize.s10.circularRadius
              ),
              child: Image.asset(imagePath),
            ),
          AppSize.s20.addHorizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title ,style: textTheme.titleSmall,),
              AppSize.s5.addVerticalSpace,
              Text(supTitle ,style: textTheme.titleSmall,)
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.width, vertical: AppSize.s7.height),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: orangeColor),
            ),
            child: InkWell(
              onTap: onTap,
                child: Text("Delete Card" ,  style: textTheme.bodySmall!.copyWith(color: orangeColor , fontWeight: FontWeight.bold),)),
          )
        ],
      ),
    );
  }
}
