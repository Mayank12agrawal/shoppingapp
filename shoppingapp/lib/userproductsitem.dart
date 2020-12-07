import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './editproductscreen.dart';
import './products_provider.dart';
import './userproduct.dart';
import './app_drawer.dart';
class Userproductitem extends StatelessWidget {

  static const routeName='/userproductsitem';
  Future<void> refreshproducts(BuildContext context)async{
    await Provider.of<Products>(context,listen: false).fetchproducts(true);
  }

  @override
  Widget build(BuildContext context) {
   // final productsdata=Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              //...
              Navigator.of(context).pushNamed(Editproduct.routeName);
            },
          )
        ],
      ),
      drawer:Appdrawer(),
      body: FutureBuilder(
        future: refreshproducts(context),
        builder:(ctx,snapshot)=>snapshot.connectionState==ConnectionState.waiting?Center(
          child: CircularProgressIndicator(),
        ): RefreshIndicator(
          onRefresh: ()=>refreshproducts(context),
          child: Consumer<Products>(
            builder:(ctx,productsdata,_)=> Padding(
                padding: EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: productsdata.items.length,
                  itemBuilder: (_,i)=>Column(
                    children:[Userproduct(
                      productsdata.items[i].id,
                    productsdata.items[i].title,
                    productsdata.items[i].imageUrl,
                  ),
                 Divider(),
    ],
                ),
              ),
    ),
          ),
        ),
      ),
      );
  }
}
