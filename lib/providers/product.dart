import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  List<dynamic> images;
  final String tags;
  double rating;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.images,
    this.tags,
    this.rating = 0.0,
    this.isFavourite = false,
  });

  void _setRating(double newValue) {
    rating = newValue;
    notifyListeners();
  }
    void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://fluuter-udemy.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
    Future<void> toggleRating(String token, String userId) async {
    final oldRating = rating;
    notifyListeners();
    final url = 'https://fluuter-udemy.firebaseio.com/productRating/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(url,
          body: json.encode(
            rating,
          ));
      if (response.statusCode >= 400) {
        _setRating(oldRating);
      }
    } catch (error) {
      _setRating(oldRating);
    }
  }
}
