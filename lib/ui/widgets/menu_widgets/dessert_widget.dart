part of widgets;

class DessertsWidget extends StatelessWidget {
  const DessertsWidget({
    required this.title,
    required this.imagePath,
    required this.label,
    required this.rate,
    Key? key,
  }) : super(key: key);

  final String title;
  final String label;
  final String imagePath;
  final double rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: AppMargin.m8.h),
      height: AppSize.s200.h,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.fill
          )
      ),
      child:  Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
            padding: EdgeInsetsDirectional.only(bottom: AppPadding.p25.h, start: AppPadding.p20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.subtitle1,),
                vSpace5,
                Row(
                  children: [
                     ItemRating(
                      rating: rate,
                    ),
                    hSpace14,
                    Text(label, style: Theme.of(context).textTheme.bodyText1,),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
