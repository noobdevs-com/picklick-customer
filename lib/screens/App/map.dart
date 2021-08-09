import 'package:businessapp/controllers/auth.dart';
import 'package:businessapp/controllers/map.dart';
import 'package:businessapp/models/user.dart';
import 'package:businessapp/themes.dart' as k;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final AuthController _authController = Get.find();
  final User user = Get.arguments;
  // final MapController _mapController = Get.put(MapController());

  LatLng get initTarget {
    return LatLng(
      _authController.businessuser.location[0],
      _authController.businessuser.location[1],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
          init: MapController(),
          builder: (MapController _) {
            return Container(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _.controller = controller;
                      _.onMapCreated(user);
                    },
                    polylines: _.polyline,
                    markers: _.markers,
                    initialCameraPosition: CameraPosition(
                      target: initTarget,
                      zoom: 14.0,
                      tilt: 90,
                    ),
                    circles: _.circles,
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                  ),
                  Obx(() {
                    return Get.find<MapController>().loading.value == true
                        ? SafeArea(
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(k.red),
                              backgroundColor: k.white,
                            ),
                          )
                        : Container(height: 5);
                  })
                ],
              ),
            );
          }),

      // Update Route Button
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.find<MapController>().onMapCreated(user);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Icon(Icons.my_location),
        ),
      ),
    );
  }
}
