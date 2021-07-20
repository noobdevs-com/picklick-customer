import 'package:flutter/material.dart';
import 'package:picklick_customer/models/dish.dart';

List<Dish> dish = [
  Dish(
    title: 'Chicken Biriyani',
    price: '230',
    img: AssetImage('assets/biryani.jpg'),
  ),
  Dish(
    title: 'Chicken Biriyani',
    price: '230',
    img: AssetImage('assets/biryani.jpg'),
  )
];

class DishTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dish.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dish[index].title),
            subtitle: Text(dish[index].price),
            leading: CircleAvatar(
              backgroundImage: dish[index].img,
            ),
            trailing: ElevatedButton(
                onPressed: () {}, child: Icon(Icons.add_shopping_cart_rounded)),
          );
        });
  }
}
