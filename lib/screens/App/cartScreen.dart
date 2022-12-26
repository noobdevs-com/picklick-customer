import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/controllers/cart.dart';
import 'package:picklick_customer/controllers/location.dart';
import 'package:picklick_customer/screens/App/home.dart';
import 'package:picklick_customer/screens/App/paymentMethodScreen.dart';

class CartScreen extends StatefulWidget {
  CartScreen({required this.name, required this.id});
  final String name;
  final String id;
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _cartController = Get.find();
  bool? cartEmpty;

  GeoPoint? restaurantLocation;
  final locationController = Get.put(LocationController());

  getRestaurantLocation() {
    FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.id)
        .get()
        .then((value) {
      final data = value.data()!;
      restaurantLocation = data['geoLocation'];
    }).whenComplete(() {
      locationController.getDistanceBtwUserAndRestaurant(restaurantLocation!);
    });
  }

  bool cartCount() {
    _cartController.cart.length == 0 ? cartEmpty = true : cartEmpty = false;
    setState(() {});
    return cartEmpty!;
  }

  @override
  void initState() {
    super.initState();
    cartCount();
    getRestaurantLocation();
    getDeliveryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('My Cart'),
      ),
      body: cartEmpty!
          ? Center(
              child: SizedBox(
                height: 200,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cart Is Empty',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.shopping_cart)
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Get.offAll(() => Home());
                        },
                        child: Text('Add Items To Cart',
                            style: TextStyle(fontSize: 18, color: Colors.red)))
                  ],
                ),
              ),
            )
          : WillPopScope(
              onWillPop: () async {
                _cartController.cart.map((element) => element.dishQuantity = 1);
                return true;
              },
              child: Obx(() => ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics:
                      ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  shrinkWrap: true,
                  itemCount: _cartController.cart.length,
                  itemBuilder: (context, index) {
                    final cart = _cartController.cart[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Card(
                        elevation: 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  opacity: 0.08,
                                  image: NetworkImage(cart.img),
                                  fit: BoxFit.fill),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1, color: Color(0xFFCFB840)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      cart.name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '₹ ${cart.price * cart.dishquantity}',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            _cartController.removeDish(
                                                _cartController.cart[index],
                                                _cartController.cart[index]
                                                    .quantity.value);
                                          },
                                          icon: Icon(
                                            Icons.remove_shopping_cart,
                                            size: 15,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF0EBCC),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                            width: 2,
                                            color: Color(0xFFF0EBCC))),
                                    height: 28,
                                    width: 100,
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
                                                _cartController
                                                    .removeDishfromCart(
                                                        _cartController
                                                            .cart[index]);
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
                                              child: Text(_cartController
                                                  .cart[index].quantity.value
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
                                                    _cartController
                                                        .cart[index]);
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
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
            ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 8,
            ),
            Obx(() => Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.red),
                  height: 45,
                  child: Center(
                    child: Text(
                      '  TOTAL :  ₹ ${_cartController.price.value}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                ))),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: !cartEmpty!
                      ? () {
                          Get.bottomSheet(BottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12))),
                              onClosing: () {},
                              builder: (context) {
                                return getBill();
                              }));
                        }
                      : null,
                  child: Text('Proceed'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFCFB840),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  double? tax;
  double? delivery;

  getDeliveryData() {
    FirebaseFirestore.instance
        .collection('deliveryPrice')
        .doc('KSt77AQBXlihRKSrJj7n')
        .get()
        .then((value) {
      final data = value.data()!;
      tax = data['taxPercent'];
      delivery = data['deliveryPercent'];
    });
    print(delivery);
    print(tax);
  }

  double taxPrice() {
    return (_cartController.price.value * tax!).ceilToDouble();
  }

  double deliveryCharge() {
    final disKM = locationController.distance! / 1000;
    final price = disKM * delivery!;
    return price.ceilToDouble();
  }

  Widget getBill() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text('Total Price  '),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text('GST & Tax  '),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text('Delivery Charge  '),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text(
                              'Grand Total  ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(':'),
                        Text(':'),
                        Text(':'),
                        SizedBox(
                          height: 8,
                        ),
                        Text(':')
                      ],
                    )),
                Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹ ${_cartController.price.value}'),
                        Text('₹ ${taxPrice()}'),
                        Text('₹ ${deliveryCharge()}'),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                            '₹ ${_cartController.price.value + taxPrice() + deliveryCharge()}')
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: !cartEmpty!
                  ? () {
                      Get.to(
                        () => PaymentMethodScreen(
                          restaurantId: widget.id,
                          restaurantName: widget.name,
                        ),
                      );
                    }
                  : null,
              child: Text('Payment Method'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFCFB840),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
