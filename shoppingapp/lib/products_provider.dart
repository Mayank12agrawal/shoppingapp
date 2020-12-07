import 'dart:convert';
import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
class Products with ChangeNotifier
{
  List<Product> _items=[];

  List<Product> get items{
    return [..._items];
  }
  List<Product> get showfavonly{
    return _items.where((proditem) => proditem.isfav).toList();
  }
  Product findbyid(String id)
  {
    return _items.firstWhere((prod) => prod.id==id);
  }
  final String token;
  final String userid;
  Products(this.token,this.userid,this._items);
  Future<void> fetchproducts([bool filterbyuser=false]) async{
    final filterstring=filterbyuser?'orderBy="creatorid"&equalTo="$userid"':'';
    var url='https://flutterdata-98a08.firebaseio.com/products.json?auth=$token&$filterstring';
    try{
      final response=await http.get(url);
      final extractedproduct=json.decode(response.body)as Map<String,dynamic>;
      if(extractedproduct==null)
        {
          return;
        }
       url='https://flutterdata-98a08.firebaseio.com/userfav/$userid.json?auth=$token';
      final responsedata=await http.get(url);
      final favdata=json.decode(responsedata.body);
      final List<Product>loadedproducts=[];
      extractedproduct.forEach((prodid, proddata) {
             loadedproducts.add(Product(
               id: prodid,
               title: proddata['title'],
               description: proddata['description'],
               price: proddata['price'],
               isfav: favdata==null? false :favdata[prodid]??false,
               imageUrl: proddata['imageurl'],

             ));
      });
      _items=loadedproducts;
      notifyListeners();
    }catch(error)
    {
      throw (error);
    }
  }
  Future<void> addproduct(Product product) async
  {
    final url='https://flutterdata-98a08.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http
          .post(url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageurl': product.imageUrl,
          'creatorid':userid,

        }),);
      final newproduct=Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newproduct);
      // _items.add(value);
      notifyListeners();
    }
    catch(error){
      throw error;
    }



  }
  Future<void> updateproduct(String id,Product newproduct) async
  {
    final prodindex=_items.indexWhere((prod) => prod.id==id);
    if(prodindex>=0)
      {
        final url='https://flutterdata-98a08.firebaseio.com/products/$id.json?auth=$token';
        await http.patch(url,body:
        json.encode({
          'title':newproduct.title,
          'description':newproduct.description,
          'imageurl':newproduct.imageUrl,
          'price':newproduct.price,
        }));
        _items[prodindex]=newproduct;
        notifyListeners();
      }
    else
      {
        print('..');
      }

  }
  Future<void> deleteproduct(String id) async
  {
    final url='https://flutterdata-98a08.firebaseio.com/products/$id.json?auth=$token';
   await http.delete(url);
    _items.removeWhere((prod) => prod.id==id);
    notifyListeners();
  }
}