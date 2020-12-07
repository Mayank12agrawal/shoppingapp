import 'package:flutter/material.dart';
import './order.dart' as oi;
import 'package:intl/intl.dart';
import 'dart:math';
class Orderitem extends StatefulWidget {
  final oi.Orderitem order;
  Orderitem(this.order);

  @override
  _OrderitemState createState() => _OrderitemState();
}

class _OrderitemState extends State<Orderitem> {
  var _expanded=false;
  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.datetime)),
            trailing: IconButton(
              icon: Icon(_expanded?Icons.expand_less:Icons.expand_more),
              onPressed: (){
                setState(() {
                  _expanded=!_expanded;
                });

              },
            ),
          ),
          if(_expanded)
               Container(
                 padding: EdgeInsets.symmetric(
                   horizontal: 15,vertical: 5,
                 ),
                height: min(widget.order.products.length*20.0+ 10, 100),
                 child: ListView(
                   children:
                     widget.order.products.map((prod) => Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                         Text(prod.title,style: TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),),
                         Text('${prod.quantity}x \$${prod.price}',style: TextStyle(
                           fontSize: 18,
                           color: Colors.grey,
                         ),)
                       ],
                     )).toList(),),
              )

        ],
      ),
    );
  }
}
