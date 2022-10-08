import 'dart:convert';
import 'dart:developer';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:http/http.dart' as http;

class RegisterVehicleService {
  static Future<String> RegisterVehicle(body) async {
    print(body);

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('${URLS.BASE_URL}/vehicle/newvehicle'), body: jsonEncode(body), headers: requestHeaders);

    var data = response.body;

    print(json.decode(data));

    Map<String, dynamic> resData = jsonDecode(data);
    log(resData.toString());

    if (resData['status'] == 'success') {
      final result = resData['status'];

      return result;
    } else {
      final result = resData['error'];
      print(result);
      return result;
    }
    // return true;
  }
}
