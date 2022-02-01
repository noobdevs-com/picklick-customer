import 'package:flutter/material.dart';

class DishCard extends StatelessWidget {
  Widget child;
  EdgeInsets? margin;
  DishCard({Key? key, required this.child, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: margin,
        child: Container(
          child: child,
          height: 100,
          width: MediaQuery.of(context).size.width - 25,
          decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ));
  }
}
