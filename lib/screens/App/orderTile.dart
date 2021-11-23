import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:picklick_customer/constants/constants.dart';

import 'package:picklick_customer/models/order.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class OrderTile extends StatefulWidget {
  OrderTile({required this.id, required this.price});
  String id;
  double price;
  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  void initState() {
    super.initState();
    getOrder();
  }

  late Order order;

  Future<bool> getOrder() async {
    var data = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.id)
        .get();
    print(data.data());
    order = Order.fromJson(data.data());
    print(order);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: RefreshIndicator(
          color: Color(0xFFCFB840),
          onRefresh: getOrder,
          child: FutureBuilder(
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
                                  '₹ ${order.dishes[index].price * order.dishes[index].quantity}'),
                              trailing: CircleAvatar(
                                  backgroundColor: Color(0xFFCFB840),
                                  child: Text(
                                    order.dishes[index].dishQuantity.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),

                      ListTile(
                        leading: CircleAvatar(
                          radius: 10,
                          backgroundColor: order.orderStatus ==
                                  OrderStatus.finished
                              ? Colors.green[300]
                              : order.orderStatus == OrderStatus.rejected
                                  ? Colors.red[200]
                                  : order.orderStatus == OrderStatus.inprocess
                                      ? Colors.yellow[300]
                                      : order.orderStatus ==
                                              OrderStatus.delivering
                                          ? Colors.orange[300]
                                          : Color(0xFFCFB840),
                        ),
                        title: order.orderStatus == OrderStatus.pending
                            ? Text(
                                'Your Ordering is being reveiwed, Please wait...')
                            : order.orderStatus == OrderStatus.inprocess
                                ? Text(
                                    'Your order has been accepted, Your meal is being prepared')
                                : order.orderStatus == OrderStatus.delivering
                                    ? Text(
                                        'Your order is being delivered by our delivery partner')
                                    : order.orderStatus == OrderStatus.finished
                                        ? Text(
                                            'Your order has been completed, Thank You!')
                                        : order.orderStatus ==
                                                OrderStatus.rejected
                                            ? Text(
                                                'Your order has been rejected, Please try agian')
                                            : null,
                      )
                    ],
                  ),
                );
              }
              return Loading();
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Center(child: Text('Total Price :   ₹ ${widget.price}')),
        ));
  }
}
