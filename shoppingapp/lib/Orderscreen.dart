import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './order.dart' show Order;
import './orderitem.dart';
import './app_drawer.dart';
class Orderscreen extends StatefulWidget {
  static const routename='/orderscreen';

  @override
  _OrderscreenState createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  var isloading=false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) async{
      setState(() {
        isloading=true;
      });
      await Provider.of<Order>(context,listen: false).fetchproduct();
      setState(() {
        isloading=false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ordersdata=Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: Appdrawer(),
      body: isloading?Center(
        child: CircularProgressIndicator(),
      ):ListView.builder(
        itemCount: ordersdata.orders.length,
        itemBuilder: (ctx,i)=>Orderitem(ordersdata.orders[i]),
      ),
    );
  }
}
