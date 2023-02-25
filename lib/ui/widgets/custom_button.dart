part of widgets;

class CustomButton extends StatelessWidget {
  final String text;
  Function() onPress;
  final IconData? icon;
  final Color color;

  CustomButton(
      {Key? key,
      required this.text,
      required this.onPress,
      this.icon,
      this.color = orangeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
      ),
      child: icon == null
          ? Text(text)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                SizedBox(
                  width: 20.w,
                ),
                Text(text)
              ],
            ),
    );
  }
}
