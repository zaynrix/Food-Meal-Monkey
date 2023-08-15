part of widgets;

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 13.w, vertical: 30.h ),
      child: Container(
        width: 333.w,
        height: 45.h,
        decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(28)
        ),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            hintText: "search food",
            hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: unSelectedIconColor)
          ),
        ),
      ),
    );
  }
}
