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
  bool loading = false;

  Future<bool> getOrder() async {
    setState(() {
      loading = true;
    });
    var data = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.id)
        .get();

    order = Order.fromJson(data.data());
    selectIndex();
    setState(() {
      loading = false;
    });
    return true;
  }

  int selectIndex() {
    order.orderStatus == OrderStatus.pending
        ? _index = 0
        : order.orderStatus == OrderStatus.inprocess
            ? _index = 1
            : order.orderStatus == OrderStatus.rejected
                ? _index = 3
                : order.orderStatus == OrderStatus.delivering
                    ? _index = 2
                    : order.orderStatus == OrderStatus.finished
                        ? _index = 3
                        : loading = true;
    return _index;
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: loading
            ? SizedBox()
            : RefreshIndicator(
                color: Color(0xFFCFB840),
                onRefresh: getOrder,
                child: FutureBuilder(
                  future: getOrder(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height / 2),
                            child: ListView.builder(
                              itemCount: order.dishes.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(order.dishes[index].name),
                                    subtitle: Text(
                                        '₹ ${order.dishes[index].price * order.dishes[index].quantity}'),
                                    trailing: Text(
                                      '${order.dishes[index].dishQuantity}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Stepper(
                            controlsBuilder: (_, a) {
                              return SizedBox(
                                height: 0,
                              );
                            },
                            currentStep: _index,
                            steps: <Step>[
                              Step(
                                isActive: _index == 0 ? true : false,
                                state: _index == 0
                                    ? StepState.indexed
                                    : _index > 0
                                        ? StepState.complete
                                        : StepState.disabled,
                                title: const Text('Order Placed'),
                                subtitle: Text('Review in progress !'),
                                content: Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                        'Your Order is being reviewed by the restaurant. Kindly wait for the response')),
                              ),
                              Step(
                                  isActive: _index == 1 ? true : false,
                                  state: _index == 1
                                      ? StepState.indexed
                                      : _index > 1
                                          ? StepState.complete
                                          : StepState.disabled,
                                  title: Text('Order Accepted '),
                                  content: Text(
                                      'Your order has been accepted and is being prepared ! ')),
                              Step(
                                isActive: _index == 2 ? true : false,
                                state: _index == 2
                                    ? StepState.indexed
                                    : _index > 2
                                        ? StepState.complete
                                        : StepState.disabled,
                                title: const Text('Delivery'),
                                subtitle:
                                    order.orderStatus == OrderStatus.delivering
                                        ? Text('Your food is on the way')
                                        : null,
                                content: Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                        'Our Delivery Partner is on the way')),
                              ),
                              Step(
                                isActive: _index == 3 ? true : false,
                                state: _index == 3
                                    ? StepState.indexed
                                    : _index > 3
                                        ? StepState.complete
                                        : StepState.disabled,
                                title: order.orderStatus == OrderStatus.rejected
                                    ? Text('Order Rejected')
                                    : const Text('Order Delivered'),
                                content: Container(
                                    alignment: Alignment.centerLeft,
                                    child: order.orderStatus ==
                                            OrderStatus.rejected
                                        ? Text(
                                            ' Oops ! Your order has been rejected !')
                                        : const Text(
                                            'Your order has been delivered succesfully ! .Enjoy your meal !')),
                              ),
                            ],
                          )
                        ],
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
