part of widgets;

class HeaderList extends StatelessWidget {
  const HeaderList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: primaryFontColor),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "View all",
            style: TextStyle(),
          ),
        )
      ],
    );
  }
}
