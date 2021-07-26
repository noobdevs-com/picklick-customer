import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/controllers/hotel.dart';

class DishTile extends StatefulWidget {
  DishTile({required this.id});
  final String id;
  @override
  _DishTileState createState() => _DishTileState();
}

class _DishTileState extends State<DishTile> {
  final HotelController _controller = Get.find();
  final CartController _cartController = Get.find();

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
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              title: Text(
                _controller.dishes[index].name,
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text('₹ ${_controller.dishes[index].price}'),
              leading: CircleAvatar(
                radius: 29,
                backgroundImage: NetworkImage(_controller.dishes[index].img),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFFCFB840)),
                onPressed: () {
                  if (_cartController.cart
                      .contains(_controller.dishes[index])) {
                    return Get.snackbar("Item already in cart",
                        "The item you have choosen is already in cart.");
                  }
                  _cartController.addDishtoCart(_controller.dishes[index]);
                },
                child: Icon(
                  Icons.add_shopping_cart_rounded,
                ),
              ),
            ),
          );
        }));
  }
}
