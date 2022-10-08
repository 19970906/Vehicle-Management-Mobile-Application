import 'package:autoassist/Models/customerModel.dart';
import 'package:flutter/material.dart';

class CustomerProvider with ChangeNotifier {
  late Customer _customerModel;

  // ignore: unnecessary_getters_setters
  Customer get customerModel => _customerModel;

  // ignore: unnecessary_getters_setters
  set customerModel(Customer value) {
    _customerModel = value;
  }
}
