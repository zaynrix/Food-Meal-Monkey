part of widgets;

class AuthHeader extends StatelessWidget {
  const AuthHeader({Key? key, required this.title, required this.caption, }) : super(key: key);
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        addVerticalSpace(AppSize.s66.h),
        Text(
          title,
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        addVerticalSpace(AppSize.s12.h),
        Text(
          caption,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),

      ],
    );
  }
}
