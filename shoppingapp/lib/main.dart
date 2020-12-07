import 'package:flutter/material.dart';
import 'package:shoppingapp/cartscreen.dart';
import './productoverviewscreen.dart';
import './productdetail.dart';
import './products_provider.dart';
import 'package:provider/provider.dart';
import './Cart.dart';
import './cartscreen.dart';
import './order.dart';
import './Orderscreen.dart';
import './userproductsitem.dart';
import './editproductscreen.dart';
import './auth_screen.dart';
import './auth.dart';
import './splashscreen.dart';
void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx)=>Auth(),
        ),
        ChangeNotifierProxyProvider<Auth,Products>(
        update: (ctx,auth,prevouisproduct)=>Products(auth.token,
            auth.userid,
            prevouisproduct==null?[]:prevouisproduct.items),
    ),
        ChangeNotifierProvider(
          create: (ctx)=>Cart(),
        ),
        ChangeNotifierProxyProvider<Auth,Order>(
          update: (ctx,auth,prevouisorder)=>Order(auth.token,prevouisorder==null?[]:prevouisorder.orders,auth.userid),
        ),],

      child:Consumer<Auth>(builder: (ctx,auth,_)=>MaterialApp(
          title: 'Myshop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor:  Colors.deepOrange,
          ),
          home:auth.isAuth?
          ProductOverviewScreen()
              :FutureBuilder(
            future: auth.autologin(),
            builder: (ctx,autoresultsnapshot)=>
              autoresultsnapshot.connectionState==ConnectionState.waiting?SplashScreen ():AuthScreen(),) ,
          routes: {
            Productdetail.routeName:(ctx)=>Productdetail(),
            CartScreen.routeName:(ctx)=>CartScreen(),
            Orderscreen.routename:(ctx)=>Orderscreen(),
            Userproductitem.routeName:(ctx)=>Userproductitem(),
            Editproduct .routeName:(ctx)=>Editproduct (),
          }
      ),)
    );
  }
}
