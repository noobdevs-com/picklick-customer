import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/controllers/hotel.dart';

import 'package:picklick_customer/screens/App/loading.dart';

class DishTile extends StatefulWidget {
  DishTile({required this.id});
  final String id;

  @override
  _DishTileState createState() => _DishTileState();
}

class _DishTileState extends State<DishTile> {
  final HotelController _controller = Get.put(HotelController());
  final CartController _cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.getDishes(widget.id);
    });
  }

  Widget menuScreen() {
    return Obx(() => _controller.loading.value == true
        ? Loading()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView.builder(
                itemCount: _controller.dishes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.5,
                    margin: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: ListTile(
                      title: Text(
                        _controller.dishes[index].name,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text('₹ ${_controller.dishes[index].price}'),
                      leading: SizedBox(
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: FadeInImage(
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              placeholder: AssetImage('assets/mainLogo.png'),
                              image: NetworkImage(
                                _controller.dishes[index].img,
                              )),
                        ),
                      ),
                      trailing: Obx(
                        () => _cartController.cart
                                .contains(_controller.dishes[index])
                            ? Column(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Added',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  )),
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 4)),
                                        onPressed: () {
                                          _cartController.removeDishfromCart(
                                              _controller.dishes[index],
                                              _controller
                                                  .dishes[index].quantity);
                                        },
                                        child: Icon(Icons.remove_circle)),
                                  )
                                ],
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFCFB840)),
                                onPressed: () {
                                  _cartController.addDishtoCart(
                                      _controller.dishes[index],
                                      _controller.dishes[index].quantity);
                                },
                                child: Icon(
                                  Icons.add_shopping_cart_rounded,
                                ),
                              ),
                      ),
                    ),
                  );
                }),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: menuScreen());
  }
}
