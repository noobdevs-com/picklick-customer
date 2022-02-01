import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/models/dish.dart';
import 'package:picklick_customer/screens/App/cartScreen.dart';
import 'package:picklick_customer/screens/App/loading.dart';

class DishTile extends StatefulWidget {
  DishTile({required this.id, required this.name});
  final String id;
  final String name;

  @override
  _DishTileState createState() => _DishTileState();
}

class _DishTileState extends State<DishTile> {
  final CartController _cartController = Get.put(CartController());

  bool? showCart;
  double? _height;

  cartBottomContainer() {
    if (_cartController.getCartItemCount() == 0) {
      _height = 0;
      setState(() {});
    } else {
      _height = 60;
      setState(() {});
    }
  }

  List dishes = <Dish>[];

  bool loading = false;

  Future<void> getDishes(String id) async {
    setState(() {
      loading = true;
    });
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("hotel_dishes")
        .where('ownerId', isEqualTo: id)
        .orderBy('name')
        .get();

    dishes = data.docs.map((e) => Dish.toJson(e)).toList();

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    cartBottomContainer();
    getDishes(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    dishes.clear();
  }

  Widget menuScreen() {
    return loading
        ? Loading()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView.builder(
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.5,
                    margin: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: ListTile(
                      title: Text(
                        dishes[index].name,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text('₹ ${dishes[index].price}'),
                      leading: SizedBox(
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: FadeInImage(
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              placeholder: AssetImage('assets/logoIn.png'),
                              image: NetworkImage(
                                dishes[index].img,
                              )),
                        ),
                      ),
                      trailing: _cartController.cart.contains(dishes[index])
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
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF0EBCC),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      border: Border.all(
                                          width: 2, color: Color(0xFFF0EBCC))),
                                  height: 28,
                                  width: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2,
                                                    horizontal: 4)),
                                            onPressed: () {
                                              _cartController.price.value -=
                                                  _cartController
                                                      .cart[index].price;

                                              _cartController
                                                  .removeDishfromCart(
                                                dishes[index],
                                              );
                                              cartBottomContainer();
                                              setState(() {});
                                            },
                                            child: Center(
                                                child: Icon(
                                              Icons.remove,
                                              size: 15,
                                            ))),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Text(dishes[index]
                                                .dishQuantity
                                                .toString()),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xFFCFB840),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2,
                                                    horizontal: 4)),
                                            onPressed: () {
                                              _cartController.addDishtoCart(
                                                dishes[index],
                                              );
                                              print(dishes[index].dishQuantity);
                                              _cartController.price.value +=
                                                  _cartController
                                                      .cart[index].price;
                                              print(_cartController.cart);
                                              setState(() {});
                                            },
                                            child: Center(
                                                child: Icon(
                                              Icons.add,
                                              size: 15,
                                            ))),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFCFB840)),
                              onPressed: () {
                                _cartController.addDishtoCart(
                                  dishes[index],
                                );

                                cartBottomContainer();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.add_shopping_cart_rounded,
                              ),
                            ),
                    ),
                  );
                }),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: menuScreen(),
        bottomNavigationBar: AnimatedContainer(
          height: _height,
          duration: Duration(milliseconds: 500),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            color: Color(0xFFCFB840),
            child: ListTile(
              title: Obx(() => Text(
                    '${_cartController.getCartItemCount()} Items : ₹ ${_cartController.price}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  )),
              trailing: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(CartScreen(name: widget.name, id: widget.id));
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text('CART')),
            ),
          ),
        ));
  }
}
