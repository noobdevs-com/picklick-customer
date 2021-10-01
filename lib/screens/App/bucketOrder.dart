import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'loading.dart';

class BucketOrder extends StatefulWidget {
  const BucketOrder({Key? key}) : super(key: key);

  @override
  _BucketOrderState createState() => _BucketOrderState();
}

class _BucketOrderState extends State<BucketOrder> {
  final ref = FirebaseFirestore.instance
      .collection('bucketOrder')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Bucket Orders'),
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Loading();
            final data = snapshot.data!.docs;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Card(
                        child: ListTile(
                          // tileColor: data[index]['orderStatus'] ==
                          //         OrderStatus.rejected.toString()
                          //     ? Colors.red
                          //     : Colors.green,

                          // leading: CircleAvatar(
                          //   backgroundColor: Color(0xFFCFB840),
                          //   child: Text(
                          //     data[index]['quantity'].toString(),
                          //     style: TextStyle(color: Colors.black),
                          //   ),
                          // ),
                          title: Text('${data[index]['bucket'].toString()}'),
                          trailing:
                              Text('₹ ${data[index]['price'].toString()}'),
                          subtitle: Text(DateFormat.yMEd()
                              .add_jms()
                              .format(DateTime.parse(
                                  data[index]['orderedAt'].toDate().toString()))
                              .toString()),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Buckets Will Be Delivered On The Upcoming Sunday Between 11 AM - 2 PM',
                          textAlign: TextAlign.justify,
                        ),
                        subtitle:
                            Text('For Enquiries and Clarifications Contact Us'),
                      )
                    ],
                  );
                });
          }),
    );
  }
}
