import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_2_udemy/widgets/custom_dialog.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

int quantity = 1;


class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final cart = Provider.of<Cart>(context, listen: false);
    final productsData = Provider.of<Products>(context);
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);



    return Scaffold(
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Stack(children: <Widget>[
                SizedBox(
                        height: MediaQuery.of(context).size.height / 2 + 65,
                        width: MediaQuery.of(context).size.width,
                      child: Hero(
                      tag: loadedProduct.id,
                      child: Carousel(
                        images: [for (int i=0; i < loadedProduct.images.length; i++) NetworkImage(loadedProduct.images[i])],
                        autoplay: false,
                        dotSize: 2.0,
                        dotSpacing: 10.0,
                        animationCurve: Curves.bounceInOut,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 55, 25, 15),
                  child: FloatingActionButton(
                      elevation: 0,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      backgroundColor: Color.fromRGBO(33, 140, 116, 1.0),
                      onPressed: () => Navigator.of(context).pop()),
                )
              ]),
              Container(
                padding: EdgeInsets.fromLTRB(25, 10, 25, 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          loadedProduct.title,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          loadedProduct.price.toString(),
                          style: TextStyle(fontSize: 28),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          RatingBar(
                            itemSize: 25,
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              
                            },
                          ),
                        ],
                      ),
                    ),
                                        Padding(
                      padding: EdgeInsets.only(left: 2.0, top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text("Product ID: " + loadedProduct.id, style: TextStyle(fontSize: 12, color: Colors.blueGrey),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                           Chip(
                                  label: Text(
                                    loadedProduct.tags,
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(33, 140, 116, 1.0)),
                                  ),
                                  backgroundColor:
                                      Colors.black.withOpacity(.1)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(loadedProduct.description),
                    ),
                    QuantitySelect(),

                  ],
                ),
              ),
            ],
          )),
          bottomNavigationBar:     Container(
            height: 60,
            child: RaisedButton(
                          textColor: Colors.white,
                          color: Color.fromRGBO(33, 140, 116, 1.0),
                          child: Text("Add to Cart",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: "Poppins")),
                          onPressed: () {
                            cart.addItem(productId, loadedProduct.price, loadedProduct.title, loadedProduct.images.first,quantity);
                             showDialog(
                               context: context,
                               builder: (ctx) => CustomDialog(title: "Success", description: "Product has been added to your cart", buttonText: "Go to Cart")
                             );
                          },
                        ),
          ),
                    
    );
  }
}
  
class QuantitySelect extends StatefulWidget {
  @override
  _QuantitySelectState createState() => _QuantitySelectState();

  
}

class _QuantitySelectState extends State<QuantitySelect> {



  void _addQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decQuantity() {
    setState(() {
      if (quantity == 1){
        return;
      }
      quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Quantity: ",
            style: TextStyle(fontSize: 20),
          ),
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black.withOpacity(0.06),
                ),
                alignment: Alignment.center,
                width: 40,
                height: 40,
                child: FlatButton(
                  child: Text("-"),
                  onPressed: () => _decQuantity(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  quantity.toString(),
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black.withOpacity(0.06),
                ),
                alignment: Alignment.center,
                width: 40,
                height: 40,
                child: FlatButton(
                    child: Text("+"), onPressed: () => _addQuantity()),
              ),
            ],
          )
        ],
      ),
    );
  }
}
