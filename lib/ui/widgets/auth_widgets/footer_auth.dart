part of widgets;

class FooterAuth extends StatelessWidget {
  const FooterAuth(
      {Key? key,
      required this.text,
      required this.textButton,
      required this.onPressed})
      : super(key: key);
  final String text;
  final String textButton;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            textButton,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
          ),
        ),
      ],
    );
  }
}
