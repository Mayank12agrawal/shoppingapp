import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './products_provider.dart';
class Productdetail extends StatelessWidget {
  static const routeName='/productdetail';
  @override
  Widget build(BuildContext context) {
    final productid=ModalRoute.of(context).settings.arguments as String;
   final loadedproduct= Provider.of<Products>(context,
   listen: false
   ).findbyid(productid);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedproduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children:<Widget>[ Container(
            height: 300,
            width: double.infinity,
            child: Hero(
              tag: loadedproduct.id,
              child: Image.network(loadedproduct.imageUrl,
              fit: BoxFit.cover,),
            ),
          ),
            SizedBox(height: 10,),
            Text('\$${loadedproduct.price}',
            style: TextStyle(
              color:Colors.grey,
              fontSize: 20,
            ),),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(loadedproduct.description,
              softWrap: true,
              textAlign: TextAlign.center,),
            )
        ]),
      ),
    );
  }
}
