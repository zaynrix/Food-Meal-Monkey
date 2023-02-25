part of widgets;

class MainTextField extends StatelessWidget {
  const MainTextField({Key? key, required this.text, required this.type, this.obscure = false}) : super(key: key);
final String text;
final TextInputType type ;
final bool obscure;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: orangeColor,
     // controller: emailController,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          hintStyle:
          const TextStyle(color: unSelectedIconColor),
          contentPadding:
          EdgeInsetsDirectional.only(
              start: 34.h,
              top: 22.h,
              bottom: 20.h
          )
      ),
      keyboardType: type,
      obscureText: obscure,
      onFieldSubmitted: (value) {
        debugPrint(value);
      },
      onChanged: (value) {
        debugPrint(value);
      },
    );
  }
}
