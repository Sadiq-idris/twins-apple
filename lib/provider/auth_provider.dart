import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAuthProvider extends ChangeNotifier{
  User? _user;
  final String _adminEmail = "twinsapple094@gmail.com";

  String get adminEmail => _adminEmail;

  // getting usercrediential
  User? get user => _user;

  // setting usercrediential
  set user(User? newUser){
    _user = newUser;
    // notifyListeners();
  }

}