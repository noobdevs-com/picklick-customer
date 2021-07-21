import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/hotel.dart';
import 'package:picklick_customer/screens/App/dishScreen.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class ShopTile extends StatelessWidget {
  final HotelController _hotelController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _hotelController.loading.value
        ? Loading()
        : ListView.builder(
            itemCount: _hotelController.shops.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Card(
                  color: Colors.grey[200],
                  child: ListTile(
                    title: Text(
                      _hotelController.shops[index].name,
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    subtitle: Text(
                      _hotelController.shops[index].location,
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                    leading: Hero(
                      tag: 'logo',
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                            '${_hotelController.shops[index].img}'),
                      ),
                    ),
                    trailing: Text('CLOSED'),
                    onTap: () {
                      Get.to(() => DishScreen(
                            id: _hotelController.shops[index].ownerId,
                          ));
                    },
                  ),
                ),
              );
            }));
  }
}
