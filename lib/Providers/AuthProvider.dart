import 'package:autoassist/Models/userModel.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _userModel;

  // ignore: unnecessary_getters_setters
  UserModel get userModel => _userModel;

  // ignore: unnecessary_getters_setters
  set userModel(UserModel value) {
    _userModel = value;
  }
}
