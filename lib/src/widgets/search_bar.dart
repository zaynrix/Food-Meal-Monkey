part of widgets;

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 13.w, vertical: 30.h ),
      child: Container(
        width: 333.w,
        height: 45.h,
        decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(28)
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            hintText: "search food",
          ),
        ),
      ),
    );
  }
}
