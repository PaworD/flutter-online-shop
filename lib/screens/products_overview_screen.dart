import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  TextEditingController controllerSearch = new TextEditingController();
  String filter;

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  void initState() {
    controllerSearch.addListener((){
      setState(() {
        filter = controllerSearch.text;
      });
    });
    super.initState();
  }

@override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Shoppy'),

        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),

          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favourites"),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add Product"),
        icon: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(33, 140, 116,1.0),
        onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
      }),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: SingleChildScrollView(
                  child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: new TextFormField(
                        controller: controllerSearch,
                      decoration: new InputDecoration(
                        
                        suffixIcon: Icon(Icons.search),
                        labelText: "Search here...",
                        fillColor: Colors.white10,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Lato",
                      ),
                    ),

                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 20.0, bottom: 5.0),
                          child: Chip(
                            
                            label: Container(
                              width: MediaQuery.of(context).size.width/4 -20,
                              
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(Icons.star, color: Colors.white, size: 12),
                                  ),
                                  Text("Featured", style: TextStyle(fontSize: 13, color: Colors.white,)),
                                ],
                              ),
                            ),
                            
                            backgroundColor: Color.fromRGBO(33, 140, 116,1.0),
                          ),
                        )),
                    ProductsGrid(_showFavoritesOnly, filter),
                  ],
                ),
              )),
    );
  }
}
