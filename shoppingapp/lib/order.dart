import 'package:flutter/foundation.dart';
import './Cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Orderitem {
  final String id;
  final double amount;

  final List<Cartitem> products;
  final DateTime datetime;

  Orderitem({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.datetime,
  });
}

class Order with ChangeNotifier
{
 List<Orderitem> _orders=[];
 final String userid;
 final String authtoken;
 Order(this.authtoken,this._orders,this.userid);
 List<Orderitem> get orders
 {
   return [..._orders];
 }
 Future<void> fetchproduct() async{
   final url='https://flutterdata-98a08.firebaseio.com/orders/$userid.json?auth=$authtoken';
   final response=await http.get(url);
   final List<Orderitem>loadedorders=[];
   final extractedproducts=json.decode(response.body) as Map<String,dynamic>;
   if(extractedproducts==null)
     {
       return;
     }
   extractedproducts.forEach((orderid, ordervalue) { 
     loadedorders.add(Orderitem(id: orderid, 
         amount: ordervalue['amount'],
         datetime: DateTime.parse(ordervalue['datetime']),
          products: (ordervalue['products']as List<dynamic>).map((item) => Cartitem(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title'],
          )).toList(),
     ),);
   });
   _orders=loadedorders.reversed.toList();
   notifyListeners();
 }
 Future<void> addorder(List<Cartitem> cartproducts,double total) async
 {
   final url='https://flutterdata-98a08.firebaseio.com/orders/$userid.json?auth=$authtoken';
   final timestamp=DateTime.now();
   final response=await http.post(url,body:
   json.encode({
     'amount':total,
     'datetime':timestamp.toIso8601String(),
     'products':cartproducts.map((cp)=>{
       'id':cp.id,
        'title':cp.title,
       'quantity':cp.quantity,
       'price':cp.price,
     }).toList(),

   }));
   _orders.insert(0, Orderitem(
      id: json.decode(response.body)['name'],
      amount: total,
      products: cartproducts,
      datetime:timestamp,

    ));
    notifyListeners();
 }
}