part of widgets;

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, value, child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 30.h),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(28)),
          child: TextFormField(
            onChanged: (va) {
              value.search(va);
              value.fetchFoodItemsFromFirestore();
            },
            // enabled: false,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal),
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                hintText: "search food",
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: unSelectedIconColor)),
          ),
        ),
      ),
    );
  }
}
