import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/controllers/hotel.dart';

class OfferDishTile extends StatefulWidget {
  OfferDishTile({required this.id});
  final String id;
  @override
  _OfferDishTileState createState() => _OfferDishTileState();
}

class _OfferDishTileState extends State<OfferDishTile> {
  final HotelController _controller = Get.find();
  final CartController _cartController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.getOfferDishes(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
        itemCount: _controller.offerDishes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: ListTile(
              title: Text(
                _controller.offerDishes[index].name,
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Row(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '₹ ${_controller.offerDishes[index].originalPrice}   ',
                    style: TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                  Text(
                      '    ₹ ${_controller.offerDishes[index].discountedPrice}')
                ],
              ),
              leading: CircleAvatar(
                radius: 29,
                backgroundImage:
                    NetworkImage(_controller.offerDishes[index].img),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFFCFB840)),
                onPressed: () {
                  if (_cartController.offerCart
                      .contains(_controller.offerDishes[index])) {
                    return Get.snackbar("Item already in cart",
                        "The item you have choosen is already in cart.");
                  }
                  _cartController
                      .addOfferDishtoCart(_controller.offerDishes[index]);
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
