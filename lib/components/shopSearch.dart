import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:picklick_customer/models/shop.dart';

class CustomShopSearch extends SearchDelegate {
  List<Shop> searchQuery = [];
  List<Shop> matchResultQuery = [];
  List<Shop> matchSuggestionQuery = [];

  Future<void> getDishes(String value) async {
    if (query.isEmpty) {
      searchQuery.clear();
      matchResultQuery.clear();
      matchSuggestionQuery.clear();
    }
    print(searchQuery);
    FirebaseFirestore.instance
        .collection('hotels')
        .where('name', isGreaterThanOrEqualTo: value)
        .orderBy('name')
        .where('name', isLessThan: value + 'z')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        searchQuery.add(Shop.toJson(element.data()));
      });
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            searchQuery.clear();
            matchResultQuery.clear();
            matchSuggestionQuery.clear();
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
          searchQuery.clear();
          matchResultQuery.clear();
          matchSuggestionQuery.clear();
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500), () => getDishes(query));

    for (var dish in searchQuery) {
      if (dish.name!.toLowerCase().contains(query.toLowerCase())) {
        matchResultQuery.add(dish);
      }
    }

    return ListView.builder(
        itemCount: matchResultQuery.length,
        itemBuilder: (context, index) {
          var result = matchResultQuery[index];
          return ListTile(
            title: Text(
              result.name!,
              style: TextStyle(
                fontSize: 19,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              result.location!,
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
            leading: SizedBox(
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Hero(
                    tag: result.name!,
                    child: FadeInImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        placeholder: AssetImage('assets/mainLogo.png'),
                        image: NetworkImage(
                          result.img!,
                        ))),
              ),
            ),
            // trailing: !_hotelController.loading.value
            //     ? StreamBuilder(
            //         stream: FirebaseFirestore.instance
            //             .collection('hotels')
            //             .where('ownerId', isEqualTo: re.ownerId)
            //             .snapshots(),
            //         builder: (context, AsyncSnapshot<QuerySnapshot> sp) {
            //           if (!sp.hasData) return CupertinoActivityIndicator();
            //           final data = sp.data!.docs[0];

            //           return CircleAvatar(
            //             radius: 8,
            //             backgroundColor: data['status'] == 'open'
            //                 ? Colors.green
            //                 : Colors.red,
            //           );
            //         },
            //       )
            //     : CircularProgressIndicator(),
            onTap: () {},
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), () {
      getDishes(query);
    });
    matchSuggestionQuery.clear();
    for (var dish in searchQuery) {
      if (dish.name!.toLowerCase().contains(query.toLowerCase())) {
        matchSuggestionQuery.add(dish);
      }
    }
    return ListView.builder(
        itemCount: matchSuggestionQuery.length,
        itemBuilder: (context, index) {
          var result = matchSuggestionQuery[index];
          return ListTile(
            title: Text(
              result.name!,
              style: TextStyle(
                fontSize: 19,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              result.location!,
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
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
                      result.img!,
                    )),
              ),
            ),
            // trailing: !_hotelController.loading.value
            //     ? StreamBuilder(
            //         stream: FirebaseFirestore.instance
            //             .collection('hotels')
            //             .where('ownerId', isEqualTo: re.ownerId)
            //             .snapshots(),
            //         builder: (context, AsyncSnapshot<QuerySnapshot> sp) {
            //           if (!sp.hasData) return CupertinoActivityIndicator();
            //           final data = sp.data!.docs[0];

            //           return CircleAvatar(
            //             radius: 8,
            //             backgroundColor: data['status'] == 'open'
            //                 ? Colors.green
            //                 : Colors.red,
            //           );
            //         },
            //       )
            //     : CircularProgressIndicator(),
            onTap: () {},
          );
        });
  }
}
