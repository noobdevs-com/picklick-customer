import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/screens/App/paymentMethodScreen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
        ),
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  4,
                  4,
                  4,
                  0,
                ),
                child: Card(
                  child: ListTile(
                    title: Text('data'),
                    subtitle: Text(''),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 28,
                    ),
                    trailing: SizedBox(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                });
                              },
                              icon: Icon(Icons.remove)),
                          Text(quantity.toString()),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: Icon(Icons.add)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 10,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    '      Total :  ₹ ${0.0}',
                    style: TextStyle(fontSize: 20),
                  )),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => PaymentMethodScreen());
                  },
                  child: Text('Proceed'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
