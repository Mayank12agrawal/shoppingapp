import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Cart.dart';
class Caritem extends StatelessWidget {
  final String id;
  final String productid;
  final String title;
  final int quantity;
  final double price;
  Caritem(
      this.id,
      this.productid,
      this.title,
      this.quantity,
      this.price
      );
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,
        color: Colors.white,
        size: 40,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        margin: EdgeInsets.symmetric(
          horizontal : 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context,
        builder: (ctx)=>AlertDialog(
          title: Text('Are you sure?'),
          content: Text('do you want to remove item from cart?'),
          actions: [
            FlatButton(child: Text('No'),onPressed: (){
              Navigator.of(ctx).pop(false);
            },),
            FlatButton(child: Text('Yes'),onPressed: (){
              Navigator.of(ctx).pop(true);
            },),

          ],
        ));
      },
      onDismissed: (direction){
        final removeitem=Provider.of<Cart>(context,listen: false);
        removeitem.removeitem(productid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal : 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(child: FittedBox(child: Text('\$$price'),),),
            title: Text(title),
            subtitle: Text('\$${(price*quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
