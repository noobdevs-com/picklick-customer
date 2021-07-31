import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/models/order.dart';
import 'package:picklick_customer/screens/App/loading.dart';
import 'package:intl/intl.dart';

class OrderTile extends StatefulWidget {
  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  void initState() {
    super.initState();
    print(Get.arguments['id']);
  }

  late Order order;

  Future<bool> getOrder() async {
    var data = await FirebaseFirestore.instance
        .collection('orders')
        .doc(Get.arguments['id'])
        .get();
    print(data.data());
    order = Order.fromJson(data.data());
    print(order);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: getOrder(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  children: [
                    // Dish Details
                    ListView.builder(
                      itemCount: order.dishes.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(order.dishes[index].name),
                            subtitle: Text(
                                '₹ ${order.dishes[index].price.toString()}'),
                            trailing:
                                Text(order.dishes[index].quantity.toString()),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            }
            return Loading();
          },
        ),
      ),
    );
  }
}
