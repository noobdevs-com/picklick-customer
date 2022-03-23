import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  Position? position;
  String? address;
  double? distance;

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
}
