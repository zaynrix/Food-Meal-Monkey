part of pages;

class ChangeLocationPage extends StatefulWidget {
  const ChangeLocationPage({Key? key}) : super(key: key);

  @override
  State<ChangeLocationPage> createState() => _ChangeLocationPageState();
}

class _ChangeLocationPageState extends State<ChangeLocationPage> {
  @override
  initState() {
    super.initState();
    Provider.of<LocationController>(context, listen: false).onReady();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Location"),
      ),
      body: Consumer<LocationController>(
        builder: (context, controller, child) => Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: controller.initialCameraPosition,
                    markers: controller.markers,
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController mapController) async {
                      controller.googleMapController = mapController;
                      String value = await DefaultAssetBundle.of(context)
                          .loadString(JsonAssets.mapStyle);
                      controller.googleMapController.setMapStyle(value);
                    },
                  ),
                  Positioned(
                      child: Container(
                    width: FlutterSizes.screenDeviceWidth * 1,
                    height: FlutterSizes.screenDeviceHeight * 0.08,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: const Alignment(0, 1),
                            end: const Alignment(0.00, -1.00),
                            colors: [whiteColor.withOpacity(0), whiteColor])),
                    child: Text(
                      "You can choose your location\nby dragging the map",
                      style: textTheme.bodyLarge!.copyWith(
                          color: primaryFontColor,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ))
                ],
              ),
            ),
            Container(
              width: FlutterSizes.screenDeviceWidth * 1,
              height: FlutterSizes.screenDeviceHeight * 0.28,
              color: whiteColor,
              child: Column(
                children: [
                  Container(
                    padding: AppSize.s16.paddingAll,
                    width: 279.width,
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: AppSize.s16.circularRadius,
                        border: Border.all(color: orangeColor)),
                    child: Text(
                      controller.currantAddress,
                      style: textTheme.bodySmall!
                          .copyWith(fontWeight: FontWeight.normal),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppSize.s16.addVerticalSpace,
                  Padding(
                    padding: AppSize.s24.paddingHorizontal,
                    child: ElevatedButton(
                        onPressed: () {
                          controller.updateUserLocation();
                        },
                        child: const Text("Use this address")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
