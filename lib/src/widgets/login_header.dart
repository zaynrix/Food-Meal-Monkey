part of widgets;

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key, required this.title, required this.caption, this.height = 30}) : super(key: key);
  final String title;
  final String caption;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 68.h,
        ),
        SizedBox(
          width: 296.w,
          height: height.h,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline5!.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryFontColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 18.h,
        ),
        SizedBox(
          width: 270.w,
          height: 35.h,
          child: Text(
            caption,
            style: Theme.of(context).textTheme.caption!.copyWith(
              fontWeight: FontWeight.bold,
              color: secondaryFontColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 37.h,
        ),
      ],
    );
  }
}
