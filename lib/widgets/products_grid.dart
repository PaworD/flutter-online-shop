import 'package:flutter/material.dart';
import './product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {

final bool showFavs;
final String filterStr;
ProductsGrid(this.showFavs, this.filterStr);


  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favourite : productsData.items;
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: filterStr == null ? new Card(child:Container(
              width: 250,
              height: 150,
              child: ProductItem()
            )) : products[i].title.toLowerCase().contains(filterStr.toLowerCase()) ? new Card(child:Container(
              width: 250,
              height: 150,
              child: ProductItem()
            )) : new Container()
            
          ), 
      ),
    );
  }
}