import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './editproductscreen.dart';
import './products_provider.dart';
class Userproduct extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;
  Userproduct(
      @required this.id,
      @required this.title,
      @required this.imageurl,
      );
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                Navigator.of(context).pushNamed(Editproduct.routeName,arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                Provider.of<Products>(context,listen: false).deleteproduct(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
