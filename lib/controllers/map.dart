import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final loading = false.obs;
  GoogleMapController? controller;
  final polyline = Set<Polyline>().obs;
  final markers = Set<Marker>().obs;
  final circles = Set<Circle>().obs;
  ByteData? byteData;
  String googleAPiKey = 'AIzaSyDj6VGvX5WX2O3ubUWnMP-EGAFb03o016U';
  double _originLatitude = 26.48424;
  double _originLongitude = 50.04551;
  double _destLatitude = 26.46423;
  double _destLongitude = 50.06358;
  List<LatLng> polylineCoordinates = [];
  

  PolylinePoints polylinePoints = PolylinePoints();

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
  

  // GoogleMapPolyline googleMapPolyline =
  //      GoogleMapPolyline(apiKey: "AIzaSyBgO-lggOCRT_FH-Fme6cKk0E1WOY-vcFI");

  // final StorageController _storageController = Get.find();
  late StreamSubscription<Position> positionStream;

  @override
  void onInit() {
    positionStream =
        Geolocator.getPositionStream(intervalDuration: Duration(seconds: 5))
            .listen((Position event) {
      updateBusinessUserLocation(event);
    });
    super.onInit();
  }

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
  }

  Future<Position> get currentPosition async =>
      await Geolocator.getCurrentPosition();

  Future updateBusinessUserLocation(Position position) async {
    // Wait for Icon(image) to loaded from assets
    if (byteData == null) return;
    circles.clear();
    LatLng latLng = LatLng(position.latitude, position.longitude);

    // Businessuser Marker
    markers.add(Marker(
      markerId: MarkerId('1'),
      position: latLng,
      anchor: Offset(0.5, 0.5),
      rotation: position.heading,
      zIndex: 2,
      icon: BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List()),
    ));

    circles.add(Circle(
      radius: 20,
      fillColor: Colors.blue.withAlpha(70),
      strokeColor: Colors.blue.withAlpha(50),
      strokeWidth: 3,
      circleId: CircleId('1'),
      zIndex: 1,
      center: latLng,
    ));
    controller!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: latLng,
        zoom: 18.0,
      ),
    ));
    update();
  }

  Future updatePolylines(Position position, User user) async {
    List<LatLng> routeCoords =
        await googleMapPolyline.getCoordinatesWithLocation(
      origin: LatLng(position.latitude, position.longitude),
      destination: LatLng(user.location[0], user.location[1]),
      mode: RouteMode.driving,
    );
    // Clear all marker and polylines
    polyline.clear();

    polyline.add(Polyline(
      polylineId: PolylineId('route1'),
      visible: true,
      points: routeCoords,
      width: 4,
      color: Colors.blue,
      startCap: Cap.squareCap,
      endCap: Cap.buttCap,
    ));
    update();
  }

  Future<void> onMapCreated(User user) async {
    loading.value = true;
    Position initTarget = await currentPosition;

    try {
      byteData =
          await DefaultAssetBundle.of(Get.context).load('assets/car_icon.png');

      await updatePolylines(initTarget, user);
      // Customer Marker
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId('2'),
        position: LatLng(user.location[0], user.location[1]),
      ));

      await updateBusinessUserLocation(initTarget);

      // Animate to the Location
      controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(user.location[0], user.location[1]),
          zoom: 18.0,
          tilt: 0,
        ),
      ));
      loading.value = false;
      update();
      print('updated route');
    } catch (error) {
      print(error);
      Get.snackbar('Map Error', 'Route failed to load...');
    }
  }

  updateCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    print(position);
    // _storageController.storage.write('currentposition', position);
  }
}
