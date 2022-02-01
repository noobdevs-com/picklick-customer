import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/services/geolocatrionservice.dart';

class LocationController extends GetxController {
  final geolocationService = GeolocationService();
  Position? position;
  String? address;

  setCurrentlocation() async {
    position = await geolocationService.getLocation();
  }
}
