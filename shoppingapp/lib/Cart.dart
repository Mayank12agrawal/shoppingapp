
import 'package:flutter/foundation.dart';

class Cartitem
{
  final String id;
  final String title;
  final int quantity;
  final double price;
  Cartitem(
  {
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
});
}
class Cart with ChangeNotifier
{
  Map<String,Cartitem> _items={};
  Map<String,Cartitem> get items
  {
    return {..._items};
  }
  int get itemcount
  {
    return _items.length;
  }
  double get totalamount
  {
    var totalamount=0.0;
    _items.forEach((key, cartitem) {
      totalamount+=cartitem.price*cartitem.quantity;
    });
    return totalamount;

  }
  void additem(String productid,String title,double price,)
  {
    if(_items.containsKey(productid))
      {
        //cahnge the quantity
        _items.update(productid, (existingCartItem) =>
        Cartitem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity+1,
        ));
      }
    else{
      _items.putIfAbsent(productid,()=>Cartitem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,));
    }
    notifyListeners();
  }
  void removeitem(String Productid)
  {
    _items.remove(Productid);
    notifyListeners();
  }
  void removesingleitem(String Productid)
  {
    if(!_items.containsKey(Productid))
      {
        return;
      }
    if(_items[Productid].quantity>1)
      {
        _items.update(Productid, (existingcartitem) => Cartitem(
          id: existingcartitem.id,
          title: existingcartitem.title,
          price: existingcartitem.price,
          quantity: existingcartitem.quantity-1,

        ));
      }
    else
      {
        _items.remove(Productid);
      }
    notifyListeners();
  }
  void clear() {
    _items = {};
    notifyListeners();
  }

}