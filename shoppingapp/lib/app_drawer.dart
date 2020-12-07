import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './userproductsitem.dart';
import './Orderscreen.dart';
import './auth.dart';
class Appdrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('hello freind'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            title: Text('Shop'),
            leading: Icon(Icons.shop),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.payment),
            onTap: (){
              Navigator.of(context).pushNamed(Orderscreen.routename);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Manage Products'),
            leading: Icon(Icons.edit),
            onTap: (){
              Navigator.of(context).pushNamed(Userproductitem.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.exit_to_app),
            onTap: (){
              Navigator.of(context).pushNamed('/');
              Navigator.of(context).pop();
              //Navigator.of(context).pushNamed(Userproductitem.routeName);
              Provider.of<Auth>(context,listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
