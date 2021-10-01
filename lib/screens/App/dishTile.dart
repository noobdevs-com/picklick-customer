import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/controllers/hotel.dart';
import 'package:picklick_customer/screens/App/dishScreen.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class DishTile extends StatefulWidget {
  DishTile({required this.id, required this.tile});
  final String id;
  MenuScreen tile;
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
      _controller.getOfferDishes(widget.id);
    });
  }

  Widget menuScreen() {
    return Obx(() => _controller.loading.value == true
        ? Loading()
        : ListView.builder(
            itemCount: _controller.dishes.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: ListTile(
                  title: Text(
                    _controller.dishes[index].name,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text('₹ ${_controller.dishes[index].price}'),
                  leading: CircleAvatar(
                    radius: 29,
                    backgroundImage:
                        NetworkImage(_controller.dishes[index].img),
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

  Widget offerMenuScreen() {
    return Obx(() => _controller.loading.value == true
        ? Loading()
        : _controller.offerDishes.length == 0
            ? Center(child: Text('No Active Offers'))
            : ListView.builder(
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
                            style: TextStyle(
                                color: Colors.red[300],
                                decoration: TextDecoration.lineThrough),
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
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFCFB840)),
                        onPressed: () {
                          if (_cartController.offerCart
                              .contains(_controller.offerDishes[index])) {
                            return Get.snackbar("Item already in cart",
                                "The item you have choosen is already in cart.");
                          }
                          _cartController.addOfferDishtoCart(
                              _controller.offerDishes[index]);
                        },
                        child: Icon(
                          Icons.add_shopping_cart_rounded,
                        ),
                      ),
                    ),
                  );
                }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.tile == MenuScreen.MENU_SCREEN
          ? menuScreen()
          : offerMenuScreen(),
    );
  }
}
