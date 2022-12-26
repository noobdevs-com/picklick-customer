import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

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
            if (!snapshot.hasData)
              return Loading();
            else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Orders Yet'),
              );
            }
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
                      trailing: Icon(Icons.arrow_right),
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
