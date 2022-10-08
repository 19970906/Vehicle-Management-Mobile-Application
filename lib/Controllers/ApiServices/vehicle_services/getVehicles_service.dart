import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/vehicleModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetVehicleService {
  static const String url = '${URLS.BASE_URL}/vehicle/getvehicles';

  static Future<List<Vehicle>> getVehicles() async {
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {"token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders);
      if (response.statusCode == 200) {
        List<Vehicle> list = parseVehicles(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Vehicle> parseVehicles(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Vehicle>((json) => Vehicle.fromJson(json)).toList();
  }
}
