import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/constants/constants.dart';
import 'package:picklick_customer/constants/valueConstants.dart';
import 'package:picklick_customer/screens/App/loading.dart';
import 'package:picklick_customer/services/fcm_notification.dart';
import 'package:lottie/lottie.dart';

class ChristmasTicket extends StatefulWidget {
  const ChristmasTicket({Key? key}) : super(key: key);

  @override
  _ChristmasTicketState createState() => _ChristmasTicketState();
}

class _ChristmasTicketState extends State<ChristmasTicket>
    with TickerProviderStateMixin {
  String ticket = '1 Ticket + Free Size Family Photo';

  late int price;
  late int bprice;
  TextEditingController descriptionController = TextEditingController();
  String? customerName;
  String? customerAddress;
  String? discription;
  String? bdiscription;
  int freeTicket = 0;
  int quaterTicket = 0;
  int halfTicket = 0;
  int fullTicket = 0;
  int bfreeTicket = 0;
  int bquaterTicket = 0;
  int bhalfTicket = 0;
  int bfullTicket = 0;
  int offer = 1;
  String selectedTicket = '1TFR';
  bool visible = true;
  final fCMNotification = FCMNotification();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    getFirebaseUserData();
    getFirebaseTicketData();
    getAdminToken();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getFirebaseUserData() {
    FirebaseFirestore.instance
        .collection('userAddressBook')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var data = value.docs[0].data();
      setState(() {
        customerName = data['name'];
        customerAddress = data['address'];
      });
    });
  }

  Future<void> getFirebaseTicketData() async {
    await FirebaseFirestore.instance
        .collection('christmasTicket')
        .doc('fxwaEludGcRMmdLcMA0D')
        .get()
        .then((value) {
      var data = value.data()!;
      setState(() {
        freeTicket = data['tfreeSize'];
        quaterTicket = data['tquaterSize'];
        halfTicket = data['thalfSize'];
        fullTicket = data['tfullSize'];
        discription = data['discription'];
        bdiscription = data['bdiscription'];
        bfreeTicket = data['bfreeSize'];
        bquaterTicket = data['bquaterSize'];
        bhalfTicket = data['bhalfSize'];
        bfullTicket = data['bfullSize'];
        visible = data['visible'];
      });
    });
  }

  getPrice() {
    setState(() {
      selectedTicket == '1TFR'
          ? price = freeTicket
          : selectedTicket == '1TQ'
              ? price = quaterTicket
              : selectedTicket == '1TH'
                  ? price = halfTicket
                  : selectedTicket == '1TFU'
                      ? price = fullTicket
                      : price = 0;
    });
    setState(() {
      selectedTicket == '1TFR'
          ? ticket = '1 Ticket + Free Size Family Photo'
          : selectedTicket == '1TQ'
              ? ticket = '1 Ticket + Quater Size Family Photo'
              : selectedTicket == '1TH'
                  ? ticket = '1 Ticket + Half Size Family Photo'
                  : selectedTicket == '1TFU'
                      ? ticket = '1 Ticket + Full Size Family Photo'
                      : selectedTicket == '1BTFR'
                          ? ticket =
                              '1 Bussiness Ticket + Free Size Family Photo'
                          : selectedTicket == '1BTQ'
                              ? ticket =
                                  '1 Bussiness Ticket + Free Size Family Photo'
                              : selectedTicket == '1BTH'
                                  ? ticket =
                                      '1 Bussiness Ticket + Free Size Family Photo'
                                  : selectedTicket == '1BTFU'
                                      ? ticket =
                                          '1 Bussiness Ticket + Free Size Family Photo'
                                      : ticket = '';
    });

    setState(() {
      selectedTicket == '1BTFR'
          ? bprice = bfreeTicket
          : selectedTicket == '1BTQ'
              ? bprice = bquaterTicket
              : selectedTicket == '1BTH'
                  ? bprice = bhalfTicket
                  : selectedTicket == '1BTFU'
                      ? bprice = bfullTicket
                      : bprice = 0;
    });
  }

  List<String> adminToken = [];

  Future<void> getAdminToken() async {
    await FirebaseFirestore.instance
        .collection('adminBook')
        .get()
        .then((value) {
      final data = value.docs.map<String>((e) => e['notificationToken']);
      adminToken = data.toList();

      print(adminToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    getPrice();
    return RefreshIndicator(
      onRefresh: getFirebaseTicketData,
      child: Scaffold(
        body: !visible == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text(
                        'Sorry For the inconvience, We are currently not accepting orders',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('ticketOrder')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (_, AsyncSnapshot<QuerySnapshot> sp) {
                  if (!sp.hasData) return Loading();
                  final data = sp.data!.docs;
                  if (data.isNotEmpty) {
                    return Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(
                          'Only One Order Allowed Per User, For More Orders Please Contact us.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              'assets/ticket.jpg',
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Family Tickets',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTicket = '1TFR';
                                        });
                                      },
                                      child: Card(
                                          shadowColor: Color(0xFFCFB840),
                                          elevation:
                                              selectedTicket == '1TFR' ? 10 : 0,
                                          shape: KbbcardShape,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                selectedTicket == '1TFR'
                                                    ? Color(0xFFCFB840)
                                                    : Colors.white,
                                            radius: 25,
                                            child: Text(
                                              'FR',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    selectedTicket == '1TFR'
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      '1 Ticket',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('+', style: TextStyle(fontSize: 10)),
                                    Text('Free Size Photo',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTicket = '1TQ';
                                        });
                                      },
                                      child: Card(
                                        shadowColor: Color(0xFFCFB840),
                                        elevation:
                                            selectedTicket == '1TQ' ? 10 : 0,
                                        shape: KbbcardShape,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              selectedTicket == '1TQ'
                                                  ? Color(0xFFCFB840)
                                                  : Colors.white,
                                          radius: 25,
                                          child: Text(
                                            'Q',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    selectedTicket == '1TQ'
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      '1 Ticket',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('+', style: TextStyle(fontSize: 10)),
                                    Text('Quater Size Photo',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTicket = '1TH';
                                        });
                                      },
                                      child: Card(
                                          shadowColor: Color(0xFFCFB840),
                                          elevation:
                                              selectedTicket == '1TH' ? 10 : 0,
                                          shape: KbbcardShape,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                selectedTicket == '1TH'
                                                    ? Color(0xFFCFB840)
                                                    : Colors.white,
                                            radius: 25,
                                            child: Text(
                                              'H',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    selectedTicket == '1TH'
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      '1 Ticket',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('+', style: TextStyle(fontSize: 10)),
                                    Text('Half Size Photo',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTicket = '1TFU';
                                        });
                                      },
                                      child: Card(
                                          shadowColor: Color(0xFFCFB840),
                                          elevation:
                                              selectedTicket == '1TFU' ? 10 : 0,
                                          shape: KbbcardShape,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                selectedTicket == '1TFU'
                                                    ? Color(0xFFCFB840)
                                                    : Colors.white,
                                            radius: 25,
                                            child: Text(
                                              'L',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    selectedTicket == '1TFU'
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      '1 Ticket',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('+', style: TextStyle(fontSize: 10)),
                                    Text('Full Size Photo',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Card(
                              color: Colors.white70,
                              elevation: 0,
                              child: ListTile(
                                title: Text(
                                  'Price :  ₹ $price',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            discription != ''
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 8, 0),
                                    child: Text('* $discription',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 12),
                                        textAlign: TextAlign.justify),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width - 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: ticket,
                                    middleText: descriptionController.text,
                                    onConfirm: () async {
                                      Navigator.of(context).pop();
                                      final user =
                                          FirebaseAuth.instance.currentUser!;
                                      await FirebaseFirestore.instance
                                          .collection('ticketOrder')
                                          .doc(user.uid)
                                          .set({
                                        'uid': user.uid,
                                        'bucket': ticket,
                                        'price': (price),
                                        'discription':
                                            descriptionController.text,
                                        'orderedAt':
                                            Timestamp.fromDate(DateTime.now()),
                                        'orderStatus':
                                            OrderStatus.pending.toString(),
                                        'customerName': customerName,
                                        'customerAddress': customerAddress,
                                        'customerPhoneNumber': user.phoneNumber,
                                      }, SetOptions(merge: true)).whenComplete(
                                              () {
                                        Get.bottomSheet(
                                          Lottie.asset(
                                              'assets/confirmAnimation.json',
                                              fit: BoxFit.fill,
                                              controller: _controller,
                                              onLoaded: (comp) {
                                            _controller.duration =
                                                comp.duration;
                                            _controller
                                                .forward()
                                                .whenComplete(() {
                                              _controller.reverse();
                                              Navigator.of(context).pop();
                                            });
                                          }),
                                        );
                                        adminToken.forEach((e) => fCMNotification
                                            .createOrderNotification(
                                                e,
                                                'New Ticket Booked',
                                                '$customerName has booked a family Ticket'));
                                      });
                                    },
                                    textConfirm: 'Confirm Order',
                                  );
                                },
                                child: Text('Book Family Ticket'),
                                style: kElevatedButtonStyle,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Bussiness Tickets',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTicket = '1BTFR';
                                        });
                                      },
                                      child: Card(
                                          shadowColor: Color(0xFFCFB840),
                                          elevation: selectedTicket == '1BTFR'
                                              ? 10
                                              : 0,
                                          shape: KbbcardShape,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                selectedTicket == '1BTFR'
                                                    ? Color(0xFFCFB840)
                                                    : Colors.white,
                                            radius: 30,
                                            child: Text(
                                              'BFR',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    selectedTicket == '1BTFR'
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      '1 Ticket',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('+', style: TextStyle(fontSize: 10)),
                                    Text('Free Size Photo',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTicket = '1BTQ';
                                        });
                                      },
                                      child: Card(
                                        shadowColor: Color(0xFFCFB840),
                                        elevation:
                                            selectedTicket == '1BTQ' ? 10 : 0,
                                        shape: KbbcardShape,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              selectedTicket == '1BTQ'
                                                  ? Color(0xFFCFB840)
                                                  : Colors.white,
                                          radius: 30,
                                          child: Text(
                                            'BQ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    selectedTicket == '1BTQ'
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      '1 Ticket',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('+', style: TextStyle(fontSize: 10)),
                                    Text('Quater Size Photo',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTicket = '1BTH';
                                        });
                                      },
                                      child: Card(
                                          shadowColor: Color(0xFFCFB840),
                                          elevation:
                                              selectedTicket == '1BTH' ? 10 : 0,
                                          shape: KbbcardShape,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                selectedTicket == '1BTH'
                                                    ? Color(0xFFCFB840)
                                                    : Colors.white,
                                            radius: 30,
                                            child: Text(
                                              'BH',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    selectedTicket == '1BTH'
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      '1 Ticket',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('+', style: TextStyle(fontSize: 10)),
                                    Text('Half Size Photo',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTicket = '1BTFU';
                                        });
                                      },
                                      child: Card(
                                          shadowColor: Color(0xFFCFB840),
                                          elevation: selectedTicket == '1BTFU'
                                              ? 10
                                              : 0,
                                          shape: KbbcardShape,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                selectedTicket == '1BTFU'
                                                    ? Color(0xFFCFB840)
                                                    : Colors.white,
                                            radius: 30,
                                            child: Text(
                                              'BFL',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    selectedTicket == '1BTFU'
                                        ? SizedBox(
                                            height: 8,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      '1 Ticket',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text('+', style: TextStyle(fontSize: 10)),
                                    Text('Full Size Photo',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Card(
                              color: Colors.white70,
                              elevation: 0,
                              child: ListTile(
                                title: Text(
                                  'Price :  ₹ $bprice',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            discription != ''
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 8, 0),
                                    child: Text('* $bdiscription',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 12),
                                        textAlign: TextAlign.justify),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width - 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: ticket,
                                    middleText: descriptionController.text,
                                    onConfirm: () async {
                                      Navigator.of(context).pop();
                                      final user =
                                          FirebaseAuth.instance.currentUser!;
                                      await FirebaseFirestore.instance
                                          .collection('ticketOrder')
                                          .doc(user.uid)
                                          .set({
                                        'uid': user.uid,
                                        'ticket': ticket,
                                        'price': (price),
                                        'discription':
                                            descriptionController.text,
                                        'orderedAt':
                                            Timestamp.fromDate(DateTime.now()),
                                        'orderStatus':
                                            OrderStatus.pending.toString(),
                                        'customerName': customerName,
                                        'customerAddress': customerAddress,
                                        'customerPhoneNumber': user.phoneNumber,
                                      }, SetOptions(merge: true)).whenComplete(
                                              () {
                                        Get.bottomSheet(
                                          Lottie.asset(
                                              'assets/confirmAnimation.json',
                                              fit: BoxFit.fill,
                                              controller: _controller,
                                              onLoaded: (comp) {
                                            _controller.duration =
                                                comp.duration;
                                            _controller
                                                .forward()
                                                .whenComplete(() {
                                              _controller.reverse();
                                              Navigator.of(context).pop();
                                            });
                                          }),
                                        );
                                        adminToken.forEach((e) => fCMNotification
                                            .createOrderNotification(
                                                e,
                                                'New Ticket Booked',
                                                '$customerName has booked a family Ticket'));
                                      });
                                    },
                                    textConfirm: 'Confirm Order',
                                  );
                                },
                                child: Text('Book Bussiness Ticket'),
                                style: kElevatedButtonStyle,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
