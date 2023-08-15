part of widgets;

class MoreTile extends StatelessWidget {
  const MoreTile({
    required this.title,
    required this.iconPath,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final String iconPath;
  final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsDirectional.only(end: AppMargin.m16.w),
        height: AppSize.s74.h,
        decoration: BoxDecoration(
            color: moreCardColor,
            borderRadius: BorderRadius.circular(AppSize.s7.r)
        ),
        child: Row(
          children: [
            hSpace14,
            CircleAvatar(
              backgroundColor: circleAvatarColor,
              radius: AppSize.s28.r,
              child: SvgPicture.asset(iconPath
              ,
              height: AppSize.s20,),
            ),
            hSpace20,
            Text(title, style: Theme.of(context).textTheme.headline5,),
            const Spacer(),
            Transform.translate(
              offset: Offset(AppSize.s20.w, 0),
              child: const CircleAvatar(
                backgroundColor: moreCardColor,
                child: Icon(Icons.arrow_forward_ios, color: secondaryFontColor,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
