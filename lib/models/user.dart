class CustomerUser {
  String name;
  String email;
  String address;

  CustomerUser(
      {required this.address, required this.email, required this.name});

  factory CustomerUser.toJson(json) {
    return CustomerUser(
        name: json['name'], email: json['email'], address: json['address']);
  }
}
