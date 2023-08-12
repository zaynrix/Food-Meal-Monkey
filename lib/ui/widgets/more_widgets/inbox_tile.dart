part of widgets;

class InboxTile extends StatelessWidget {
  const InboxTile({
    required this.title,
    required this.supTitle,
    required this.date,
    required this.isRead,
    Key? key,
  }) : super(key: key);
  final bool isRead;
  final String title;
  final String supTitle;
  final String date;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: isRead == true ? whiteColor : moreCardColor,
      padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p20.w, vertical: AppPadding.p12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomCircleAvatar(),
              hSpace5,
              Text(
                title,
                style: textTheme.headline5,
              ),
              const Spacer(),
              Text(date),
            ],
          ),
          vSpace15,
          Row(
            children: [
              hSpace14,
              Text(
                supTitle,
                style: textTheme.subtitle2,
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.star_border,
                color: orangeColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
