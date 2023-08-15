part of widgets;

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPress;
  final IconData? icon;
  final Color color;
  final bool isLoading;

  CustomButton({
    this.isLoading = false,
    Key? key,
    required this.text,
    required this.onPress,
    this.icon,
    this.color = orangeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPress,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isLoading ? Colors.grey : color,
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (icon == null
              ? Text(text)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon),
                    SizedBox(
                      width: 20,
                    ),
                    Text(text),
                  ],
                )),
    );
  }
}
