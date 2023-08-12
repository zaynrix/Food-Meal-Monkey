part of widgets;

class MainTextField extends StatelessWidget {
  const MainTextField(
      {Key? key,
      required this.text,
      required this.type,
      this.obscure = false,
      this.controller})
      : super(key: key);
  final String text;
  final TextInputType type;
  final bool obscure;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: orangeColor,
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          hintStyle: const TextStyle(
              color: unSelectedIconColor, fontWeight: FontWeight.normal),
          contentPadding:
              EdgeInsetsDirectional.only(start: 34.h, top: 22.h, bottom: 20.h)),
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
