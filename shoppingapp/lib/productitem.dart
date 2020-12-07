import 'package:flutter/material.dart';
import 'package:shoppingapp/productdetail.dart';
import 'package:provider/provider.dart';
import './product.dart';
import './Cart.dart';
import './auth.dart';
class Productitem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product=Provider.of<Product>(context);
    final cart=Provider.of<Cart>(context);
    final authdata=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
    borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(Productdetail.routeName,arguments: product.id);
          },
          child:Hero(
            tag: product.id,
          child:Image.network(product.imageUrl,
        fit: BoxFit.cover,),),),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(product.isfav? Icons.favorite:Icons.favorite_border),
            onPressed: (){
              product.togglefav(authdata.token,authdata.userid);
            },
            color: Theme.of(context).accentColor,
          ),
          title:Text(
              product.title,
          textAlign: TextAlign.center,),
          trailing:  IconButton(
          icon: Icon(Icons.shopping_cart),
          color: Theme.of(context).accentColor,
          onPressed: (){
            cart.additem(product.id, product.title, product.price);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content:Text('Added item to Cart') ,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: (){
                   cart.removesingleitem(product.id);
              },
            ),),);
          },

        ),
      ),
    ));
  }
}
