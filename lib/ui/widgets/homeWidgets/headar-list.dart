part of widgets;

class HeaderList extends StatelessWidget {
  const HeaderList(
      {
        required this.onPressed,
        Key? key,
        required this.title}) : super(key: key);

  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme
              .headlineSmall!
              .copyWith(color: primaryFontColor),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            "View all",
            style: textTheme.bodyMedium!.copyWith(color: orangeColor),
          ),
        )
      ],
    );
  }
}
