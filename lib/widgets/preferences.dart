import 'package:flutter/material.dart';

class Preferences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4.0,
              child: ListView(
            children: <Widget>[
              SwitchListTile(
                
                value: false,
                activeColor: Colors.black,
                inactiveThumbColor: Colors.grey,
                title: Text("Dark mode", style: TextStyle(fontSize: 20.0),),
                subtitle: Text("Enable dark mode"),
                secondary: Icon(Icons.chrome_reader_mode),
                onChanged: (value) {
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
