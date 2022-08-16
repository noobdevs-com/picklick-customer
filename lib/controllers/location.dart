import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  Position? position;
  String? address;
  double? distance;
  String? geoCodeLocation;

  @override
  void onInit() {
    super.onInit();
    setCurrentlocation();
    getGeoCodeLocation();
  }

  Future setCurrentlocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  getDistanceBtwUserAndRestaurant(GeoPoint restaurantPosition) async {
    distance = Geolocator.distanceBetween(
        position!.latitude,
        position!.longitude,
        restaurantPosition.latitude,
        restaurantPosition.longitude);
    print(distance);
  }

  getGeoCodeLocation() async {
    await setCurrentlocation();

    final result =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    geoCodeLocation =
        '${result[0].name}, ${result[0].street}, ${result[0].locality}, ${result[0].subAdministrativeArea}, ${result[0].postalCode}';
  }
}
