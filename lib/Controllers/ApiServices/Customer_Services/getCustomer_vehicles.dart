import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/vehicleModel.dart';
import 'package:http/http.dart' as http;

class GetCustomerVehicles {
  static Future<List<Vehicle>> getVehicles(body) async {
    try {
      Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

      print(body);

      final response = await http.post(
          Uri.parse('${URLS.BASE_URL}/vehicle/getcusvehicle'),
          body: jsonEncode(body),
          headers: requestHeaders);

      if (response.statusCode == 200) {
        List<Vehicle> list = parseVehicle(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  static List<Vehicle> parseVehicle(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Vehicle>((json) => Vehicle.fromJson(json)).toList();
  }
}
