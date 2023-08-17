part of widgets;

class CurrentLocation extends StatelessWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Location",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: secondaryFontColor)),
          SizedBox(
            height: 8.w,
          ),
          Row(
            children: [
              Text("Current Location",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: primaryFontColor)),
              SizedBox(
                width: 34.w,
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
              )
            ],
          ),
        ],
      ),
    );
  }
}
