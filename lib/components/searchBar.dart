import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<void> getHotels(String value) async {
    FirebaseFirestore.instance
        .collection('hotels')
        .where('name', isGreaterThanOrEqualTo: value)
        .where('name', isLessThan: value + 'z')
        .limit(5)
        .get()
        .then((snapshot) {
      print("Result:");
      snapshot.docs.forEach((element) {
        print(element.data());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search_outlined,
                  ),
                ),
                onChanged: (String t) {
                  if (t == "") return;
                  getHotels(t);
                },
                autofocus: true,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              // Search Results
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 32,
                        ),
                        title: Text('Hotel Name'),
                        subtitle: Text('Hotel Address'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
