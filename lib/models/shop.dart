import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  Shop({this.name, this.location, this.img, this.ownerId, this.status});

  String? name;
  String? location;
  GeoPoint? geoLocation;
  String? img;
  String? ownerId;
  String? status;

  List<Shop> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return Shop(
          status: dataMap['status']!,
          img: dataMap['img']!,
          name: dataMap['name']!,
          location: dataMap['location']!,
          ownerId: dataMap['ownerId']!);
    }).toList();
  }

  factory Shop.toJson(json) {
    return Shop(
        status: json['status'],
        img: json['img'],
        name: json['name'],
        location: json['location'],
        ownerId: json['ownerId']);
  }
}
