import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/models/shop.dart';
import 'package:picklick_customer/screens/App/dishScreen.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class ShopTile extends StatelessWidget {
  final List<Shop> shop = [];
  Future<bool> getData() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("hotels").get();
    data.docs.forEach((element) {
      shop.add(Shop.toJson(element));
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (_, snaphot) {
          if (snaphot.hasData)
            return ListView.builder(
                itemCount: shop.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Card(
                      color: Colors.grey[200],
                      child: ListTile(
                        title: Text(
                          shop[index].name,
                          style: TextStyle(
                            fontSize: 23,
                          ),
                        ),
                        subtitle: Text(
                          shop[index].location,
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                        ),
                        leading: Hero(
                          tag: 'logo',
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage('${shop[index].img}'),
                          ),
                        ),
                        trailing: Text('CLOSED'),
                        onTap: () {
                          Get.to(() => DishScreen(
                                id: shop[index].ownerId,
                              ));
                        },
                      ),
                    ),
                  );
                });

          return Loading();
        });
  }
}
