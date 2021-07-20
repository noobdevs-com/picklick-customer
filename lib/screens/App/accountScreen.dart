import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SizedBox(
            height: 550,
            width: 400,
            child: Column(
              children: [
                Row(
                  children: [
                    Text('My Account'),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.person)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
