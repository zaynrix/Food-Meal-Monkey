part of pages;

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p20.w),
        child: Column(
          children: [
            MoreTile(
              title: 'Profile',

              /// TODO : add new {profile image} inn the assets
              iconPath: IconAssets.inboxIcon,
              onTap: () {
                ServiceNavigation.serviceNavi
                    .pushNamedWidget(RouteGenerator.profilePage);
              },
            ),
            vSpace20,
            MoreTile(
              title: 'Payment Details',
              iconPath: IconAssets.paymentIcon,
              onTap: () {
                ServiceNavigation.serviceNavi
                    .pushNamedWidget(RouteGenerator.paymentDetailsPage);
              },
            ),
            vSpace20,
            MoreTile(
              title: 'My Orders',
              iconPath: IconAssets.myOrderIcon,
              onTap: () {
                ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.ordersPage);
              },
            ),
            vSpace20,
            MoreTile(
              title: 'Notifications',
              iconPath: IconAssets.notificationIcon,
              onTap: () {},
            ),
            vSpace20,
            MoreTile(
              title: 'About Us',
              iconPath: IconAssets.aboutAsIcon,
              onTap: () {
                ServiceNavigation.serviceNavi
                    .pushNamedWidget(RouteGenerator.aboutAsPage);
              },
            ),
            vSpace20,
            MoreTile(
              title: 'Logout',
              iconPath: IconAssets.logoutIcon,
              onTap: () {
                // value.signOut(context);

                provider.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
