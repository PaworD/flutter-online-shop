import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/preferences.dart';

class SettingsScreen extends StatelessWidget {
   static const routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings "),
      ),
      drawer: AppDrawer(),
      body: Preferences(),
    );
  }
}