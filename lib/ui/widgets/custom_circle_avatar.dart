part of widgets;

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: orangeColor,
      radius: AppSize.s4.r,
    );
  }
}
