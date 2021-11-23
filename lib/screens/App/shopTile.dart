import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:picklick_customer/controllers/hotel.dart';
import 'package:picklick_customer/screens/App/dishScreen.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class ShopTile extends StatelessWidget {
  final HotelController _hotelController = Get.put(HotelController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => _hotelController.loading.value
        ? Loading()
        : _hotelController.shops.length == 0
            ? Center(
                child: Text('No active Shops'),
              )
            : RefreshIndicator(
                onRefresh: _hotelController.getShops,
                color: Color(0xFFCFB840),
                child: ListView.builder(
                    itemCount: _hotelController.shops.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _hotelController.shops[index].name,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          _hotelController.shops[index].location,
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                        ),
                        leading: Hero(
                          tag: _hotelController.shops[index],
                          child: CircleAvatar(
                            radius: 29,
                            backgroundImage: NetworkImage(
                                '${_hotelController.shops[index].img}'),
                          ),
                        ),
                        trailing: !_hotelController.loading.value
                            ? StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('hotels')
                                    .where('ownerId',
                                        isEqualTo: _hotelController
                                            .shops[index].ownerId)
                                    .snapshots(),
                                builder:
                                    (context, AsyncSnapshot<QuerySnapshot> sp) {
                                  if (!sp.hasData) return Text('loading');
                                  final data = sp.data!.docs[0];
                                  return CircleAvatar(
                                    radius: 8,
                                    backgroundColor: data['status'] == 'open'
                                        ? Colors.green
                                        : Colors.red,
                                  );
                                },
                              )
                            : CircularProgressIndicator(),
                        onTap: () {
                          if (_hotelController.shops[index].status == 'open')
                            Get.to(() => DishScreen(
                                  img: _hotelController.shops[index].img,
                                  id: _hotelController.shops[index].ownerId,
                                  name: _hotelController.shops[index].name,
                                ));
                          else
                            Get.snackbar('Restaurant is Closed',
                                'The restaurant you are trying to reach is not at service now , try again later');
                        },
                      );
                    }),
              ));
  }
}
