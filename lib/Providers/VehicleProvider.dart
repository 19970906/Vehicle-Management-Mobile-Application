import 'package:autoassist/Models/vehicleModel.dart';
import 'package:flutter/material.dart';

class VehicleProvider with ChangeNotifier {
  late Vehicle _vehicleModel;

  // ignore: unnecessary_getters_setters
  Vehicle get vehicleModel => _vehicleModel;

  // ignore: unnecessary_getters_setters
  set vehicleModel(Vehicle value) {
    _vehicleModel = value;
  }

  void updateODO(String odo) {
    _vehicleModel.odo = odo;
    print("job tot is ${_vehicleModel.odo}");
    notifyListeners();
  }
}
