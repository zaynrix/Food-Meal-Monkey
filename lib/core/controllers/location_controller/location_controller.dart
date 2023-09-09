import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/service_locator.dart';
import 'package:food_delivery_app/utils/enums.dart';
import 'package:food_delivery_app/utils/helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends ChangeNotifier {

  double latitude = 37.42796133580664;
  double longitude = -122.085749655962;

  static const LatLng latLng = LatLng(37.42796133580664, -122.085749655962);

  CameraPosition initialCameraPosition =
  const CameraPosition(target: latLng, zoom: 14);

  Set<Marker> markers = {};

  late GoogleMapController googleMapController;
  late Position currentPosition;
  String currantAddress = "";


  String getUserId() {
    debugPrint("This is inside stop loading");
    return sl<AuthController>().auth.currentUser!.uid;
  }

  bool isLoading = false;
  startDialogLoading() {
    isLoading = true;
    notifyListeners();
    debugPrint("This is inside start loading");
    Helpers.showLoadingDialog(
        message: "Loading...", status: LoadingStatusOption.loading);
  }

  stopDialogLoading() {
    isLoading = false;
    notifyListeners();
    ServiceNavigation.serviceNavi.back();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userAddress = "";

  Future<void> getUserLocation() async {
    final String userId = getUserId();
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final address = userData['address'] as String;
        userAddress = address;
        notifyListeners();
        print('Address: $address');
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error retrieving address: $e');
    }
  }


  Future<void> updateUserLocation() async {
    startDialogLoading();
    try{
      await _updateUserLocation();
      await getUserLocation();
      stopDialogLoading();
      Helpers.showSnackBar(message: "Change Address Successfully", isSuccess: true);

      ServiceNavigation.serviceNavi.back();
    } catch(e) {
      stopDialogLoading();
      Helpers.showSnackBar(message: "Change Address Failed", isSuccess: false);
      debugPrint("Error Change User Location $e");
    }
  }

  Future<void> _updateUserLocation() {
    final userId = getUserId();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'address': currantAddress});
  }



  void onReady() async {
    debugPrint("This is inside init \n ************* ");
    currentPosition = await determinePosition();
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 18)));
    getAddressFromLatLng(currentPosition);
    notifyListeners();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placeMarks) {
      Placemark place = placeMarks[0];
      currantAddress =
      "${place.street}, ${place.subLocality}\n ${place.subAdministrativeArea}, ${place.postalCode}";
      notifyListeners();
      debugPrint("This is currantAddress: :\n >>>>>> $currantAddress");
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }
}
