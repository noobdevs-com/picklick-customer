import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFCFB840)),
            child: Text('Melwin'),
          ),
          ListTile(
            title: Text('My Account'),
            trailing: Icon(Icons.person),
            onTap: () {},
          ),
          ListTile(
            title: Text('Veiw Partners'),
            trailing: Icon(Icons.group),
            onTap: () {},
          ),
          ListTile(
            title: Text('About'),
            trailing: Icon(Icons.people),
            onTap: () {},
          ),
          ListTile(
            title: Text('Log Out'),
            trailing: Icon(Icons.logout),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
