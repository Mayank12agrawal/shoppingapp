import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './app_drawer.dart';
import 'package:shoppingapp/cartscreen.dart';
import './product.dart';
import './productitem.dart';
import './products_provider.dart';
import './productsgrid.dart';
import './Badge.dart';
import './Cart.dart';
import './cartscreen.dart';
enum filteroptions
{
  favourite,
  showall,
}
class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showfav=false;
  var isinit=true;
  var isloading=false;
@override
  void initState() {
    // TODO: implement initState

  super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(isinit)
      {
        setState(() {
          isloading=true;
        });

        Provider.of<Products>(context).fetchproducts().then((_) {
          setState(() {
            isloading=false;
          });
        });
      }
    isinit=false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping App'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filteroptions selectedvalue)
            {
              setState(() {
                if(selectedvalue==filteroptions.favourite)
                {
                  showfav=true;
                }
                else
                {
                  showfav=false;
                }
              });

            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_)=>[
              PopupMenuItem(child: Text('only favourites'),value: filteroptions.favourite,),
              PopupMenuItem(child: Text('Show all'),value: filteroptions.showall,),
            ],
          ),
         Consumer<Cart>(builder: (_,cartData,ch)=> Badge(
           child:ch,
           value: cartData.itemcount.toString(),
         ),
         child:IconButton(
    icon: Icon(Icons.shopping_cart),
    onPressed: (){
      Navigator.of(context).pushNamed(
        CartScreen.routeName,
      );
    },
    )),
        ],
      ),
      drawer: Appdrawer(),
      body:isloading?Center(
        child: CircularProgressIndicator(
        ),
      ): productgrid(showfav),
    );
  }
}


