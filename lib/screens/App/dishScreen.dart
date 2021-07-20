import 'package:flutter/material.dart';
import 'package:picklick_customer/screens/App/dishTile.dart';

class DishScreen extends StatelessWidget {
  DishScreen({required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                Icon(Icons.shopping_cart),
                SizedBox(
                  width: 12,
                ),
                Text('0'),
                SizedBox(
                  width: 40,
                )
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DishTile(
            id: id,
          ),
        ),
      ),
    );
  }
}
