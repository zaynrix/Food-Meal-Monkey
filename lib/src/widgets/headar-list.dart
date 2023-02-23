part of widgets;

class HeadarList extends StatelessWidget {
  const HeadarList({Key? key, required this.title}) : super(key: key);

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
              .headline5!
              .copyWith(color: primaryFontColor),
        ),
        TextButton(
            onPressed: () {},
            child: Text("View all"))
      ],
    );
  }
}
