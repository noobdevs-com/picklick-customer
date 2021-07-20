import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/hotel.dart';

class DishTile extends StatefulWidget {
  DishTile({required this.id});
  final String id;
  @override
  _DishTileState createState() => _DishTileState();
}

class _DishTileState extends State<DishTile> {
  final HotelController _controller = Get.put(HotelController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.getDishes(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
        itemCount: _controller.dishes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_controller.dishes[index].name),
              subtitle: Text('₹ ${_controller.dishes[index].price}'),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(_controller.dishes[index].img),
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.add_shopping_cart_rounded),
              ),
            ),
          );
        }));
  }
}
