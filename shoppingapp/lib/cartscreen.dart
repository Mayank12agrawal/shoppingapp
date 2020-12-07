import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Cart.dart' ;
import './cartitem.dart';
import './order.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartscreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalamount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  orderbutton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
          child:ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => Caritem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].price,

              ),
            ),

          )],
      ),
    );
  }
}

class orderbutton extends StatefulWidget {
  const orderbutton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _orderbuttonState createState() => _orderbuttonState();
}

class _orderbuttonState extends State<orderbutton> {
  var isloading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isloading?CircularProgressIndicator():Text('ORDER NOW'),
      onPressed: (widget.cart.totalamount<=0 || isloading)?null:()async {
        setState(() {
          isloading=true;
        });
       await Provider.of<Order>(context,listen: false).addorder(widget.cart.items.values.toList(), widget.cart.totalamount);
        setState(() {
          isloading=false;
        });
        widget.cart.clear();

      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
