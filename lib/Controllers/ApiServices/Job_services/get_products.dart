import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/productModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetProductController {
  static const String url = '${URLS.BASE_URL}/proser/getProducts';

  static Future<List<Product>> getProducts() async {
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {"token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders);
      if (response.statusCode == 200) {
        List<Product> list = parseProducts(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Product> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }
}
