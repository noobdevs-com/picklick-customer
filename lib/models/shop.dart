class Shop {
  Shop(
      {required this.name,
      required this.location,
      required this.img,
      required this.ownerId,
      required this.status});

  String name;
  String location;
  String img;
  String ownerId;
  String status;

  factory Shop.toJson(json) {
    return Shop(
        status: json['status'],
        img: json['img'],
        name: json['name'],
        location: json['location'],
        ownerId: json['ownerId']);
  }
}
