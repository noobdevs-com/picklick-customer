import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:picklick_customer/constants/constants.dart';

import 'loading.dart';
import 'orderTile.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Loading();
            final data = snapshot.data!.docs;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      // tileColor: data[index]['orderStatus'] ==
                      //         OrderStatus.rejected.toString()
                      //     ? Colors.red
                      //     : Colors.green,
                      onTap: () {
                        Get.to(
                          () => OrderTile(
                            id: data[index].id,
                            price: data[index]['price'],
                          ),
                        );
                      },

                      trailing: CircleAvatar(
                        radius: 10,
                        backgroundColor: data[index]['orderStatus'] ==
                                OrderStatus.finished
                            ? Colors.green[300]
                            : data[index]['orderStatus'] == OrderStatus.rejected
                                ? Colors.red[200]
                                : data[index]['orderStatus'] ==
                                        OrderStatus.inprocess
                                    ? Colors.yellow[300]
                                    : data[index]['orderStatus'] ==
                                            OrderStatus.delivering
                                        ? Colors.orange[300]
                                        : Color(0xFFCFB840),
                      ),

                      title: Text(
                          'Total Price : ₹ ${data[index]['price'].toString()}'),
                      subtitle: Text(DateFormat.yMMMEd()
                          .add_jms()
                          .format(DateTime.parse(
                              data[index]['orderedAt'].toDate().toString()))
                          .toString()),
                    ),
                  );
                });
          }),
    );
  }
}
