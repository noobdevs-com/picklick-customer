import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:picklick_customer/components/shopSearch.dart';
import 'package:picklick_customer/controllers/hotel.dart';
import 'package:picklick_customer/screens/App/dishScreen.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class ShopTile extends StatefulWidget {
  @override
  State<ShopTile> createState() => _ShopTileState();
}

class _ShopTileState extends State<ShopTile> {
  final HotelController _hotelController = Get.put(HotelController());

  @override
  Widget build(BuildContext context) {
    GetStorage favStorage = GetStorage();
    return Scaffold(
      body: Obx(() => _hotelController.loading.value
          ? Loading()
          : _hotelController.shops.length == 0
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              // Get.to(() => SearchScreen());
                              showSearch(
                                  context: context,
                                  delegate: CustomShopSearch());
                            },
                            icon: Icon(
                              Icons.search,
                              size: 27,
                              color: Colors.black,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: DropdownButton<String>(
                            dropdownColor: Color(0xFFF0EBCC),
                            elevation: 0,
                            value: _hotelController.filterKey.value,
                            items: <String>['All', 'Closed', 'Open']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _hotelController.filterKey.value =
                                    value ?? 'All';
                              });
                              if (_hotelController.filterKey.value == 'All') {
                                _hotelController.getShops();
                              } else {
                                _hotelController
                                    .filterShops(value!.toLowerCase());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text('No Active Shops'),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: _hotelController.getShops,
                  color: Color(0xFFCFB840),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                // Get.to(() => SearchScreen());
                                showSearch(
                                    context: context,
                                    delegate: CustomShopSearch());
                              },
                              icon: Icon(
                                Icons.search,
                                size: 27,
                                color: Colors.black,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: DropdownButton<String>(
                              dropdownColor: Color(0xFFF0EBCC),
                              elevation: 0,
                              value: _hotelController.filterKey.value,
                              items: <String>['All', 'Closed', 'Open']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _hotelController.filterKey.value =
                                      value ?? 'All';
                                });
                                if (_hotelController.filterKey.value == 'All') {
                                  _hotelController.getShops();
                                } else {
                                  _hotelController
                                      .filterShops(value!.toLowerCase());
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: _hotelController.shops.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shadowColor: Colors.black87,
                              elevation: 2,
                              margin: EdgeInsets.all(2),
                              child: ListTile(
                                onLongPress: () {
                                  final inFav = favStorage.read(
                                      _hotelController.shops[index].ownerId!);

                                  if (inFav == null) {
                                    Get.defaultDialog(
                                        cancelTextColor: Colors.black45,
                                        confirmTextColor: Colors.white,
                                        buttonColor: Color(0xFFCFB840),
                                        title: 'Add to favorites ?',
                                        middleText:
                                            'Do you want to add ${_hotelController.shops[index].name!} to your favourites list ?',
                                        textCancel: 'No',
                                        textConfirm: 'Add',
                                        onConfirm: () {
                                          favStorage.write(
                                              _hotelController
                                                  .shops[index].ownerId!,
                                              _hotelController
                                                  .shops[index].name!);
                                          Navigator.of(context).pop();
                                        });
                                  }
                                  if (inFav != null) {
                                    Get.defaultDialog(
                                        cancelTextColor: Colors.black45,
                                        confirmTextColor: Colors.white,
                                        buttonColor: Colors.red,
                                        title: 'Remove from favorites ?',
                                        middleText:
                                            'Do you want to remove ${_hotelController.shops[index].name!} from your favourites list ?',
                                        textCancel: 'No',
                                        textConfirm: 'Remove',
                                        onConfirm: () {
                                          favStorage.remove(_hotelController
                                              .shops[index].ownerId!);
                                          Navigator.of(context).pop();
                                        });
                                  }
                                },
                                title: Text(
                                  _hotelController.shops[index].name!,
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  _hotelController.shops[index].location!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic),
                                ),
                                leading: SizedBox(
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    child: Hero(
                                        tag: _hotelController.shops[index],
                                        child: FadeInImage(
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                AssetImage('assets/logoIn.png'),
                                            image: NetworkImage(
                                              _hotelController
                                                  .shops[index].img!,
                                            ))),
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
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot> sp) {
                                          if (!sp.hasData)
                                            return Text('loading');
                                          final data = sp.data!.docs[0];

                                          return CircleAvatar(
                                            radius: 8,
                                            backgroundColor:
                                                data['status'] == 'open'
                                                    ? Colors.green
                                                    : Colors.red,
                                          );
                                        },
                                      )
                                    : CircularProgressIndicator(),
                                onTap: () {
                                  if (_hotelController.shops[index].status ==
                                      'open')
                                    Get.to(() => DishScreen(
                                          img: _hotelController
                                              .shops[index].img!,
                                          id: _hotelController
                                              .shops[index].ownerId!,
                                          name: _hotelController
                                              .shops[index].name!,
                                        ));
                                  else
                                    Get.snackbar('Restaurant is Closed',
                                        'The restaurant you are trying to reach is not at service now , try again later');
                                },
                              ),
                            );
                          }),
                    ],
                  ),
                )),
    );
  }
}
