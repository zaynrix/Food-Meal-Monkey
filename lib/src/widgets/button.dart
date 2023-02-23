part of widgets;

class ButtonMain extends StatelessWidget {
  final String text;
  Function() onPress;
  final IconData? ico;
  final Color color;


  ButtonMain({Key? key, required this.text, required this.onPress, this.ico, this.color = mainColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
          ),
          minimumSize: MaterialStateProperty.all<Size?>(Size(307.w, 56.h)),
          maximumSize: MaterialStateProperty.all<Size?>(Size(307.w, 56.h)),
          backgroundColor: MaterialStateProperty.all<Color>(color),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(16))),
      child: ico == null
          ? Text(text)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(ico),
                SizedBox(
                  width: 20.w,
                ),
                Text(text)
              ],
            ),
    );
  }
}

// onPressed: () {
// if(_activeIndex + 1 >= data.length){
// Navigator.pushReplacementNamed(context, '/starter');
// }
// _controller.nextPage(duration: Duration(milliseconds: 250), curve: Curves.ease);
// },
