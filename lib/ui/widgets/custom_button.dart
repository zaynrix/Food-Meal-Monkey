part of widgets;
//
// class CustomButton extends StatelessWidget {
//   final String text;
//   Function() onPress;
//   final IconData? icon;
//   final Color color;
//
//   CustomButton(
//       {Key? key,
//       required this.text,
//       required this.onPress,
//       this.icon,
//       this.color = orangeColor})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPress,
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all<Color>(color),
//       ),
//       child: icon == null
//           ? Text(text)
//           : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 Text(text)
//               ],
//             ),
//     );
//   }
// }

class CustomButton extends StatefulWidget {
  final String text;
  final Function() onPress;
  final IconData? icon;
  final Color color;

  CustomButton({
    Key? key,
    required this.text,
    required this.onPress,
    this.icon,
    this.color = orangeColor,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _onButtonPress,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          _isLoading ? Colors.grey : widget.color,
        ),
      ),
      child: _isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (widget.icon == null
              ? Text(widget.text)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon),
                    SizedBox(
                      width: 20,
                    ),
                    Text(widget.text),
                  ],
                )),
    );
  }

  void _onButtonPress() async {
    setState(() {
      _isLoading = true;
    });

    await widget.onPress();

    setState(() {
      _isLoading = false;
    });
  }
}
