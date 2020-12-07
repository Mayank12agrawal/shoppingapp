import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Product with ChangeNotifier
{
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isfav;
  Product({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    this.isfav=false,
    @required this.description});

  Future<void> togglefav(String token,String userid) async
  {
    
    isfav=!isfav;
    notifyListeners();
    final url='https://flutterdata-98a08.firebaseio.com/userfav/$userid/$id.json?auth=$token';
    http.put(url,body:
    json.encode(
      isfav

    ));
    notifyListeners();
  }
}