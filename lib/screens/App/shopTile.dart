import 'package:flutter/material.dart';
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
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _hotelController.shops[index].name,
                                  style: TextStyle(
                                    fontSize: 23,
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
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                '${_hotelController.shops[index].img}'),
                          ),
                          trailing:
                              _hotelController.shops[index].status == 'open'
                                  ? Text(
                                      _hotelController.shops[index].status
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.green,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    )
                                  : Text(
                                      _hotelController.shops[index].status
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.red,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                          onTap: () {
                            if (_hotelController.shops[index].status == 'open')
                              Get.to(() => DishScreen(
                                    id: _hotelController.shops[index].ownerId,
                                    name: _hotelController.shops[index].name,
                                  ));
                            else
                              Get.snackbar('Restaurant is Closed',
                                  'The restaurant you are trying to reach is not at service now , try again later');
                          },
                        ),
                      );
                    }),
              ));
  }
}
