import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/servicesModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetServicesController {
  static const String url = '${URLS.BASE_URL}/proser/getServices';

  static Future<List<Service>> getServices() async {
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {"token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders);
      if (response.statusCode == 200) {
        // Logger().w(response.body);
        List<Service> list = parseServices(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Service> parseServices(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Service>((json) => Service.fromJson(json)).toList();
  }
}
