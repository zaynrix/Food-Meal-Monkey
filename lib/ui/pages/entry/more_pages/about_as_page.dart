part of pages;

class AboutAsPage extends StatelessWidget {
  const AboutAsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.labelMedium;
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        leading: IconButton(onPressed: (){ServiceNavigation.serviceNavi.back();}, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),],
      ),
      body: Column(
        children: [
          ListTile(
            minLeadingWidth: 5.w,
            leading: CircleAvatar(
              backgroundColor: orangeColor,
              radius: 3.r,
            ),
            title: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: textStyle,
            ),
          ),
          ListTile(
            minLeadingWidth: 5.w,
            leading: CircleAvatar(
              backgroundColor: orangeColor,
              radius: 3.r,
            ),
            title: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: textStyle,
            ),
          ),
          ListTile(
            minLeadingWidth: 5.w,
            leading: CircleAvatar(
              backgroundColor: orangeColor,
              radius: 3.r,
            ),
            title: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: textStyle,
              // textAlign: TextAlignVertical.top,
            ),
          )
        ],
      ),
    );
  }
}
