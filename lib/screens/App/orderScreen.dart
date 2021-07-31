import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:picklick_customer/models/order.dart';
import 'loading.dart';
import 'orderTile.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final day = DateTime.now().day;
    final month = DateTime.now().month;
    final year = DateTime.now().year;
    final ref = FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
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
                        Get.to(() => OrderTile(),
                            arguments: {'id': data[index].id});
                      },
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFCFB840),
                        radius: 29,
                        child: Text(
                          data[index]['quantity'].toString(),
                        ),
                      ),
                      isThreeLine: true,
                      title: Text(
                          'Total Price : ₹ ${data[index]['price'].toString()}'),
                      subtitle: Text(DateFormat.yMEd()
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
