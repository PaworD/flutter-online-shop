import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class UserScreen extends StatefulWidget {
  static const routeName = "/user-screen";
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Account"),
          centerTitle: true,
          elevation: 10.0,
        ),
        drawer: AppDrawer(),
        body: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 100,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                              minRadius: 40,
                              maxRadius: 40,
                              child: Image.network(
                                  "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",
                                  fit: BoxFit.cover)),
                          Text(
                            "(please write your name)",
                            style: TextStyle(fontSize: 18, fontFamily: "Lato"),
                          ),
                          IconButton(
                              icon: Icon(Icons.mode_edit), onPressed: () {}),
                        ],
                      ))),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Email : useremail@gmail.com",
                    style: TextStyle(color: Colors.grey)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Phone : +9999999999",
                    style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Main", style: TextStyle(color: Colors.grey)),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                child: ListTile(
                  title: Text("My Cards"),
                  leading: Icon(Icons.credit_card),
                  trailing: Text("(0)"),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                child: ListTile(
                  title: Text("My Products"),
                  leading: Icon(Icons.shopping_cart),
                  trailing: Text("(0)"),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                child: ListTile(
                  title: Text("My Orders"),
                  leading: Icon(Icons.shopping_basket),
                  trailing: Text("(0)"),
                  onTap: () {},
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Others", style: TextStyle(color: Colors.grey)),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                child: ListTile(
                  title: Text("My favourites"),
                  leading: Icon(Icons.star),
                  trailing: Text("(0)"),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                child: ListTile(
                  title: Text("My Coupons"),
                  leading: Icon(
                    Icons.card_giftcard,
                  ),
                  trailing: Text("(0)"),
                  onTap: () {},
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Settings", style: TextStyle(color: Colors.grey)),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 0.0),
                child: ListTile(
                  title: Text("Go to Settings",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
                  onTap: () {},
                ),
              ),
                Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 0.0),
                child: ListTile(
                  title: Text("Feedback and rate",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
                  onTap: () {},
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(right: 5.0, left: 0.0),
                child: ListTile(
                  title: Text("Exit",
                      style: TextStyle(color: Colors.redAccent, fontSize: 14)),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ));
  }
}
