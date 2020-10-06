import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  final String userId;
  final String token;
   String username;
  String profilePic;
   String phoneNumber;

  User({
    @required this.userId,
    @required this.token,
    this.profilePic,
    this.username,
    this.phoneNumber,
  });

   List<User> users = [];

  User loadUser(String id){
    return users.firstWhere((user) => user.userId == id);
  }

  Future<void> setUserProfile(User user) async {
    final url =
        'https://fluuter-udemy.firebaseio.com/users/$userId.json?auth=$token';
    try {
      final response = http.put(
        url,
        body: json.encode(
          {
            'username': user.username,
            'profilePic': user.profilePic,
            'phoneNumber': user.phoneNumber
          },
        ),
      );

      notifyListeners();
    } catch (e) {}
  }

  Future<void> fetchUser(String id) async {
    final url =
        'https://fluuter-udemy.firebaseio.com/users/$userId.json?auth=$token';
    try {
      final response = await http.get(url);
      print(response.body.toString());
      final extractedResponse =
      json.decode(response.body) as Map<String, dynamic>;
      List<User> dbUser = [];
      extractedResponse.forEach((uID, values){
        dbUser.add(User (
          userId: uID,
          token: json.decode(response.body)['token'],
          username: values['username'],
          phoneNumber: values['phoneNumber'],
          profilePic: values['profilePic'],
        ));
        users = dbUser;
        notifyListeners();
      });

    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> updateProfile(String userId, User user) async {
    final url =
        'https://fluuter-udemy.firebaseio.com/users/$userId.json?auth=$token';
    await http.patch(url,
        body: json.encode({
          'username': user.username,
          'phoneNumber': user.phoneNumber,
          'profilePic': user.profilePic,
        }));
    notifyListeners();
  }
}
