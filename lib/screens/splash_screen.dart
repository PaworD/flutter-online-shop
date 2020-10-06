import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        child: Image.asset('assets/images/splash.png'),
        fit: BoxFit.fill,
    ));
  }
}
