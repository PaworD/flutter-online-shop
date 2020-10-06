import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/user_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';


class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
final userData = Provider.of<Auth>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Your ID'),
            accountEmail: Text(userData.userId),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/splash.png",),
              backgroundColor: Colors.transparent,
            ),
            otherAccountsPictures: <Widget>[
              IconButton(
                  highlightColor: Colors.black26,
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(SettingsScreen.routeName);
                  },
                  color: Colors.black),
            ],
          ),
          ListTile(
            leading: Icon(Icons.account_circle, color: Color.fromRGBO(33, 140, 116,1.0)),
            title: Text('My Profile'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserScreen.routeName);
            },
          ),         
          ListTile(
            leading: Icon(Icons.shop, color: Color.fromRGBO(33, 140, 116,1.0)),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          
          ListTile(
            leading: Icon(Icons.payment, color: Color.fromRGBO(33, 140, 116,1.0)),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          
          ListTile(
            leading: Icon(Icons.edit, color: Color.fromRGBO(33, 140, 116,1.0)),
            title: Text('ManageProducts'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Color.fromRGBO(33, 140, 116,1.0)),
            title: Text('Log out'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
