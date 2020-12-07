import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './product.dart';
import './products_provider.dart';
import './productitem.dart';
class productgrid extends StatelessWidget {
  final bool showfav;
  productgrid(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Products>(context);
    final products = showfav ? productsdata.showfavonly : productsdata.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) =>
          ChangeNotifierProvider.value(
            value: products[i],
            child: Productitem(
              //products[i].id,
              //products[i].title,
              //products[i].imageUrl,
            ),
          ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),

    );
  }
}