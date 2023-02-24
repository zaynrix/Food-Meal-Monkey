part of widgets;

class MainTextField extends StatelessWidget {
  const MainTextField({Key? key, required this.text, required this.type, this.obs = false}) : super(key: key);
final String text;
final TextInputType type ;
final bool obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 307.w,
      height: 56.h,
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(28)
      ),
      child: TextFormField(
       // controller: emailController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '$text',
            hintStyle:
            TextStyle(color: unSelectedIconColor),
            contentPadding:
            EdgeInsetsDirectional.only(
                start: 34.h,
                top: 22.h,
                bottom: 20.h
            )
        ),
        keyboardType: type,
        obscureText: obs,
        onFieldSubmitted: (value) {
          print(value);
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
}
