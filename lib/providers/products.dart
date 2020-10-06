import 'package:flutter/material.dart';
import './product.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

// var _showFavouritesOnly = false;
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favourite {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  List<Product> get featured{
    return _items.where((prodItem) => prodItem.rating > 4.0);
  }
  


  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://fluuter-udemy.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedResponse.isEmpty) {
        _items = [];
        return;
      }
      url =
          'https://fluuter-udemy.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedResponse.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            tags: prodData['tags'],
            isFavourite:
                favouriteData == null ? false : favouriteData[prodId] ?? false,
            images: prodData['images']));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://fluuter-udemy.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'images': product.images,
          'price': product.price,
          'creatorId' : userId,
          'tags' : product.tags,
        }),
      );
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          images: product.images,
          tags: product.tags,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://fluuter-udemy.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'images': newProduct.images,
            'tags': newProduct.tags,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://fluuter-udemy.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    final response = await http.delete(url);

    _items.removeAt(existingProductIndex);
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
