import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/models/dish.dart';

class Order {
  List<Dish> dishes;
  OrderStatus orderStatus;
  DateTime dateTime;
  PaymentMethod paymentMethod;
  double price;
  int quantity;
  String uid;

  Order({
    required this.dishes,
    required this.orderStatus,
    required this.dateTime,
    required this.paymentMethod,
    required this.price,
    required this.quantity,
    required this.uid,
  });

  factory Order.fromJson(json) {
    return Order(
      dishes: json['dishes'].map<Dish>((d) => Dish.toJson(d)).toList(),
      orderStatus: OrderStatus.values
          .firstWhere((e) => e.toString() == json['orderStatus']),
      dateTime: DateTime.parse(json['orderedAt'].toDate().toString()),
      paymentMethod: PaymentMethod.values
          .firstWhere((e) => e.toString() == json['paymentMethod']),
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      uid: json['uid'],
    );
  }
}
