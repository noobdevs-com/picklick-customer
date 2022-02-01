import 'package:geolocator/geolocator.dart';

class GeolocationService {
  Future<Position> getLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    return position;
  }
}
