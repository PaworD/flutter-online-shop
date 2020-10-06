import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/placeholder.png',),
                image: NetworkImage(product.images.first),
                fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  product.toggleFavouriteStatus(
                    authData.token,
                    authData.userId,
                  );
                },
                color: Colors.black),
          ),
          backgroundColor: Color.fromRGBO(33, 140, 116, .5),
          title: Text(product.title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
          trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart, color: Colors.white,),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title, product.images.first);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Item Added to Cart"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.white,
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
